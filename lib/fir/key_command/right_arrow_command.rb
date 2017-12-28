# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class RightArrowCommand < KeyCommand
    def self.character_regex
      [/^\e\[C$/, /^\x06$/]
    end

    def execute_hook(new_state)
      unless state.blank?
        if state.cursor.x < state.lines[state.cursor.y].length
          new_state.cursor = state.cursor.right(1)
        end
      end
      new_state
    end
  end
end
