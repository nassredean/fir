# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative './key_interface_test'
require_relative './double/input'
require_relative '../lib/fir/key'

describe Fir::Key do
  describe 'interface' do
    include KeyInterfaceTest

    before do
      @key = Fir::Key.new(Double::Input.new(['c']))
    end
  end

  it 'returns the character read from the output' do
    key = Fir::Key.new(Double::Input.new(['c']))
    key.get.must_equal('c')
  end

  it 'handles a single escape character' do
    key = Fir::Key.new(Double::Input.new(["\e"]))
    key.get.must_equal("\e")
  end

  it 'handles a single escape character' do
    key = Fir::Key.new(Double::Input.new(["\e", '[', 'C']))
    key.get.must_equal("\e[C")
  end
end
