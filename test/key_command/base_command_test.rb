# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/fir/key_command/base_command'
require_relative '../../lib/fir/repl_state'
require_relative '../../lib/fir/lines'
require_relative '../../lib/fir/cursor'
require_relative './key_command_interface_test'

describe Fir::KeyCommand::BaseCommand do
  describe 'interface' do
    include KeyCommandInterfaceTest

    before do
      @command = Fir::KeyCommand::BaseCommand.new(' ', Fir::ReplState.blank)
    end
  end
end
