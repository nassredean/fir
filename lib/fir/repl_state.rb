# frozen_string_literal: true
# encoding: UTF-8

require_relative 'lines'
require_relative 'cursor'
require_relative 'indent'
require_relative 'history'
require_relative 'suggestion'

class Fir
  class ReplState
    attr_accessor :lines, :cursor
    attr_reader :indent, :repl_binding, :history

    def self.blank
      new(Lines.blank, Cursor.blank)
    end

    def initialize(
      lines,
      cursor,
      repl_binding = TOPLEVEL_BINDING,
      history = Fir::History.new
    )
      @lines = lines
      @cursor = cursor
      @repl_binding = repl_binding
      @history =  history
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
      self.class.new(
        lines.clone,
        cursor.clone,
        repl_binding,
        history
      )
    end

    def blank
      self.class.new(
        Lines.blank,
        Cursor.blank,
        repl_binding,
        history
      )
    end

    def blank?
      lines.blank? && cursor.blank?
    end

    def ==(other)
      lines == other.lines && cursor == other.cursor
    end

    def current_line=(new_line)
      lines[cursor.y] = new_line
    end

    def current_line
      lines[cursor.y]
    end

    def indents
      indent.indents
    end

    def executable?
      indent.executable?
    end

    def suggestion
      history.suggestion(current_line.join)
    end

    def commit_current_line_to_history
      Fir::History.add_line_to_history_file(
        current_line.join
      )
    end

    protected

    def set_indent
      @indent = get_indent
    end

    def get_indent
      Fir::Indent.new(lines.map(&:join)).generate
    end
  end
end
