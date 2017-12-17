# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative '../../lib/fir/key_command/key_command'
require_relative '../../lib/fir/repl_state'

describe Fir::KeyCommand do
  describe 'self.for' do
    it 'instantiates the correct command' do
      Fir::KeyCommand
        .for("\177", Fir::ReplState.blank)
        .class
        .must_equal(Fir::BackspaceCommand)
      Fir::KeyCommand
        .for("\u0003", Fir::ReplState.blank)
        .class
        .must_equal(Fir::CtrlCCommand)
      Fir::KeyCommand
        .for("\r", Fir::ReplState.blank)
        .class
        .must_equal(Fir::EnterCommand)
      Fir::KeyCommand
        .for('c', Fir::ReplState.blank)
        .class
        .must_equal(Fir::SingleKeyCommand)
    end
  end
end
