# frozen_string_literal: true
# encoding: UTF-8

require_relative './base_command'

class Fir
  module KeyCommand
    class CtrlCCommand < BaseCommand
      def self.char_code
        /^\u0003$/
      end

      def execute_hook(_)
        exit(0)
      end
    end
  end
end
