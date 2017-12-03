# frozen_string_literal: true
# encoding: UTF-8

require 'io/console'

require_relative 'fir/key'
require_relative 'fir/key_command/key_command'
require_relative 'fir/repl_state'
require_relative 'fir/screen'

module Fir
  class Repl
    def self.start(input, output, error)
      new(Key.new(input), Screen.new(output, error))
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
