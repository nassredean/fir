# frozen_string_literal: true
# encoding: UTF-8

require 'io/console'
require 'ripper'

# A better architecture would be as follows:
# The handlers publish updates to the cursor position and lines, tracked inside of some sort of state object
# Each time updates are published, Output modifiers (such as Indenter and Prompter are notified)
# The new output modifiers recompute what the screen should look like and then the screen is redrawn

module Firby
  class Repl
    def self.start(input, output)
      new(input, output)
    end

    def initialize(input, output)
      with_raw_io(input, output) do |i, o|
        repl([[]], i, o)
      end
    end

    private

    def with_raw_io(input, output)
      input.raw do |i|
        output.raw do |o|
          return yield(i, o) if block_given?
        end
      end
    end

    def repl(lines, input, output)
      lines = yield(lines) if block_given?
      repl(lines, input, output) do |l|
        read_and_dispatch_key(l, input, output)
      end
    end

    def read_and_dispatch_key(lines, input, output)
      char = get_char_from_key(input)
      KeyCommandFactory.build(char, lines, input, output).execute
    end

    def get_char_from_key(input)
      key = input.sysread(1).chr
      if key == "\e"
        special_key_thread = Thread.new do
          2.times { key += input.sysread(1).chr }
        end
        special_key_thread.join(0.0001)
        special_key_thread.kill
      end
      key
    end
  end

  class KeyCommandFactory
    def self.build(character, lines, input, output)
      KeyCommandRegistery
        .find(character)
        .new(character, lines, input, output)
    end
  end

  class KeyCommandRegistery
    def self.find(character)
      all.detect { |handler| handler.match?(character) }
    end

    def self.all
      [
        TabCommand,
        EnterCommand,
        BackspaceCommand,
        CtrlCCommand,
        EscapeCommand,
        SingleKeyCommand
      ]
    end
  end

  class KeyCommand
    attr_reader :character
    attr_reader :lines
    attr_reader :input
    attr_reader :output

    def self.match?(character)
      char_code.match(character)
    end

    def self.char_code
      /^.*$/
    end

    def initialize(character, lines, input, output)
      @character = character.dup
      @lines = lines.dup
      @input = input
      @output = output
    end

    def execute
      lines
    end
  end

  class TabCommand < KeyCommand
    def self.match?(_character)
      false
    end
  end

  class BackspaceCommand < KeyCommand
    def self.char_code
      /^\177$/
    end

    def execute
      current_line = lines[-1].dup
      removed = current_line.pop
      if removed
        lines[-1] = current_line
        output.syswrite("#{Cursor.back(1)}#{Cursor.clear(0)}")
      elsif lines.length > 1
        lines.pop
        current_line = lines[-1]
        if current_line.length >= 1
          output.syswrite("#{Cursor.up(1)}#{Cursor.forward(lines[-1].length)}")
        else
          output.syswrite("#{Cursor.up(1)}")
        end
      end
      lines
    end
  end

  class EnterCommand < KeyCommand
    def self.char_code
      /^\r$/
    end

    def execute
      lines << []
      output.syswrite("\n" + Cursor.back(lines[-2].length))
      lines
    end
  end

  class EscapeCommand < KeyCommand
    def self.match?(_character)
      false
    end
  end

  class SingleKeyCommand < KeyCommand
    def self.char_code
      # Matches all printable ASCII characters
      /[ -~]/
    end

    def execute
      current_line = lines[-1].dup
      current_line << character
      lines[-1] = current_line
      output.syswrite(character)
      lines
    end
  end

  class CtrlCCommand < KeyCommand
    def self.char_code
      /^\u0003$/
    end

    def execute
      exit(0)
    end
  end

  class Cursor
    def self.forward(n)
      "\e[#{n}C"
    end

    def self.back(n)
      "\e[#{n}D"
    end

    def self.up(n)
      "\e[#{n}A"
    end

    def self.clear(n)
      "\e[#{n}K"
    end
  end

  class Indent
    # The stack of open tokens.
    attr_reader :stack
    # The lines of code to parse
    attr_reader :lines
    # The indentation to append to the next line
    attr_reader :indentation
    # The amount of spaces to insert for each indent level.
    SPACES = '  '
    # Hash containing all the tokens that should increase the indentation level.
    # Key is open token, value is corresponding close token.
    OPEN_TOKENS = {
      'def'    => 'end',
      'class'  => 'end',
      'module' => 'end',
      'do'     => 'end',
      'if'     => 'end',
      'unless' => 'end',
      'while'  => 'end',
      'until'  => 'end',
      'for'    => 'end',
      'case'   => 'end',
      'begin'  => 'end',
      '['      => ']',
      '{'      => '}',
      '('      => ')'
    }
    # Open tokens which can appear as modifiers on a single-line.
    SINGLELINE_TOKENS = %w(if while until unless rescue)
    # Collection of tokens that should appear dedented even though they don't affect the surrounding code.
    MIDWAY_TOKENS = %w(when else elsif ensure rescue)
    # Which tokens can be followed by an optional "do" keyword.
    OPTIONAL_DO_TOKENS = %w(for while until)

    def initialize(lines)
      @lines = lines.map(&:join)
      @stack = []
      @string_start = nil
      @indentation_delta = 0
      @should_dedent = false
      @indentation = indent
    end

    # Returns true if the lines form a complete AST
    def should_evaluate?
      @indentation_delta == 0 && !in_string?
    end

    # Returns true if the last line should be dedented
    def should_dedent?
      @should_dedent
    end

    private

    # Compute the indentation of the last line
    def indent
      lines.each do |line|
        @should_dedent = false
        if in_string?
          # push the open delimeter onto the line for tokenization
          tokens = tokenize("#{@string_start}\n#{line}")
          # remove the open delimeter token
          tokens = tokens [1..-1]
        else
          tokens = tokenize(line)
        end
        compute_deltas(tokens)
      end
      SPACES * @indentation_delta
    end

    # Are we currently inside a string
    def in_string?
      !!@string_start
    end

    # Use ripper to tokenize input
    def tokenize(code)
      Ripper.lex(code)
    end

    # Compute the indentation delta for the given line
    # Compute whether we should dedent the line
    def compute_deltas(tokens)
      seen_for_at = []
      tokens.each do |(line, column), type, token|
        is_optional_do = (token == "do" && seen_for_at.include?(@indentation_delta - 1))
        seen_for_at << @indentation_delta if OPTIONAL_DO_TOKENS.include?(token)
        next if is_single_line_token?(token, column)
        if is_string_begining?(type)
          @string_start = token
        elsif is_string_end?(type)
          @string_start = nil
        elsif is_open_token?(token, column) && !is_optional_do
          @stack << token
          @indentation_delta += 1
        elsif is_closing_token?(token)
          popped = @stack.pop
          @indentation_delta = @indentation_delta - 1
          @should_dedent = true
        elsif is_midway_token?(token)
          @should_dedent = true
        end
      end
    end

    def is_single_line_token?(token, column)
      (SINGLELINE_TOKENS.include?(token)) && (column != 0)
    end

    def is_string_begining?(type)
      type == :on_tstring_beg
    end

    def is_string_end?(type)
      type == :on_tstring_end
    end

    def is_open_token?(token, column)
      OPEN_TOKENS.keys.include?(token) &&
        !is_single_line_token?(token, column)
    end

    def is_closing_token?(token)
      token == OPEN_TOKENS[@stack.last]
    end

    def is_midway_token?(token)
      MIDWAY_TOKENS.include?(token)
    end

    def is_optional_do?(token, column)
      token == 'do'
    end
  end
end
