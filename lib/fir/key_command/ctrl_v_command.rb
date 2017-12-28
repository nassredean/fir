# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class CtrlVCommand < KeyCommand
    def self.character_regex
      /^\u0016$/
    end

    def execute_hook(new_state)
      paste_buffer = `pbpaste`
      new_state.lines[state.cursor.y] =
        state.lines[state.cursor.y].clone.insert(state.cursor.x, *paste_buffer.split('')).flatten
      new_state.cursor = state.cursor.right(paste_buffer.length)
      new_state
    end
  end
end
