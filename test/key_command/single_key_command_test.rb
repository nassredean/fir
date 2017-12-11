# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/fir/key_command/single_key_command'
require_relative '../../lib/fir/repl_state'
require_relative '../../lib/fir/lines'
require_relative '../../lib/fir/cursor'
require_relative './key_command_interface_test'

describe Fir::KeyCommand do
  describe Fir::KeyCommand::SingleKeyCommand do
    describe 'interface' do
      include KeyCommandInterfaceTest
      include KeyCommandSubclassTest

      before do
        @command = Fir::KeyCommand::SingleKeyCommand.new(
          'c',
          Fir::ReplState.blank
        )
      end
    end

    before do
      @old_state = Fir::ReplState.blank
      @new_state = Fir::KeyCommand::SingleKeyCommand.new(
        'c',
        @old_state
      ).execute
    end

    it 'adds the character to the states current line and updates the cursor' do
      @new_state.lines.must_equal(Fir::Lines.build(['c']))
      @new_state.cursor.must_equal(Fir::Cursor.new(x: 1, y: 0))
    end
  end
end
