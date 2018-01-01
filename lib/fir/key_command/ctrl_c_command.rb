# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class CtrlCCommand < KeyCommand
    def self.character_regex
      /^\u0003$/
    end

    def execute_hook(new_state)
      new_state.history.reset
      new_state.blank
    end
  end
end
