# frozen_string_literal: true
# encoding: UTF-8

require_relative './base_command'
require 'pry'

class Fir
  module KeyCommand
    class BackspaceCommand < BaseCommand
      def self.char_code
        /^\177$/
      end

      def execute_hook(new_state)
        return new_state if state.blank?
        if state.cursor.x.positive?
          new_state.cursor.left(1)
          new_state.lines.remove_char
        elsif state.cursor.x.zero? && state.cursor.y.positive?
          binding.pry
          new_state.cursor.up.right(state.lines[-2].length)
          new_state.lines.remove
        end
      end
    end
  end
end
