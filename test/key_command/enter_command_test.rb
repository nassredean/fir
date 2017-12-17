# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/fir/key_command/enter_command'
require_relative '../../lib/fir/repl_state'
require_relative '../../lib/fir/lines'
require_relative '../../lib/fir/cursor'
require_relative './key_command_interface_test'

describe Fir::EnterCommand do
  describe 'interface' do
    include KeyCommandInterfaceTest
    include KeyCommandSubclassTest

    before do
      @command = Fir::EnterCommand.new("\r",
                                       Fir::ReplState.blank)
    end
  end

  describe 'with no preceeding lines' do
    before do
      @old_state = Fir::ReplState.blank
      @new_state = Fir::EnterCommand.new("\r", @old_state).execute
    end

    it 'adds the new line to the states line array and updates the cursor' do
      @new_state.lines.must_equal(Fir::Lines.new([], []))
      @new_state.cursor.must_equal(Fir::Cursor.new(0, 1))
      @old_state.must_equal(Fir::ReplState.blank)
    end
  end

  describe 'with single preceeding line' do
    before do
      @old_state = Fir::ReplState.new(Fir::Lines.new(%w[a b c]),
                                      Fir::Cursor.new(3, 0),
                                      binding)
      @new_state = Fir::EnterCommand.new("\r",
                                         @old_state).execute
    end

    it 'adds the new line to the line array and updates the cursor' do
      @new_state.lines.must_equal(Fir::Lines.new(%w[a b c], []))
      @new_state.cursor.must_equal(Fir::Cursor.new(0, 1))
      @old_state.must_equal(Fir::ReplState.new(Fir::Lines.new(%w[a b c]),
                                               Fir::Cursor.new(3, 0),
                                               binding))
    end
  end
end
