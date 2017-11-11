# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/firby/key_command/key_command'
require_relative '../../lib/firby/repl_state'

describe Firby::KeyCommand do
  describe 'self.build' do
    it 'instantiates the correct command' do
      Firby::KeyCommand
        .build("\177", Firby::ReplState.blank)
        .class
        .must_equal(Firby::KeyCommand::BackspaceCommand)
      Firby::KeyCommand
        .build("\u0003", Firby::ReplState.blank)
        .class
        .must_equal(Firby::KeyCommand::CtrlCCommand)
      Firby::KeyCommand
        .build("\r", Firby::ReplState.blank)
        .class
        .must_equal(Firby::KeyCommand::EnterCommand)
      Firby::KeyCommand
        .build('c', Firby::ReplState.blank)
        .class
        .must_equal(Firby::KeyCommand::SingleKeyCommand)
    end
  end
end
