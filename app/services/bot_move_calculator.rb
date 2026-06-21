# Calculates the next bot move from a FEN position, without external chess libraries.
# Returns a two-element array: ["from", "to"], where each is a board square like "e2" and "e4".

class BotMoveCalculator
  include GameHelpers
  include BoardHelpers
  include Captures
  include Castle

  def initialize(fen)
    @fen = fen
  end

  def call!
    log_board('received to calculate:')
    calculate_move
  end

  private

  def calculate_move
    move_to_capture = capture_moves.sample

    return move_to_capture if move_to_capture.present?
    return next_move_to_castle if can_active_player_castle?

    "I don't know what to do"
  end
end
