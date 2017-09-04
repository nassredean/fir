# frozen_string_literal: true
# encoding: UTF-8

require 'ripper'

module Firby
  class Indent
    attr_reader :lines

    SPACES = '  '

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
    }.freeze

    SINGLELINE_TOKENS = %w[if while until unless rescue].freeze
    MIDWAY_TOKENS = %w[when else elsif ensure rescue].freeze
    OPTIONAL_DO_TOKENS = %w[for while until].freeze

    def initialize(lines)
      @lines = lines
    end

    def indent_lines
      string_delimiter = nil
      indentation_deltas = []
      indentation_delta = 0
      token_stack = []
      lines.each do |line|
        if string_delimiter
          # push the open delimeter onto the line for tokenization
          tokens = Ripper.lex("#{string_delimiter}\n#{line}")
          # remove the open delimeter token
          tokens = tokens[1..-1]
        else
          tokens = Ripper.lex(line)
        end
        indentation_deltas << indentation_delta
        seen_for_at = []
        tokens.each do |(_, column), type, token|
          is_optional_do = (token == 'do' &&
                            seen_for_at.include?(indentation_delta - 1))
          seen_for_at << indentation_delta if OPTIONAL_DO_TOKENS.include?(token)
          next if single_line_token?(token, column)
          if string_begining?(type)
            string_delimiter = token
          elsif string_end?(type)
            string_delimiter = nil
          elsif open_token?(token, column) && !is_optional_do
            token_stack << token
            indentation_delta += 1
          elsif closing_token?(token_stack, token)
            token_stack.pop
            indentation_delta -= indentation_delta - 1
            indentation_deltas[-1] = indentation_deltas[-1] - 1
          elsif midway_token?(token)
            indentation_deltas[-1] = indentation_deltas[-1] - 1
          end
        end
      end
      indentation_deltas
    end

    private

    def single_line_token?(token, column)
      SINGLELINE_TOKENS.include?(token) && (column != 0)
    end

    def string_begining?(type)
      type == :on_tstring_beg
    end

    def string_end?(type)
      type == :on_tstring_end
    end

    def open_token?(token, column)
      OPEN_TOKENS.keys.include?(token) &&
        !single_line_token?(token, column)
    end

    def closing_token?(stack, token)
      token == OPEN_TOKENS[stack.last]
    end

    def midway_token?(token)
      MIDWAY_TOKENS.include?(token)
    end
  end
end
