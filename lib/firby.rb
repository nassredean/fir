# frozen_string_literal: true
# encoding: UTF-8

require 'io/console'

module Firby
  class Repl
    def self.start(input, output)
      with_raw_io(input, output) do |i, o|
        repl([], i, o)
      end
    end

    def self.with_raw_io(input, output)
      input.raw do |i|
        output.raw do |o|
          return yield(i, o) if block_given?
        end
      end
    end

    def self.repl(line, input, output)
      line = yield(line) if block_given?
      repl(line, input, output) do |l|
        read_and_dispatch_key(l, input, output)
      end
    end

    def self.read_and_dispatch_key(line, input, output)
      char = get_char_from_key(input)
      CharacterHandlerFactory.build(char, line, input, output).call
    end

    def self.get_char_from_key(input)
      key = input.sysread(1).chr
      if key == "\e"
        special_key_thread = Thread.new do
          2.times { key += input.sysread(1).chr }
        end
        special_key_thread.join(0.0001)
        special_key_thread.kill
      end
      key
    end
  end
end

class CharacterHandlers
  def self.find(character)
    all.detect { |handler| handler.match?(character) }
  end

  def self.all
    [
      TabHandler,
      EnterHandler,
      BackspaceHandler,
      CtrlCHandler,
      EscapeHandler,
      SingleCharacterHandler
    ]
  end
end

class Cursor
  def self.back(n)
    "\e[#{n}D"
  end
end

class CharacterHandler
  attr_reader :character
  attr_reader :line
  attr_reader :input
  attr_reader :output

  def initialize(character, line, input, output)
    @character = character.dup
    @line = line.dup
    @input = input
    @output = output
  end

  def call
    line
  end
end

class TabHandler < CharacterHandler
  def self.match?(character)
    false
  end
end

class BackspaceHandler < CharacterHandler
  def self.match?(character)
    false
  end
end

class EnterHandler < CharacterHandler
  def self.match?(character)
    character == "\r"
  end

  def call
    line << "\n"
    output.syswrite("\n" + Cursor.back(line.length - 1))
    super
  end
end

class EscapeHandler < CharacterHandler
  def self.match?(character)
    false
  end
end

class SingleCharacterHandler < CharacterHandler
  def self.match?(character)
    character.match(/^.$/)
  end

  def call
    line << character
    output.syswrite(character)
    super
  end
end

class CtrlCHandler < CharacterHandler
  def self.match?(character)
    character == "\u0003"
  end

  def call
    exit(0)
  end
end

class CharacterHandlerFactory
  def self.build(character, line, input, output)
    CharacterHandlers.find(character).new(character, line, input, output)
  end
end
