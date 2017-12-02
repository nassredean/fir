# frozen_string_literal: true
# encoding: UTF-8

require_relative 'lines'
require_relative 'cursor'
require_relative 'indent'

module Fir
  class ReplState
    attr_accessor :lines
    attr_accessor :cursor
    attr_reader :deltas

    def self.blank
      new(Lines.blank, Cursor.blank)
    end

    def initialize(lines, cursor)
      @lines = lines
      @cursor = cursor
      set_indent
    end

    def transition(command)
      new_state = command.execute
      new_state.set_indent
      yield new_state if block_given?
      return blank if new_state.block?
      new_state
    end

    def clone
      self.class.new(lines.clone, cursor.clone)
    end

    def blank
      self.class.new(Lines.blank, Cursor.blank)
    end

    def blank?
      lines.blank? && cursor.blank?
    end

    def block?
      deltas.length > 1 && deltas[-1].zero?
    end

    def ==(other)
      lines == other.lines && cursor == other.cursor
    end

    protected

    def set_indent
      @deltas = compute_indent
    end

    private

    def compute_indent
      Fir::Indent.new(lines.map(&:join)).generate
    end
  end
end
