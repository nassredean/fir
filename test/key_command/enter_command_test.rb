# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/firby/key_command/enter_command'
require_relative '../../lib/firby/repl_state'
require_relative '../../lib/firby/lines'
require_relative '../../lib/firby/cursor'
require_relative './key_command_interface_test'

describe Firby::KeyCommand::EnterCommand do
  describe 'interface' do
    include KeyCommandInterfaceTest
    include KeyCommandSubclassTest

    before do
      @command = Firby::KeyCommand::EnterCommand.new("\r",
                                                     Firby::ReplState.blank)
    end
  end

  describe 'with no preceeding lines' do
    before do
      @old_state = Firby::ReplState.blank
      @new_state = Firby::KeyCommand::EnterCommand.new("\r", @old_state).execute
    end

    it 'adds the new line to the states line array and updates the cursor' do
      @new_state.lines.must_equal(Firby::Lines.new([], []))
      @new_state.cursor.must_equal(Firby::Cursor.new(0, 1))
      @old_state.must_equal(Firby::ReplState.blank)
    end
  end

  describe 'with single preceeding line' do
    before do
      @old_state = Firby::ReplState.new(Firby::Lines.new(%w[a b c]),
                                        Firby::Cursor.new(3, 0))
      @new_state = Firby::KeyCommand::EnterCommand.new("\r",
                                                       @old_state).execute
    end

    it 'adds the new line to the line array and updates the cursor' do
      @new_state.lines.must_equal(Firby::Lines.new(%w[a b c], []))
      @new_state.cursor.must_equal(Firby::Cursor.new(0, 1))
      @old_state.must_equal(Firby::ReplState.new(Firby::Lines.new(%w[a b c]),
                                                 Firby::Cursor.new(3, 0)))
    end
  end
end
