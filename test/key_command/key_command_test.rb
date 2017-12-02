# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/fir/key_command/key_command'
require_relative '../../lib/fir/repl_state'

describe Fir::KeyCommand do
  describe 'self.build' do
    it 'instantiates the correct command' do
      Fir::KeyCommand
        .build("\177", Fir::ReplState.blank)
        .class
        .must_equal(Fir::KeyCommand::BackspaceCommand)
      Fir::KeyCommand
        .build("\u0003", Fir::ReplState.blank)
        .class
        .must_equal(Fir::KeyCommand::CtrlCCommand)
      Fir::KeyCommand
        .build("\r", Fir::ReplState.blank)
        .class
        .must_equal(Fir::KeyCommand::EnterCommand)
      Fir::KeyCommand
        .build('c', Fir::ReplState.blank)
        .class
        .must_equal(Fir::KeyCommand::SingleKeyCommand)
    end
  end
end
