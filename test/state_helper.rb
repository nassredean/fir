# frozen_string_literal: true
# encoding: UTF-8

module StateHelper
  require_relative '../lib/firby/repl_state'
  require_relative '../lib/firby/lines'
  require_relative '../lib/firby/cursor'

  def self.build(lines, cursor)
    Firby::ReplState.new(
      Firby::Lines.new(*lines),
      Firby::Cursor.new(cursor[0], cursor[1])
    )
  end
end
