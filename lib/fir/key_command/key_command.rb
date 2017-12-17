# frozen_string_literal: true
# encoding: UTF-8

class Fir
  class KeyCommand
    attr_reader :character
    attr_reader :state

    def self.build(character, state)
      find(character).new(character, state)
    end

    def self.for(character, state)
      registry.find do |candidate|
        candidate.handles?(character)
      end.new(character, state)
    end

    def self.registry
      @@registry ||= []
    end

    def self.register(candidate)
      registry.unshift(candidate)
    end

    def self.inherited(candidate)
      register(candidate)
    end

    def self.handles?(character)
      character_regex.match(character)
    end

    def self.character_regex
      /.*/
    end

    def initialize(character, state)
      @character = character
      @state = state
    end

    def execute
      execute_hook(state.clone)
    end
  end
end

require_relative './backspace_command'
require_relative './ctrl_c_command'
require_relative './enter_command'
require_relative './single_key_command'
