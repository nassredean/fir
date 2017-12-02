# frozen_string_literal: true
# encoding: UTF-8

require 'ripper'

module Fir
  class Indent
    attr_reader :lines
    attr_reader :stack
    attr_reader :delimiter_stack
    attr_reader :array_stack
    attr_reader :paren_stack

    def initialize(lines)
      @lines = lines
      @stack = []
      @delimiter_stack = []
      @array_stack = []
      @paren_stack = []
    end

    OPEN_TOKENS = %w[if while for until unless def class module begin].freeze
    OPTIONAL_DO_TOKENS = %w[for while until].freeze
    WHEN_MIDWAY_TOKEN = %w[else when].freeze
    IF_MIDWAY_TOKEN = %w[else elsif].freeze
    BEGIN_MIDWAY_TOKEN = %w[rescue ensure else].freeze
    BEGIN_IMPLICIT_TOKEN = %w[rescue ensure].freeze

    def generate
      lines.each.with_index.with_object([]) do |(line, line_index), deltas|
        delta = stack.length
        delta += array_stack.length if in_array?
        delta += paren_stack.length if in_paren?
        line.split(' ').each_with_index do |word, word_index|
          token = construct_token(word, word_index, line_index)
          if any_open?(token)
            stack.push(token)
          elsif any_midway?(token)
            delta -= 1
          elsif any_close?(token)
            delta -= 1
            stack.pop
          elsif string_open_token?(token)
            delimiter_stack.push(token)
          elsif string_close_token?(token)
            delimiter_stack.pop
          elsif open_array_token?(token)
            array_stack.push(token)
          elsif close_array_token?(token)
            delta -= 1 if array_stack.last.position.y != token.position.y
            array_stack.pop
          elsif open_paren_token?(token)
            paren_stack.push(token)
          elsif close_paren_token?(token)
            delta -= 1 if paren_stack.last.position.y != token.position.y
            paren_stack.pop
          end
        end
        deltas << delta
      end
    end

    private

    def construct_token(word, word_index, line_index)
      position = Position.new(word_index, line_index)
      Token.new(word, position)
    end

    def any_open?(token)
      !in_string? &&
        open_token?(token) ||
        when_open_token?(token) ||
        unmatched_do_token?(token)
    end

    def any_midway?(token)
      !in_string? &&
        if_midway_token?(token) ||
        begin_midway_token?(token) ||
        when_midway_token?(token)
    end

    def any_close?(token)
      !in_string? &&
        closing_token?(token) ||
        when_close_token?(token)
    end

    def string_open_token?(token)
      (token.word[0] == '\'' || token.word[0] == '"') &&
        !((token.word.length > 1) && token.word[-1] == token.word[0]) &&
        !in_string?
    end

    def string_close_token?(token)
      in_string? &&
        ((token.word[-1] == delimiter_stack.last.word[0]) && (token.word[-2] != "\\"))
    end

    def open_array_token?(token)
      !in_string? &&
        token.word[0] == '['
    end

    def close_array_token?(token)
      !in_string? &&
        in_array? &&
        token.word[-1] == ']'
    end

    def open_paren_token?(token)
      !in_string? &&
        token.word[0] == '{'
    end

    def close_paren_token?(token)
      !in_string? &&
        in_paren? &&
        token.word[-1] == '}'
    end

    def in_array?
      array_stack.length.positive?
    end

    def in_string?
      delimiter_stack.length.positive?
    end

    def in_paren?
      paren_stack.length.positive?
    end

    def open_token?(token)
      OPEN_TOKENS.include?(token.word) && token.position.x.zero?
    end

    def closing_token?(token)
      token.word == 'end' && stack.last && token.position.x.zero?
    end

    def unmatched_do_token?(token)
      return false unless token.word == 'do'
      !(OPTIONAL_DO_TOKENS.include?(stack.last&.word) &&
        (token.position.y == stack.last&.position&.y))
    end

    def when_open_token?(token)
      return false unless token.word == 'when' && token.position.x.zero?
      stack.last&.word != 'when'
    end

    def when_midway_token?(token)
      return false unless WHEN_MIDWAY_TOKEN.include?(token.word) && token.position.x.zero?
      return false unless stack.last&.word == 'when'
      true
    end

    def when_close_token?(token)
      return false unless token.word == 'end' && token.position.x.zero?
      return false unless stack.last&.word == 'when'
      true
    end

    def if_midway_token?(token)
      return false unless IF_MIDWAY_TOKEN.include?(token.word) && token.position.x.zero?
      return false unless stack.last&.word == 'if'
      true
    end

    def begin_midway_token?(token)
      return false unless token.position.x.zero? && stack.last
      (BEGIN_MIDWAY_TOKEN.include?(token.word) && stack.last.word == 'begin') ||
        BEGIN_IMPLICIT_TOKEN.include?(token.word)
    end

    Token = Struct.new(:word, :position)
    Position = Struct.new(:x, :y)
  end
end
