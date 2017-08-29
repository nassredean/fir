# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby'
require 'pry'

describe Firby do
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

  describe 'Backspace input' do

    describe 'With single line' do
      it 'pops character off of last line in line array and draws a cursor back 1 with a clear' do
        lines = [['a']]
        new_lines = BackspaceCommand.new("\177", lines, @input, @output).execute
        new_lines.must_equal([[]])
        @output.output.must_equal("#{Cursor.back(1)}#{Cursor.clear(0)}")
      end
    end

    describe 'With no preceeding lines' do
      it 'adds no characters to the line array and draws a cursor back 0 with a clear' do
        lines = [[]]
        new_lines = BackspaceCommand.new("\177", lines, @input, @ouput).execute
        new_lines.must_equal([[]])
        @output.output.must_equal("")
      end
    end

    describe 'With preceeding line containing no characters' do
      it 'pops line off of line array and draws a cursor up' do
        lines = [[], []]
        puts @output.class
        new_lines = BackspaceCommand.new("\177", lines, @input, @output).execute
        new_lines.must_equal([[]])
        @output.output.must_equal("#{Cursor.up(1)}")
      end
    end
  end

  describe 'With preceeding line containing characters' do
    it 'pops line off of line array and draws a cursor up and then forward' do
      lines = [['a'], []]
      puts @output.class
      new_lines = BackspaceCommand.new("\177", lines, @input, @output).execute
      new_lines.must_equal([['a']])
      @output.output.must_equal("#{Cursor.up(1)}#{Cursor.forward(1)}")
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
