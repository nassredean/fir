# frozen_string_literal: true
# encoding: UTF-8

require_relative 'cursor_helper'

class Fir
  class Renderer
    include CursorHelper

    attr_reader :output

    def initialize(output)
      @output = output
    end

    def perform(state)
      output.syswrite(
        state.lines.formatted_lines.map do |line|
          "#{'  ' * line.delta}#{line.str}"
        end.join("\n#{horizontal_absolute(1)}")
      )
    end
  end
end
