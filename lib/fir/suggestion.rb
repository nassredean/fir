# frozen_string_literal: true
# encoding: UTF-8

class Fir
  class Suggestion
    attr_reader :line, :history

    def initialize(line, history)
      @line = line
      @history = history
    end

    def generate(i)
      word = suggestion(line, i)
      return unless word
      word[(line.length)..(word.length)]
    end

    def suggestion(str, i)
      if str == '' && i.positive?
        history[-i]
      elsif str != ''
        filtered_history(str)[-i]
      end
    end

    def filtered_history(str)
      history.grep(/^#{Regexp.escape(str)}/).reverse
    end
  end
end
