# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby'
require 'pry'

describe CharacterHandlers do
  describe 'Single character input' do
    before do
      @input = MockIO::InputMock.new
      @output = MockIO::OutputMock.new
    end

    it 'must add the character to output' do
      SingleCharacterHandler.new('c', [], @input, @output).call
      @output.output.must_equal('c')
    end
  end

  describe 'Enter input' do
    describe 'With no preceeding lines' do
      before do
        @input = MockIO::InputMock.new
        @output = MockIO::OutputMock.new
      end

      it 'must add the new line character to the output' do
        previous_line = []
        EnterHandler.new("\r", previous_line, @input, @output).call
        @output.output.must_equal("\n#{Cursor.back(previous_line.length)}")
      end
    end

    describe 'With single preceeding line' do
      before do
        @input = MockIO::InputMock.new
        @output = MockIO::OutputMock.new
      end

      it 'must add the new line character and the cursor back character for each character on the preceeding line' do
        previous_line = ['a', 'b', 'c']
        EnterHandler.new("\r", previous_line, @input, @output).call
        @output.output.must_equal("\n#{Cursor.back(previous_line.length)}")
      end
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
      @output = ''
    end

    def syswrite(string)
      @output = "#{@ouput.to_s}#{string}"
    end
  end
end
