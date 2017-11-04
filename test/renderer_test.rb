# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby/repl_state'
require_relative '../lib/firby/screen'

describe Firby::Screen::Screen::Renderer do
  describe '#render' do
    before do
      @state = Firby::ReplState.build([['d', 'e', 'f', ' ', 'c', 'o', 'w'], []], [0, 1])
      @renderer = Firby::Screen::Screen::Renderer.new(@state)
    end

    it 'renders correctly' do
      @renderer.render.must_equal("def cow\n\e[1G  ")
    end
  end
end
