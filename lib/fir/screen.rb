# frozen_string_literal: true
# encoding: UTF-8

require_relative 'eraser'
require_relative 'evaluater'
require_relative 'renderer'

class Fir
  class Screen
    attr_reader :eraser
    attr_reader :renderer
    attr_reader :evaluater

    def initialize(output, error)
      @eraser = Eraser.new(output)
      @renderer = Renderer.new(output)
      @evaluater = Evaluater.new(output, error)
    end

    def update(state, new_state)
      eraser.perform(state)
      renderer.perform(new_state)
      if new_state.lines.executable?
        evaluater.perform(new_state)
      end
    end
  end
end
