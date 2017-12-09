# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative './double/output'
require_relative '../lib/fir/screen'
require_relative './state_helper'

describe Fir::Screen do
  before do
    @screen = Fir::Screen.new(Double::Output.new,
                              Double::Error.new)
    @eraser = Minitest::Mock.new
    @renderer = Minitest::Mock.new
    @evaluater = Minitest::Mock.new
    @state = Fir::ReplState.blank
    @new_state = Fir::ReplState.blank
    @screen.instance_variable_set(:@eraser, @eraser)
    @screen.instance_variable_set(:@renderer, @renderer)
    @screen.instance_variable_set(:@evaluater, @evaluater)
  end

  it 'invokes the perform method on the eraser, renderer, and evaluater' do
    @eraser.expect :perform, nil, [@state]
    @renderer.expect :perform, nil, [@new_state]
    @evaluater.expect :perform, nil, [@new_state]
    @screen.update(@state, @new_state)
    @eraser.verify
    @renderer.verify
    @evaluater.verify
  end
end
