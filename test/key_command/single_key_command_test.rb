# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/fir/key_command/single_key_command'
require_relative '../../lib/fir/repl_state'
require_relative '../../lib/fir/lines'
require_relative '../../lib/fir/cursor'
require_relative './key_command_interface_test'

describe Fir::SingleKeyCommand do
  describe 'interface' do
    include KeyCommandInterfaceTest
    include KeyCommandSubclassTest

    before do
      @command = Fir::SingleKeyCommand.new(
        'c',
        Fir::ReplState.blank
      )
    end
  end

  before do
    @old_state = Fir::ReplState.blank
    @new_state = Fir::SingleKeyCommand.new(
      'c',
      @old_state
    ).execute
  end

  it 'adds the character to the states current line and updates the cursor' do
    @new_state.lines.must_equal(Fir::Lines.new(['c']))
    @new_state.cursor.must_equal(Fir::Cursor.new(1, 0))
    @old_state.must_equal(Fir::ReplState.blank)
  end
end
