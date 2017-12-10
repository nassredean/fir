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
      return blank if new_state.lines.executable?
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
  end
end
