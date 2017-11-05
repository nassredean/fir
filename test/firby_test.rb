# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../lib/firby'
require 'pry'

describe Firby do
  describe Firby::KeyCommand::SingleKeyCommand do
    before do
      @old_state = Firby::ReplState.blank
      @new_state = Firby::KeyCommand::SingleKeyCommand.new('c', @old_state).execute
    end

    it 'adds the character to the states current line and updates the cursor' do
      @new_state.lines.must_equal(Firby::Lines.new(Firby::Line.new('c')))
      @new_state.cursor.must_equal(Firby::Cursor.new(1, 0))
      @old_state.must_equal(Firby::ReplState.blank)
    end
  end

  describe Firby::KeyCommand::EnterCommand do
    describe 'with no preceeding lines' do
      before do
        @old_state = Firby::ReplState.blank
        @new_state = Firby::KeyCommand::EnterCommand.new("\r", @old_state).execute
      end

      it 'adds the new line to the states line array and updates the cursor' do
        @new_state.lines.must_equal(Firby::Lines.new(Firby::Line.blank, Firby::Line.blank))
        @new_state.cursor.must_equal(Firby::Cursor.new(0, 1))
        @old_state.must_equal(Firby::ReplState.blank)
      end
    end

    describe 'with single preceeding line' do
      before do
        @old_state = Firby::ReplState.new(Firby::Lines.new(Firby::Line.new('a', 'b', 'c')), Firby::Cursor.new(3, 0))
        @new_state = Firby::KeyCommand::EnterCommand.new("\r", @old_state).execute
      end

      it 'adds the new line to the line array and updates the cursor' do
        @new_state.lines.must_equal(Firby::Lines.new(Firby::Line.new('a', 'b', 'c'), Firby::Line.blank))
        @new_state.cursor.must_equal(Firby::Cursor.new(0, 1))
        @old_state.must_equal(Firby::ReplState.new(Firby::Lines.new(Firby::Line.new('a', 'b', 'c')), Firby::Cursor.new(3, 0)))
      end
    end
  end

  describe Firby::KeyCommand::BackspaceCommand do
    describe 'with single line that has no characters' do
      before do
        @old_state = Firby::ReplState.blank
        @new_state = Firby::KeyCommand::BackspaceCommand.new("\177", @old_state).execute
      end

      it 'adds no characters to the line array and the cursor remains at origin' do
        @new_state.lines.must_equal(Firby::Lines.blank)
        @new_state.cursor.must_equal(Firby::Cursor.origin)
        @old_state.must_equal(Firby::ReplState.blank)
      end
    end

    describe 'with single line that has characters' do
      before do
        @old_state = Firby::ReplState.new(Firby::Lines.new(Firby::Line.new('a')), Firby::Cursor.new(1, 0))
        @new_state = Firby::KeyCommand::BackspaceCommand.new("\177", @old_state).execute
      end

      it 'pops character off of last line in line array and updates the cursor' do
        @new_state.lines.must_equal(Firby::Lines.blank)
        @new_state.cursor.must_equal(Firby::Cursor.origin)
        @old_state.must_equal(Firby::ReplState.new(Firby::Lines.new(Firby::Line.new('a')), Firby::Cursor.new(1, 0)))
      end
    end

    describe 'with preceeding line containing no characters' do
      before do
        @old_state = Firby::ReplState.new(Firby::Lines.new(Firby::Line.blank, Firby::Line.blank), Firby::Cursor.new(0, 1))
        @new_state = Firby::KeyCommand::BackspaceCommand.new("\177", @old_state).execute
      end

      it 'pops last line in line array and updates cursor' do
        @new_state.lines.must_equal(Firby::Lines.blank)
        @new_state.cursor.must_equal(Firby::Cursor.origin)
        @old_state.must_equal(Firby::ReplState.new(Firby::Lines.new(Firby::Line.blank, Firby::Line.blank), Firby::Cursor.new(0, 1)))
      end
    end

    describe 'With preceeding line containing characters' do
      before do
        @old_state = Firby::ReplState.new(Firby::Lines.new(Firby::Line.new('a'), Firby::Line.blank), Firby::Cursor.new(0, 1))
        @new_state = Firby::KeyCommand::BackspaceCommand.new("\177", @old_state).execute
      end

      it 'pops line off of line array and draws a cursor up and then forward' do
        @new_state.lines.must_equal(Firby::Lines.new(Firby::Line.new('a')))
        @new_state.cursor.must_equal(Firby::Cursor.new(1, 0))
        @old_state.must_equal(Firby::ReplState.new(Firby::Lines.new(Firby::Line.new('a'), Firby::Line.blank), Firby::Cursor.new(0, 1)))
      end
    end
  end

  describe 'Ctrl-C input' do
    before do
      @old_state = Firby::ReplState.blank
    end

    it 'must raise a SystemExit' do
      assert_raises SystemExit do
        Firby::KeyCommand::CtrlCCommand.new("\u0003", @old_state).execute
      end
    end
  end
end
