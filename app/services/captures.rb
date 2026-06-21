module Captures
  include GameHelpers
  include BoardHelpers

  def capture_moves
    SQUARES.flatten.filter_map do |square|
      next unless (piece = piece_at(square)) && piece_belongs_to_active_player?(piece)

      capture_moves_from(square)
    end.flatten(1)
  end
end
