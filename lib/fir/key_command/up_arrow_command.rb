# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class UpArrowCommand < KeyCommand
    def self.character_regex
      /^\e\[A$/
    end

    def execute_hook(new_state)
      new_state.history.up
      new_state
    end
  end
end
