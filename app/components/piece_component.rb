class PieceComponent < ViewComponent::Base
  def initialize(fen_piece)
    @piece = piece_asset_name_for(fen_piece&.to_sym)
  end

  def render?
    @piece.present?
  end

  private

  def piece_asset_name_for(fen_piece)
    {
      r: "br",
      n: "bn",
      b: "bb",
      q: "bq",
      k: "bk",
      p: "bp",
      R: "wr",
      N: "wn",
      B: "wb",
      Q: "wq",
      K: "wk",
      P: "wp"
    }[fen_piece]
  end
end
