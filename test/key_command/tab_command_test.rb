# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/fir/repl_state'
require_relative './key_command_interface_test'

TAB_CHAR = "\9"

describe Fir::TabCommand do
  describe 'interface' do
    include KeyCommandInterfaceTest
    include KeyCommandSubclassTest

    before do
      @command = Fir::TabCommand.new(TAB_CHAR,
                                     Fir::ReplState.blank)
    end
  end

  describe 'tab key with no suggestion' do
    before do
      @old_state = Fir::ReplState.blank
      @new_state = Fir::TabCommand.new(TAB_CHAR,
                                       @old_state).execute
    end

    it 'doesn\'t append to the array and the cursor remains at origin' do
      @new_state.lines.must_equal(Fir::Lines.blank)
      @new_state.cursor.must_equal(Fir::Cursor.blank)
      @old_state.must_equal(Fir::ReplState.blank)
    end
  end
end
