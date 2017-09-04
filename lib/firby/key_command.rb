# frozen_string_literal: true
# encoding: UTF-8

module Firby
  module KeyCommand
    def self.build(character, state)
      KeyCommandRegistery
        .find(character)
        .new(character, state)
    end

    class KeyCommandRegistery
      def self.find(character)
        all.detect { |key_command| key_command.match?(character) }
      end

      def self.all
        [
          TabCommand,
          EnterCommand,
          BackspaceCommand,
          CtrlCCommand,
          EscapeCommand,
          SingleKeyCommand
        ]
      end
    end

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
        state
      end
    end

    class TabCommand < BaseCommand
      def self.match?(_character)
        false
      end
    end

    class BackspaceCommand < BaseCommand
      def self.char_code
        /^\177$/
      end

      def execute
        removed = state.lines[-1].pop
        if removed
          state.cursor = state.cursor.left(1)
        elsif state.lines.length > 1
          state.lines.pop
          state.cursor = state.cursor.up.right(state.lines[-1].length)
        end
        state
      end
    end

    class EnterCommand < BaseCommand
      def self.char_code
        /^\r$/
      end

      def execute
        current_line = state.lines[-1].dup
        state.lines.push([])
        state.cursor = state.cursor.down.left(current_line.length)
        state
      end
    end

    class EscapeCommand < BaseCommand
      def self.match?(_character)
        false
      end
    end

    class SingleKeyCommand < BaseCommand
      def self.char_code
        # Matches all printable ASCII characters
        /[ -~]/
      end

      def execute
        current_line = state.lines[-1].dup
        current_line << character
        state.lines[-1] = current_line
        state.cursor = state.cursor.right(1)
        state
      end
    end

    class CtrlCCommand < BaseCommand
      def self.char_code
        /^\u0003$/
      end

      def execute
        exit(0)
      end
    end
  end
end
