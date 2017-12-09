# frozen_string_literal: true
# encoding: UTF-8

require_relative 'lines'
require_relative 'cursor'
require_relative 'indent'

module Fir
  class ReplState
    attr_accessor :lines
    attr_accessor :cursor
    attr_reader :indent
    attr_reader :repl_binding

    def self.blank
      new(Lines.blank, Cursor.blank, TOPLEVEL_BINDING)
    end

    def initialize(lines, cursor, repl_binding)
      @lines = lines
      @cursor = cursor
      @repl_binding = repl_binding
      set_indent
    end

    def transition(command)
      new_state = command.execute
      new_state.set_indent
      yield new_state if block_given?
      return blank if new_state.executable?
      new_state
    end

    def clone
      self.class.new(lines.clone, cursor.clone, repl_binding)
    end

    def blank
      self.class.new(Lines.blank, Cursor.blank, repl_binding)
    end

    def blank?
      lines.blank? && cursor.blank?
    end

    def ==(other)
      lines == other.lines && cursor == other.cursor
    end

    def indents
      indent.indents
    end

    def executable?
      indent.executable?
    end

    protected

    def set_indent
      @indent = compute_indent
    end

    private

    def compute_indent
      Fir::Indent.new(lines.map(&:join)).generate
    end
  end
end
