# frozen_string_literal: true
# encoding: UTF-8

require_relative 'screen_helper'

class Fir
  class Renderer
    include ScreenHelper
    attr_reader :output

    def initialize(output)
      @output = output
      output.syswrite(prompt(1, '>'))
    end

    def perform(state)
      output.syswrite(
        lines_with_prompt(state.lines)
        .join("\n#{horizontal_absolute(1)}")
        .concat(state.lines.result_prompt)
      )
    end

    private

    def lines_with_prompt(lines)
      lines.to_r.map do |line|
        "#{prompt(line.number, line.prompt)}#{format_line(line)}"
      end
    end

    def format_line(line)
      "#{'  ' * line.delta}#{line}"
    end
  end
end
