# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class TabCommand < KeyCommand
    def self.character_regex
      /^\t$/
    end

    def execute_hook(new_state)
      new_state.current_line = state.current_line.clone.insert(
        state.cursor.x,
        *state.suggestion.split('')
      ).flatten
      new_state.cursor = state.cursor.right(state.suggestion.length)
      new_state
    end
  end
end
