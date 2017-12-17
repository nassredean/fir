# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class CtrlDCommand < KeyCommand
    def self.character_regex
      /^\u0004$/
    end

    def execute_hook(_)
      exit(0)
    end
  end
end
