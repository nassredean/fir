# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class DownArrowCommand < KeyCommand
    def self.character_regex
      /^\e\[B$/
    end

    def execute_hook(new_state)
      new_state.history.down
      new_state
    end
  end
end
