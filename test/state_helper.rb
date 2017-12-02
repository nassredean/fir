# frozen_string_literal: true
# encoding: UTF-8

module StateHelper
  require_relative '../lib/fir/repl_state'
  require_relative '../lib/fir/lines'
  require_relative '../lib/fir/cursor'

  def self.build(lines, cursor)
    Fir::ReplState.new(
      Fir::Lines.new(*lines),
      Fir::Cursor.new(cursor[0], cursor[1])
    )
  end
end
