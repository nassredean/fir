# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class CtrlACommand < KeyCommand
    def self.character_regex
      /^\x01$/
    end

    def execute_hook(new_state)
      unless state.blank?
        if state.cursor.x.positive?
          new_state.cursor = state.cursor.left(state.cursor.x)
        end
      end
      new_state
    end
  end
end
