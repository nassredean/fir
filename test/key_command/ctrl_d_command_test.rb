# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/fir/key_command/ctrl_d_command'
require_relative './key_command_interface_test'
require_relative '../state_helper'

describe 'Ctrl-D input' do
  include KeyCommandInterfaceTest
  include KeyCommandSubclassTest

  before do
    @old_state = Fir::ReplState.blank
    @command = Fir::CtrlDCommand.new("\u0003", @old_state)
  end

  it 'must raise a SystemExit' do
    assert_raises SystemExit do
      @command.execute
    end
  end
end
