# frozen_string_literal: true
# encoding: UTF-8

require_relative './base_command'

class Fir
  module KeyCommand
    class SingleKeyCommand < BaseCommand
      def self.char_code
        # Matches all printable ASCII characters
        /[ -~]/
      end

      def execute_hook(new_state)
        new_state.lines.add_char(character)
        new_state.cursor.right(1)
      end
    end
  end
end
