# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class EnterCommand < KeyCommand
    def self.character_regex
      /^\r$/
    end

    def execute_hook(new_state)
      new_state.commit_current_line_to_history
      new_state.lines = state.lines.add([])
      new_state.cursor = state.cursor.down.left(state.cursor.x)
      new_state.history.reset
      new_state
    end
  end
end
