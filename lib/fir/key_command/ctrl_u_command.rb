# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class CtrlUCommand < KeyCommand
    def self.character_regex
      /^\u0015$/
    end

    def execute_hook(new_state)
      if !state.blank? && state.cursor.x.positive?
        new_state.cursor = state.cursor.left(state.cursor.x)
        new_line = state.current_line.clone.drop(state.cursor.x)
        new_state.current_line = new_line
      end
      new_state
    end
  end
end
