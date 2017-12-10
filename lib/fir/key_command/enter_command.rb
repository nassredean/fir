# frozen_string_literal: true
# encoding: UTF-8

require_relative './base_command'

class Fir
  module KeyCommand
    class EnterCommand < BaseCommand
      def self.char_code
        /^\r$/
      end

      def execute_hook(new_state)
        new_state.lines.add([])
        new_state.cursor.down.left(state.lines[-1].length)
      end
    end
  end
end
