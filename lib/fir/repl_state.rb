# frozen_string_literal: true
# encoding: UTF-8

require_relative 'lines'
require_relative 'cursor'

class Fir
  class ReplState
    attr_accessor :lines
    attr_accessor :cursor
    attr_reader :repl_binding

    def self.blank
      new(Lines.blank, Cursor.blank, TOPLEVEL_BINDING)
    end

    def initialize(lines, cursor, repl_binding)
      @lines = lines
      @cursor = cursor
      @repl_binding = repl_binding
    end

    def transition(command)
      new_state = command.execute
      yield new_state if block_given?
      new_state.blank!
    end

    def clone
      self.class.new(lines.clone, cursor.clone, repl_binding)
    end

    def blank!
      if lines.executable?
        cursor.blank!
        lines.blank!
        lines.indent!(cursor)
      end
      self
    end

    def blank?
      lines.blank? && cursor.blank?
    end

    def ==(other)
      lines == other.lines && cursor == other.cursor
    end
  end
end
