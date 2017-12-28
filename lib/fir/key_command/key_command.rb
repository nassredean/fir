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
      @registry ||= [KeyCommand]
    end

    def self.register(candidate)
      registry.unshift(candidate)
    end

    def self.inherited(candidate)
      register(candidate)
    end

    def self.handles?(character)
      Array(character_regex).any? { |re| re.match(character) }
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

    def execute_hook(new_state)
      new_state
    end
  end
end

require_relative './single_key_command'
require_relative './enter_command'
require_relative './backspace_command'
require_relative './ctrl_c_command'
require_relative './ctrl_d_command'
require_relative './ctrl_z_command'
require_relative './ctrl_v_command'
require_relative './ctrl_a_command'
require_relative './ctrl_e_command'
require_relative './left_arrow_command'
require_relative './right_arrow_command'
