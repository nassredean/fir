# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/fir/key_command/ctrl_c_command'
require_relative '../../lib/fir/repl_state'
require_relative './key_command_interface_test'

describe 'Ctrl-C input' do
  include KeyCommandInterfaceTest
  include KeyCommandSubclassTest

  before do
    @old_state = Fir::ReplState.blank
    @command = Fir::CtrlCCommand.new("\u0003", @old_state)
  end

  it 'must raise a SystemExit' do
    assert_raises SystemExit do
      @command.execute
    end
  end
end
