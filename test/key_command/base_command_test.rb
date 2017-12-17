# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/fir/key_command/key_command'
require_relative '../../lib/fir/repl_state'
require_relative '../../lib/fir/lines'
require_relative '../../lib/fir/cursor'
require_relative './key_command_interface_test'

describe Fir::KeyCommand do
  describe 'interface' do
    include KeyCommandInterfaceTest

    before do
      @command = Fir::KeyCommand.new(' ', Fir::ReplState.blank)
    end
  end
end
