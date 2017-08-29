# frozen_string_literal: true
# encoding: UTF-8

require 'io/console'
# --TODO: Get backspace working

module Firby
  class Repl
    def self.start(input, output)
      firby = self.new(input, output)
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
    /.*/
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
  def self.match?(_character)
    false
  end
end

class EnterCommand < KeyCommand
  def self.char_code
    /\r/
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
    /\u0003/
  end

  def execute
    exit(0)
  end
end

class Cursor
  def self.back(n)
    "\e[#{n}D"
  end
end
