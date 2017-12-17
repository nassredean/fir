# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class CtrlZCommand < KeyCommand
    def self.character_regex
      /^\u001A$/
    end

    def execute_hook(new_state)
      `kill -TSTP #{Process.pid}`
      new_state
    end
  end
end
