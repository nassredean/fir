# frozen_string_literal: true
# encoding: UTF-8

require 'io/console'
require_relative 'fir/key'
require_relative 'fir/key_command/key_command'
require_relative 'fir/repl_state'
require_relative 'fir/screen'

class Fir
  attr_reader :key
  attr_reader :screen

  def self.start(input, output, error)
    new(
      Key.new(input),
      Screen.new(output, error)
    ).perform(ReplState.blank)
  end

  def initialize(key, screen)
    @key = key
    @screen = screen
  end

  def perform(state)
    state = yield(state) if block_given?
    perform(state) do
      state.transition(KeyCommand.for(key.get, state)) do |new_state|
        screen.update(state, new_state)
      end
    end
  end
end
