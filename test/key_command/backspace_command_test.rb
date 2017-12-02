# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/fir/key_command/backspace_command'
require_relative '../../lib/fir/repl_state'
require_relative '../../lib/fir/lines'
require_relative '../../lib/fir/cursor'
require_relative './key_command_interface_test'

describe Fir::KeyCommand::BackspaceCommand do
  describe 'interface' do
    include KeyCommandInterfaceTest
    include KeyCommandSubclassTest

    before do
      @command = Fir::KeyCommand::BackspaceCommand.new("\177",
                                                       Fir::ReplState.blank)
    end
  end

  describe 'with single line that has no characters' do
    before do
      @old_state = Fir::ReplState.blank
      @new_state = Fir::KeyCommand::BackspaceCommand.new("\177",
                                                         @old_state).execute
    end

    it 'doesn\'t append to the array and the cursor remains at origin' do
      @new_state.lines.must_equal(Fir::Lines.blank)
      @new_state.cursor.must_equal(Fir::Cursor.blank)
      @old_state.must_equal(Fir::ReplState.blank)
    end
  end

  describe 'with single line that has characters' do
    before do
      @old_state = Fir::ReplState.new(Fir::Lines.new(['a']),
                                      Fir::Cursor.new(1, 0))
      @new_state = Fir::KeyCommand::BackspaceCommand.new("\177",
                                                         @old_state).execute
    end

    it 'pops character off of last line in line array and updates the cursor' do
      @new_state.lines.must_equal(Fir::Lines.blank)
      @new_state.cursor.must_equal(Fir::Cursor.blank)
      @old_state.must_equal(Fir::ReplState.new(Fir::Lines.new(['a']),
                                               Fir::Cursor.new(1, 0)))
    end
  end

  describe 'with preceeding line containing no characters' do
    before do
      @old_state = Fir::ReplState.new(Fir::Lines.new([], []),
                                      Fir::Cursor.new(0, 1))
      @new_state = Fir::KeyCommand::BackspaceCommand.new("\177",
                                                         @old_state).execute
    end

    it 'pops last line in line array and updates cursor' do
      @new_state.lines.must_equal(Fir::Lines.blank)
      @new_state.cursor.must_equal(Fir::Cursor.blank)
      @old_state.must_equal(Fir::ReplState.new(Fir::Lines.new([], []),
                                               Fir::Cursor.new(0, 1)))
    end
  end

  describe 'With preceeding line containing characters' do
    before do
      @old_state = Fir::ReplState.new(Fir::Lines.new(['a'], []),
                                      Fir::Cursor.new(0, 1))
      @new_state = Fir::KeyCommand::BackspaceCommand.new("\177",
                                                         @old_state).execute
    end

    it 'pops line off of line array and draws a cursor up and then forward' do
      @new_state.lines.must_equal(Fir::Lines.new(['a']))
      @new_state.cursor.must_equal(Fir::Cursor.new(1, 0))
      @old_state.must_equal(Fir::ReplState.new(Fir::Lines.new(['a'], []),
                                               Fir::Cursor.new(0, 1)))
    end
  end
end
