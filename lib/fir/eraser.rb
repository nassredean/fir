# frozen_string_literal: true
# encoding: UTF-8

require_relative 'screen_helper'

class Fir
  class Eraser
    include ScreenHelper

    attr_reader :output

    def initialize(output)
      @output = output
    end

    def perform(state)
      return if state.blank?
      state.lines.length.times do |i|
        output.syswrite("#{horizontal_absolute(1)}#{clear(0)}")
        output.syswrite("#{previous_line(1)}#{clear(0)}") unless i.zero?
      end
    end
  end
end
