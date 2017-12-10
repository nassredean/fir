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
      output.syswrite(state
        .indents
        .map { |delta| '  ' * delta }
        .zip(state.lines.map(&:join))
        .map(&:join)
        .join("\n#{horizontal_absolute(1)}"))
    end
  end
end
