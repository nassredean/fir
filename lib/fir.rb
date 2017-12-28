# frozen_string_literal: true
# encoding: UTF-8

require 'io/console'
require 'optparse'
require_relative 'fir/key'
require_relative 'fir/key_command/key_command'
require_relative 'fir/repl_state'
require_relative 'fir/screen'
require_relative 'fir/version'

class Fir
  attr_reader :key
  attr_reader :screen

  def self.start(input, output, error)
    parse_opts(output)
    new(
      Key.new(input),
      Screen.new(output, error)
    ).perform(ReplState.blank)
  end

  def self.parse_opts(output)
    options = {}
    OptionParser.new do |cl_opts|
      cl_opts.banner = "Usage: fir [options]"
      cl_opts.on("-v", "--version", "Show version") do |v|
        options[:version] = v
      end
    end.parse!
    process_immediate_opts(options, output)
    options
  end

  def self.process_immediate_opts(opts, output)
    if opts[:version]
      output.syswrite(Fir::VERSION)
      exit(0)
    end
  end

  def initialize(key, screen)
    @key = key
    @screen = screen
  end

  def perform(state)
    state = yield(state) if block_given?
    perform(state) do
      state.transition(KeyCommand.for(key.get, state)) do |new_state|
        screen.update(state, new_state)
      end
    end
  end
end
