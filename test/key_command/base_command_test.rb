# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/firby/key_command/base_command'
require_relative '../../lib/firby/repl_state'
require_relative '../../lib/firby/lines'
require_relative '../../lib/firby/cursor'
require_relative './key_command_interface_test'

describe Firby::KeyCommand::BaseCommand do
  describe 'interface' do
    include KeyCommandInterfaceTest

    before do
      @command = Firby::KeyCommand::BaseCommand.new(' ', Firby::ReplState.blank)
    end
  end
end
