# frozen_string_literal: true
# encoding: UTF-8

require_relative '../lib/fir/repl_state'
require_relative '../lib/fir/lines'
require_relative '../lib/fir/line'
require_relative '../lib/fir/cursor'

module StateHelper
  def self.build(lines, cursor)
    Fir::ReplState.new(
      Fir::Lines.build(*lines),
      Fir::Cursor.new(x: cursor[0], y: cursor[1]),
      binding
    )
  end
end
