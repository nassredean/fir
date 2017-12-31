# frozen_string_literal: true
# encoding: UTF-8

class Fir
  class Suggestion
    attr_reader :line, :history

    def initialize(line, history)
      @line = line
      @history = history
    end

    def generate
      word = suggestion(line)
      return unless word
      word[(line.length)..(word.length)]
    end

    def suggestion(str)
      history.grep(/^#{Regexp.escape(str)}/).first
    end
  end
end
