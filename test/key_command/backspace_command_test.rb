# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/firby/key_command/backspace_command'
require_relative '../../lib/firby/repl_state'
require_relative '../../lib/firby/lines'
require_relative '../../lib/firby/cursor'
require_relative './key_command_interface_test'

describe Firby::KeyCommand::BackspaceCommand do
  describe 'interface' do
    include KeyCommandInterfaceTest
    include KeyCommandSubclassTest

    before do
      @command = Firby::KeyCommand::BackspaceCommand.new("\177",
                                                         Firby::ReplState.blank)
    end
  end

  describe 'with single line that has no characters' do
    before do
      @old_state = Firby::ReplState.blank
      @new_state = Firby::KeyCommand::BackspaceCommand.new("\177",
                                                           @old_state).execute
    end

    it 'doesn\'t append to the array and the cursor remains at origin' do
      @new_state.lines.must_equal(Firby::Lines.blank)
      @new_state.cursor.must_equal(Firby::Cursor.blank)
      @old_state.must_equal(Firby::ReplState.blank)
    end
  end

  describe 'with single line that has characters' do
    before do
      @old_state = Firby::ReplState.new(Firby::Lines.new(['a']),
                                        Firby::Cursor.new(1, 0))
      @new_state = Firby::KeyCommand::BackspaceCommand.new("\177",
                                                           @old_state).execute
    end

    it 'pops character off of last line in line array and updates the cursor' do
      @new_state.lines.must_equal(Firby::Lines.blank)
      @new_state.cursor.must_equal(Firby::Cursor.blank)
      @old_state.must_equal(Firby::ReplState.new(Firby::Lines.new(['a']),
                                                 Firby::Cursor.new(1, 0)))
    end
  end

  describe 'with preceeding line containing no characters' do
    before do
      @old_state = Firby::ReplState.new(Firby::Lines.new([], []),
                                        Firby::Cursor.new(0, 1))
      @new_state = Firby::KeyCommand::BackspaceCommand.new("\177",
                                                           @old_state).execute
    end

    it 'pops last line in line array and updates cursor' do
      @new_state.lines.must_equal(Firby::Lines.blank)
      @new_state.cursor.must_equal(Firby::Cursor.blank)
      @old_state.must_equal(Firby::ReplState.new(Firby::Lines.new([], []),
                                                 Firby::Cursor.new(0, 1)))
    end
  end

  describe 'With preceeding line containing characters' do
    before do
      @old_state = Firby::ReplState.new(Firby::Lines.new(['a'], []),
                                        Firby::Cursor.new(0, 1))
      @new_state = Firby::KeyCommand::BackspaceCommand.new("\177",
                                                           @old_state).execute
    end

    it 'pops line off of line array and draws a cursor up and then forward' do
      @new_state.lines.must_equal(Firby::Lines.new(['a']))
      @new_state.cursor.must_equal(Firby::Cursor.new(1, 0))
      @old_state.must_equal(Firby::ReplState.new(Firby::Lines.new(['a'], []),
                                                 Firby::Cursor.new(0, 1)))
    end
  end
end
