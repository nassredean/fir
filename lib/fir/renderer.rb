# frozen_string_literal: true
# encoding: UTF-8

require_relative 'screen_helper'

class Fir
  class Renderer
    include ScreenHelper
    attr_reader :output

    def initialize(output)
      @output = output
      output.syswrite(line_prompt)
    end

    def perform(state)
      output.syswrite(rendered_lines(state))
      output.syswrite(rendered_cursor(state))
      output.syswrite(rendered_suggestion(state)) if state.suggestion
    end

    def rendered_suggestion(state)
      return unless state.suggestion.length.positive?
      "#{state.suggestion}#{cursor_back(state.suggestion.length)}"
    end

    def rendered_cursor(state)
      cursor = ''
      if state.cursor.x != state.current_line.length
        cursor = "#{cursor}#{cursor_back(state.current_line.length - state.cursor.x)}"
      end
      cursor
    end

    def rendered_lines(state)
      lines_with_prompt(state)
        .map(&:join)
        .join("\n#{horizontal_absolute(1)}")
        .concat(result_prompt(state))
    end

    def lines_with_prompt(state)
      lines_to_render(state).map.with_index do |line, i|
        prompt = state.indents[i].zero? ? '>' : '*'
        [line_prompt(prompt), ('  ' * state.indents[i]), line.join]
      end
    end

    def lines_to_render(state)
      if state.executable?
        state.lines[0...-1]
      else
        state.lines
      end
    end

    def result_prompt(state)
      if state.executable?
        "\n=> "
      else
        ''
      end
    end
  end
end
