# Calculates the next bot move from a FEN position, without external chess libraries.
# Returns a two-element array: ["from", "to"], where each is a board square like "e2" and "e4".

class BotMoveCalculator
  def initialize(fen)
    @fen = fen
  end

  def call!
    calculate_move
  end

  private

  def calculate_move
    next_move_to_castle
  end

  def next_move_to_castle
    if active_player == :black
      return "e7", "e6" unless piece_on("e6")
      return "f8", "e7" unless piece_on("e7")
      return "g8", "f6" unless piece_on("f6")
      return "e8", "g8" unless piece_on("g8")
    end
    # TODO: implement as white
  end

  def piece_on(square)
    square_col = square.first
    square_row = square.last

    fen_by_row = @fen.split(' ').first.split('/')
    pieces_by_row = fen_by_row.map do |fen_row|
      row = []
      fen_row.split('').each do |char|
        if (Integer(char) rescue false)
          row << Array.new(char.to_i)
        else
          row << char
        end
      end
      row.flatten
    end

    cols = %w(a b c d e f g h)
    rows = %w(8 7 6 5 4 3 2 1)

    square_col_index = cols.index(square_col)
    square_row_index = rows.index(square_row)

    pieces_by_row[square_row_index][square_col_index]
  end

  def active_player
    fen_player_char = @fen.split(' ').second

    case fen_player_char
    when 'b'
      :black
    when 'w'
      :white
    else
      raise "Unable to define active_player"
    end
  end
end
