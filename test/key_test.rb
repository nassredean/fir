# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby/key'
require_relative './key_interface_test'

class InputDouble
  attr_reader :char_array

  def initialize(char_array)
    @char_array = char_array
  end

  def raw
    yield RawInputDouble.new(char_array) if block_given?
  end

  class RawInputDouble
    attr_reader :char_array

    def initialize(char_array)
      @char_array = char_array
      @counter = 0
    end

    def sysread(_)
      char = char_array[@counter]
      return '' unless char
      @counter += 1
      char
    end
  end
end

describe Firby::Key do
  describe 'interface' do
    include KeyInterfaceTest

    before do
      @key = Firby::Key.new(InputDouble.new(['c']))
    end
  end

  it 'returns the character read from the output' do
    key = Firby::Key.new(InputDouble.new(['c']))
    key.get.must_equal('c')
  end

  it 'handles a single escape character' do
    key = Firby::Key.new(InputDouble.new(["\e"]))
    key.get.must_equal("\e")
  end

  it 'handles a single escape character' do
    key = Firby::Key.new(InputDouble.new(["\e", '[', 'C']))
    key.get.must_equal("\e[C")
  end
end
