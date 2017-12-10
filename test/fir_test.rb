# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative './double/output'
require_relative './double/input'
require_relative '../lib/fir'
require_relative './state_helper'

describe Fir do
  it 'initializes the loop' do
    @loop_thread = Thread.new do
      Fir.start(
        Double::Input.new(['c']),
        Double::Output.new,
        Double::Error.new
      )
    end
    @loop_thread.kill
  end
end
