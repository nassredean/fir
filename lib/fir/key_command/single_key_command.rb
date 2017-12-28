# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class SingleKeyCommand < KeyCommand
    def self.character_regex
      # Matches all printable ASCII characters
      /[ -~]/
    end

    def execute_hook(new_state)
      new_state.current_line = state.lines[-1].clone.insert(state.cursor.x, character)
      new_state.cursor = state.cursor.right(1)
      new_state
    end
  end
end
