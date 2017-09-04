# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby'
require 'pry'

describe Firby do
  describe Firby::KeyCommand::SingleKeyCommand do
    before do
      @old_state = Firby::ReplState.new_state
      @new_state = Firby::KeyCommand::SingleKeyCommand.new('c', @old_state).execute
    end

    it 'adds the character to the states current line and updates the cursor' do
      @new_state.lines.must_equal([['c']])
      @new_state.cursor.x.must_equal(1)
      @new_state.cursor.y.must_equal(0)
    end

    describe Firby::Screen do
      before do
        @output = MockIO::OutputMock.new
        Firby::Screen.update(@old_state, @new_state, @output)
      end

      it 'updates the screen correctly' do
        @output.output.must_equal("\e[1G\e[0K\e[1G\e[0Kc")
      end
    end
  end

  describe Firby::KeyCommand::EnterCommand do
    describe 'with no preceeding lines' do
      before do
        @old_state = Firby::ReplState.new_state
        @new_state = Firby::KeyCommand::EnterCommand.new("\r", @old_state).execute
      end

      it 'adds the new line to the states line array and updates the cursor' do
        @new_state.lines.must_equal([[], []])
        @new_state.cursor.x.must_equal(0)
        @new_state.cursor.y.must_equal(1)
      end

      describe Firby::Screen do
        before do
          @output = MockIO::OutputMock.new
          Firby::Screen.update(@old_state, @new_state, @output)
        end

        it 'updates the screen correctly' do
          @output.output.must_equal("\e[1G\e[0K\e[1F\e[0K\e[1G\e[0K\n\e[1G")
        end
      end
    end

    describe 'with single preceeding line' do
      before do
        @old_state = Firby::ReplState.new([['a', 'b', 'c']], Firby::ReplState::Cursor.new(3, 0))
        @new_state = Firby::KeyCommand::EnterCommand.new("\r", @old_state).execute
      end

      it 'adds the new line to the line array and updates the cursor' do
        @new_state.lines.must_equal([['a', 'b', 'c'], []])
        @new_state.cursor.x.must_equal(0)
        @new_state.cursor.y.must_equal(1)
      end

      describe Firby::Screen do
        before do
          @output = MockIO::OutputMock.new
          Firby::Screen.update(@old_state, @new_state, @output)
        end

        it 'updates the screen correctly' do
          @output.output.must_equal("\e[1G\e[0K\e[1F\e[0K\e[1G\e[0Kabc\n\e[1G")
        end
      end
    end
  end

  describe Firby::KeyCommand::BackspaceCommand do
    describe 'with single line that has no characters' do
      before do
        @old_state = Firby::ReplState.new_state
        @new_state = Firby::KeyCommand::BackspaceCommand.new("\177", @old_state).execute
      end

      it 'adds no characters to the line array and updates the cursor' do
        @new_state.lines.must_equal([[]])
        @new_state.cursor.x.must_equal(0)
        @new_state.cursor.y.must_equal(0)
      end

      describe Firby::Screen do
        before do
          @output = MockIO::OutputMock.new
          Firby::Screen.update(@old_state, @new_state, @output)
        end

        it 'updates the screen correctly' do
          @output.output.must_equal("\e[1G\e[0K\e[1G\e[0K")
        end
      end
    end

    describe 'with single line that has characters' do
      before do
        @old_state = Firby::ReplState.new([['a']], Firby::ReplState::Cursor.new(1, 0))
        @new_state = Firby::KeyCommand::BackspaceCommand.new("\177", @old_state).execute
      end

      it 'pops character off of last line in line array and updates the cursor' do
        @new_state.lines.must_equal([[]])
        @new_state.cursor.x.must_equal(0)
        @new_state.cursor.y.must_equal(0)
      end

      describe Firby::Screen do
        before do
          @output = MockIO::OutputMock.new
          Firby::Screen.update(@old_state, @new_state, @output)
        end

        it 'updates the screen correctly' do
          @output.output.must_equal("\e[1G\e[0K\e[1G\e[0K")
        end
      end
    end

    describe 'with preceeding line containing no characters' do
      before do
        @old_state = Firby::ReplState.new([[], []], Firby::ReplState::Cursor.new(0, 1))
        @new_state = Firby::KeyCommand::BackspaceCommand.new("\177", @old_state).execute
      end

      it 'pops last line in line array updates cursor' do
        @new_state.lines.must_equal([[]])
        @new_state.cursor.x.must_equal(0)
        @new_state.cursor.y.must_equal(0)
      end

      describe Firby::Screen do
        before do
          @output = MockIO::OutputMock.new
          Firby::Screen.update(@old_state, @new_state, @output)
        end

        it 'updates the screen correctly' do
          @output.output.must_equal("\e[1G\e[0K\e[1G\e[0K")
        end
      end
    end

    describe 'With preceeding line containing characters' do
      before do
        @old_state = Firby::ReplState.new([['a'], []], Firby::ReplState::Cursor.new(0, 1))
        @new_state = Firby::KeyCommand::BackspaceCommand.new("\177", @old_state).execute
      end

      it 'pops line off of line array and draws a cursor up and then forward' do
        @new_state.lines.must_equal([['a']])
        @new_state.cursor.x.must_equal(1)
        @new_state.cursor.y.must_equal(0)
      end

      describe Firby::Screen do
        before do
          @output = MockIO::OutputMock.new
          Firby::Screen.update(@old_state, @new_state, @output)
        end

        it 'updates the screen correctly' do
          @output.output.must_equal("\e[1G\e[0K\e[1G\e[0Ka")
        end
      end
    end
  end

  describe 'Ctrl-C input' do
    before do
      @old_state = Firby::ReplState.new_state
      Firby::KeyCommand::SingleKeyCommand.new("\u0003", @old_state).execute
    end

    it 'must raise a SystemExit' do
      assert_raises SystemExit do
        Firby::KeyCommand::CtrlCCommand.new("\u0003", @old_state).execute
      end
    end
  end
end

module MockIO
  class OutputMock
    attr_reader :output

    def initialize
      @output = ''
    end

    def syswrite(string)
      old_output = @output.dup
      @output = "#{old_output.to_s}#{string.to_s}"
      @output
    end
  end
end
