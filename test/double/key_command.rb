# frozen_string_literal: true
# encoding: UTF-8

module Double
  class KeyCommand
    attr_reader :state
    attr_reader :character

    def initialize(state)
      @state = state
      @character = 'r'
    end

    def self.handles?
      true
    end

    def self.character_regex
      /.*/
    end

    def execute
      execute_hook(@state)
    end

    def execute_hook(state)
      state
    end
  end
end
