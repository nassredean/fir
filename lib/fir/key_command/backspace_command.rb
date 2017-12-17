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
          new_state.lines[-1] = state.lines[-1].clone[0...-1]
        elsif state.cursor.x.zero? && state.cursor.y.positive?
          new_state.cursor = state.cursor.up.right(state.lines[-2].length)
          new_state.lines = state.lines.remove
        end
      end
      new_state
    end
  end
end
