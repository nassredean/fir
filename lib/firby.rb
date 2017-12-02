# frozen_string_literal: true
# encoding: UTF-8

require 'io/console'
require_relative 'firby/indent'
require_relative 'firby/key_command/key_command'
require_relative 'firby/screen'
require_relative 'firby/repl_state'
require_relative 'firby/key'

module Firby
  class Repl
    def self.start(input, output)
      new(Key.new(input), Screen.new(output))
    end

    def initialize(key, screen)
      repl(ReplState.blank, key, screen)
    end

    private

    def repl(state, key, screen)
      state = yield(state) if block_given?
      repl(state, key, screen) do
        state.transition(KeyCommand.build(key.get, state)) do |new_state|
          screen.update(state, new_state)
        end
      end
    end
  end
end
