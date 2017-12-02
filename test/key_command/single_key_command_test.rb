# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/firby/key_command/single_key_command'
require_relative '../../lib/firby/repl_state'
require_relative '../../lib/firby/lines'
require_relative '../../lib/firby/cursor'
require_relative './key_command_interface_test'

describe Firby::KeyCommand do
  describe Firby::KeyCommand::SingleKeyCommand do
    describe 'interface' do
      include KeyCommandInterfaceTest
      include KeyCommandSubclassTest

      before do
        @command = Firby::KeyCommand::SingleKeyCommand.new(
          'c',
          Firby::ReplState.blank
        )
      end
    end

    before do
      @old_state = Firby::ReplState.blank
      @new_state = Firby::KeyCommand::SingleKeyCommand.new(
        'c',
        @old_state
      ).execute
    end

    it 'adds the character to the states current line and updates the cursor' do
      @new_state.lines.must_equal(Firby::Lines.new(['c']))
      @new_state.cursor.must_equal(Firby::Cursor.new(1, 0))
      @old_state.must_equal(Firby::ReplState.blank)
    end
  end
end
