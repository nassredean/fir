# frozen_string_literal: true
# encoding: UTF-8

require 'io/console'
require_relative 'firby/indent.rb'
require_relative 'firby/key_command.rb'
require_relative 'firby/screen.rb'
require_relative 'firby/repl_state.rb'

module Firby
  class Repl
    def self.start(input, output)
      new(input, output)
    end

    def initialize(input, output)
      with_raw_io(input, output) do |i, o|
        repl(ReplState.new_state, i, o)
      end
    end

    private

    def with_raw_io(input, output)
      input.raw do |i|
        output.raw do |o|
          return yield(i, o) if block_given?
        end
      end
    end

    def repl(state, input, output)
      state = yield(state) if block_given?
      repl(state, input, output) do
        read_and_dispatch_key(state, input, output)
      end
    end

    def read_and_dispatch_key(state, input, output)
      char = get_char_from_key(input)
      new_state = KeyCommand.build(char.dup, state.clone).execute
      Screen.update(state, new_state, output)
      new_state
    end

    def get_char_from_key(input)
      key = input.sysread(1).chr
      if key == "\e"
        special_key_thread = Thread.new do
          2.times { key += input.sysread(1).chr }
        end
        special_key_thread.join(0.0001)
        special_key_thread.kill
      end
      key
    end
  end
end
