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
        state.transition do |new_state|
          unless state.blank?
            if state.cursor.x.positive?
              new_state.cursor = state.cursor.left(1)
              new_state.lines[-1] = state.lines[-1].remove
            elsif state.cursor.x.zero? && state.cursor.y.positive?
              new_state.cursor = state.cursor.up.right(state.lines[-2].length)
              new_state.lines = state.lines.remove
            end
          end
        end
      end
    end

    class EnterCommand < BaseCommand
      def self.char_code
        /^\r$/
      end

      def execute
        state.transition do |new_state|
          new_state.lines = state.lines.add(Firby::Line.blank)
          new_state.cursor = state.cursor.down.left(state.lines[-1].length)
        end
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
        state.transition do |new_state|
          new_state.lines[-1] = state.lines[-1].add(character)
          new_state.cursor = state.cursor.right(1)
        end
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
