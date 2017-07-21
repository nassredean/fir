# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/firby'
require 'pry'

describe SingleCharacterHandler do
  describe 'Single character input' do
    before do
      @input = MockIO::InputMock.new
      @output = MockIO::OutputMock.new
    end

    it 'must add the character to output' do
      SingleCharacterHandler.new('c', [], @input, @output).call
      @output.output.must_equal(['c'])
    end
  end

  describe 'Enter input' do
    before do
      @input = MockIO::InputMock.new
      @output = MockIO::OutputMock.new
    end

    it 'must add the new line character to the output' do
      EnterHandler.new("\r", [], @input, @output).call
      @output.output.must_equal(["\n"])
    end
  end

  describe 'Ctrl-C input' do
    before do
      @input = MockIO::InputMock.new
      @output = MockIO::OutputMock.new
    end

    it 'must raise a SystemExit' do
      assert_raises SystemExit do
        CtrlCHandler.new("\u0003", [], @input, @output).call
      end
    end
  end
end

module MockIO
  class InputMock
    attr_reader :input

    def initialize
      @input = []
    end
  end

  class OutputMock
    attr_reader :output

    def initialize
      @output = []
    end

    def syswrite(character)
      @output << character
    end
  end
end
