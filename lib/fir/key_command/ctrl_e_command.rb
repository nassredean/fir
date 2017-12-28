# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class CtrlECommand < KeyCommand
    def self.character_regex
      /^\x05$/
    end

    def execute_hook(new_state)
      unless state.blank?
        new_state.cursor = state.cursor.right(state.current_line.length - state.cursor.x)
      end
      new_state
    end
  end
end
