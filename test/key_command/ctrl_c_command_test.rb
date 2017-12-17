# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/fir/key_command/ctrl_c_command'
require_relative './key_command_interface_test'
require_relative '../state_helper'

describe 'Ctrl-C input' do
  include KeyCommandInterfaceTest
  include KeyCommandSubclassTest

  before do
    @old_state = StateHelper.build([%w[def cow], %w[puts]], [2, 4])
    @command = Fir::CtrlCCommand.new("\u0003", @old_state)
  end

  it 'must blank out the state' do
    @new_state = @command.execute
    @new_state.must_equal(Fir::ReplState.blank)
  end
end
