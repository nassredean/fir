# frozen_string_literal: true
# encoding: UTF-8

class Fir
  module KeyCommand
    class BaseCommand
      attr_reader :character
      attr_reader :state

      def self.match?(character)
        char_code.match(character)
      end

      def self.char_code
        /^.*$/
      end

      def initialize(character, state)
        @character = character
        @state = state
      end

      def execute
        new_state = state.clone
        execute_hook(new_state)
        new_state
      end
    end
  end
end
