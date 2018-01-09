# frozen_string_literal: true
# encoding: UTF-8

require_relative './key_command'

class Fir
  class TabCommand < KeyCommand
    def self.character_regex
      /^\t$/
    end

    def execute_hook(new_state)
      new_state.current_line = state.current_line.clone.insert(
        state.cursor.x,
        *next_state.suggestions
      ).flatten
      new_state.cursor = state.cursor.right(next_state.cursor_position)
      new_state.history.reset
      new_state
    end

    private

    def next_state
      if state.suggestion
        NextStateWithSuggestions.new(state)
      else
        NextStateWithoutSuggestions.new
      end
    end
  end

  class NextStateWithSuggestions
    attr_reader :state

    def initialize(state)
      @state = state
    end

    def suggestions
      state.suggestion.split('')
    end

    def cursor_position
      state.suggestion.length
    end
  end

  class NextStateWithoutSuggestions
    def suggestions
      []
    end

    def cursor_position
      0
    end
  end
end
