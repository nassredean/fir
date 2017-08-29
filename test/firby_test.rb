# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby'
require 'pry'

describe 'Key Commands' do
  before do
    @input = MockIO::InputMock.new
    @output = MockIO::OutputMock.new
  end

  describe 'Single character input' do
    it 'must add the character to output' do
      lines = [[]]
      new_lines = SingleKeyCommand.new('c', lines, @input, @output).execute
      new_lines.must_equal([['c']])
      @output.output.must_equal('c')
    end
  end

  describe 'Enter input' do
    describe 'With no preceeding lines' do
      it 'must add the new line character to the output' do
        lines = [[]]
        new_lines = EnterCommand.new("\r", lines, @input, @output).execute
        new_lines.must_equal([[], []])
        @output.output.must_equal("\n#{Cursor.back(0)}")
      end
    end

    describe 'With single preceeding line' do
      it 'must add the new line character and the cursor back character for each character on the preceeding line' do
        lines = [['a', 'b', 'c']]
        new_lines = EnterCommand.new("\r", lines, @input, @output).execute
        new_lines.must_equal([['a', 'b', 'c'], []])
        @output.output.must_equal("\n#{Cursor.back(3)}")
      end
    end
  end

  describe 'Ctrl-C input' do
    it 'must raise a SystemExit' do
      assert_raises SystemExit do
        CtrlCCommand.new("\u0003", [], @input, @output).execute
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
