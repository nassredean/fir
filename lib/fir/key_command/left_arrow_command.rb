# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class LeftArrowCommand < KeyCommand
    def self.character_regex
      [/^\e\[D$/, /^\x02$/]
    end

    def execute_hook(new_state)
      unless state.blank?
        new_state.cursor = state.cursor.left(1) if state.cursor.x.positive?
      end
      new_state
    end
  end
end
