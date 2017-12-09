# frozen_string_literal: true
# encoding: UTF-8

require 'minitest/autorun'
require_relative 'key_command'
require_relative '../key_command/key_command_interface_test'

describe Double::KeyCommand do
  include KeyCommandInterfaceTest
  include KeyCommandSubclassTest

  before do
    @command = Double::KeyCommand.new(@state)
  end
end
