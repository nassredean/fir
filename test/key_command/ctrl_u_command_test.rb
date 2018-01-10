# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/fir/key_command/ctrl_u_command'
require_relative '../../lib/fir/repl_state'
require_relative '../../lib/fir/lines'
require_relative '../../lib/fir/cursor'
require_relative './key_command_interface_test'

describe Fir::CtrlUCommand do
  describe 'interface' do
    include KeyCommandInterfaceTest
    include KeyCommandSubclassTest

    before do
      @command = Fir::BackspaceCommand.new("\u0015",
                                           Fir::ReplState.blank)
    end
  end

 describe 'with a single line and cursor at the beginning of the line' do
   before do
     @old_state = Fir::ReplState.new(Fir::Lines.new(['t', 'e', 's', 't', ' ', 'l', 'i', 'n', 'e']),
                                     Fir::Cursor.new(0, 0),
                                     binding)
     @new_state = Fir::CtrlUCommand.new("\u0015", @old_state).execute
     @new_lines = Fir::Lines.new(['t', 'e', 's', 't', ' ', 'l', 'i', 'n', 'e'])
     @new_cursor = Fir::Cursor.new(0, 0)
   end

   it 'clears out all preceeding characters on line' do
     @new_state.lines.must_equal(@new_lines)
   end

   it 'moves cursor to beginning the line' do
     @new_state.cursor.must_equal(@new_cursor)
   end

   it 'does not update the old state' do
     @old_state.must_equal(Fir::ReplState.new(Fir::Lines.new(['t', 'e', 's', 't', ' ', 'l', 'i', 'n', 'e']),
                                     Fir::Cursor.new(0, 0),
                                     binding))
   end
 end

 describe 'with a single line and cursor in the middle of the line' do
   before do
     @old_state = Fir::ReplState.new(Fir::Lines.new(['t', 'e', 's', 't', ' ', 'l', 'i', 'n', 'e']),
                                     Fir::Cursor.new(5, 0),
                                     binding)
     @new_state = Fir::CtrlUCommand.new("\u0015", @old_state).execute
     @new_lines = Fir::Lines.new(['l', 'i', 'n', 'e'])
     @new_cursor = Fir::Cursor.new(0, 0)
   end

   it 'clears out all preceeding characters on line' do
     @new_state.lines.must_equal(@new_lines)
   end

   it 'moves cursor to beginning the line' do
     @new_state.cursor.must_equal(@new_cursor)
   end

   it 'does not update the old state' do
     @old_state.must_equal(Fir::ReplState.new(Fir::Lines.new(['t', 'e', 's', 't', ' ', 'l', 'i', 'n', 'e']),
                                     Fir::Cursor.new(5, 0),
                                     binding))
   end
 end

 describe 'with a single line that has characters' do
   before do
     @old_state = Fir::ReplState.new(Fir::Lines.new(['t', 'e', 's', 't', ' ', 'l', 'i', 'n', 'e']),
                                     Fir::Cursor.new(5, 0),
                                     binding)
     @new_state = Fir::CtrlUCommand.new("\u0015", @old_state).execute
     @new_lines = Fir::Lines.new(['l', 'i', 'n', 'e'])
     @new_cursor = Fir::Cursor.new(0, 0)
   end

   it 'clears out all preceeding characters on line' do
     @new_state.lines.must_equal(@new_lines)
   end

   it 'moves cursor to beginning the line' do
     @new_state.cursor.must_equal(@new_cursor)
   end

   it 'does not update the old state' do
     @old_state.must_equal(Fir::ReplState.new(Fir::Lines.new(['t', 'e', 's', 't', ' ', 'l', 'i', 'n', 'e']),
                                     Fir::Cursor.new(5, 0),
                                     binding))
   end
 end
end
