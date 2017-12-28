# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class BackspaceCommand < KeyCommand
    def self.character_regex
      /^\177$/
    end

    def execute_hook(new_state)
      unless state.blank?
        if state.cursor.x.positive?
          new_state.cursor = state.cursor.left(1)
          new_line = state.current_line.clone
          new_line.delete_at(state.cursor.x - 1)
          new_state.current_line = new_line
        elsif state.cursor.x.zero? && state.cursor.y.positive?
          new_state.cursor =
            state.cursor.up.right(state.lines[state.cursor.y - 1].length)
          new_state.lines = state.lines.remove
        end
      end
      new_state
    end
  end
end
