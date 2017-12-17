# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class CtrlCCommand < KeyCommand
    def self.character_regex
      /^\u0003$/
    end

    def execute_hook(_)
      exit(0)
    end
  end
end
