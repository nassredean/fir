# frozen_string_literal: true
# encoding: UTF-8

require_relative './backspace_command'
require_relative './ctrl_c_command'
require_relative './enter_command'
require_relative './single_key_command'

class Fir
  module KeyCommand
    class << self
      def build(character, state)
        find(character).new(character, state)
      end

      private

      def find(character)
        command_registery.detect { |key_command| key_command.match?(character) }
      end

      def command_registery
        [
          EnterCommand,
          BackspaceCommand,
          CtrlCCommand,
          SingleKeyCommand
        ]
      end
    end
  end
end

# use the inherited registry example Sandi gave us
# collapse this logic onto the base command
# remove the KeyCommand module
# rename the BaseCommand to KeyCommand
# define "".to_command in lib/ext/string.rb
