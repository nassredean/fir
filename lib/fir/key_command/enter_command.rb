# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class EnterCommand < KeyCommand
    def self.character_regex
      /^\r$/
    end

    def execute_hook(new_state)
      new_state.lines = state.lines.add([])
      new_state.cursor = state.cursor.down.left(state.lines[-1].length)
      new_state
    end
  end
end
