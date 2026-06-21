module BoardHelpers
  SQUARES = (1..8).to_a.reverse.map { |n| %w(a b c d e f g h).map { _1+n.to_s } }

  def piece_at(square)
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

  # returns an array of arrays:
  # array = line
  # el in array = square
  def board
    @fen.split(' ').first.split('/').map do |line|
      line.chars.map do |el|
        ("1".."8").cover?(el) ? Array.new(el.to_i) : el
      end.flatten
    end
  end

  # for debug purposes
  def log_board(msg = nil)
    puts ''
    puts ''

    if msg
      puts msg 
      puts ''
    end

    puts '---------------- BOARD: ----------------'

    board.each do |line|
      p line
    end

    puts '----------------------------------------'

    puts ''
    puts ''
  end

  def squares_attacked_by_piece_at(square)
    piece = piece_at(square)
    raise "No pieces at square: #{square}" unless piece

    attacked_squares = []
    li = line_index(square)
    ci = column_index(square)

    case piece
    when 'p'
      attacked_squares << SQUARES[li + 1][ci - 1] unless ci == 0
      attacked_squares << SQUARES[li + 1][ci + 1] unless ci == 7
    when 'P'
      attacked_squares << SQUARES[li - 1][ci - 1] unless ci == 0
      attacked_squares << SQUARES[li - 1][ci + 1] unless ci == 7
    when 'r', 'R'
      (li - 1).downto(0) { attacked_squares << SQUARES[_1][ci]; break if piece_at(attacked_squares.last) }
      (li + 1).upto(7)   { attacked_squares << SQUARES[_1][ci]; break if piece_at(attacked_squares.last) }
      (ci - 1).downto(0) { attacked_squares << SQUARES[li][_1]; break if piece_at(attacked_squares.last) }
      (ci + 1).upto(7)   { attacked_squares << SQUARES[li][_1]; break if piece_at(attacked_squares.last) }
    when 'b', 'B'
      # up - left:
      l = li; c = ci;
      while l != 0 && c != 0 do
        attacked_square = SQUARES[(l -= 1)][(c -= 1)]
        attacked_squares << attacked_square
        break if piece_at(attacked_square)
      end
      # up - right:
      l = li; c = ci;
      while l != 0 && c != 7 do
        attacked_square = SQUARES[(l -= 1)][(c += 1)]
        attacked_squares << attacked_square
        break if piece_at(attacked_square)
      end
      # down - left:
      l = li; c = ci;
      while l != 7 && c != 0 do
        attacked_square = SQUARES[(l += 1)][(c -= 1)]
        attacked_squares << attacked_square
        break if piece_at(attacked_square)
      end
      # down - right:
      l = li; c = ci;
      while l != 7 && c != 7 do
        attacked_square = SQUARES[(l += 1)][(c += 1)]
        attacked_squares << attacked_square
        break if piece_at(attacked_square)
      end
    when 'q', 'Q'
      # up + down + left + right:
      (li - 1).downto(0) { attacked_squares << SQUARES[_1][ci]; break if piece_at(attacked_squares.last) }
      (li + 1).upto(7)   { attacked_squares << SQUARES[_1][ci]; break if piece_at(attacked_squares.last) }
      (ci - 1).downto(0) { attacked_squares << SQUARES[li][_1]; break if piece_at(attacked_squares.last) }
      (ci + 1).upto(7)   { attacked_squares << SQUARES[li][_1]; break if piece_at(attacked_squares.last) }


      # up - left:
      l = li; c = ci;
      while l != 0 && c != 0 do
        attacked_square = SQUARES[(l -= 1)][(c -= 1)]
        attacked_squares << attacked_square
        break if piece_at(attacked_square)
      end
      # up - right:
      l = li; c = ci;
      while l != 0 && c != 7 do
        attacked_square = SQUARES[(l -= 1)][(c += 1)]
        attacked_squares << attacked_square
        break if piece_at(attacked_square)
      end
      # down - left:
      l = li; c = ci;
      while l != 7 && c != 0 do
        attacked_square = SQUARES[(l += 1)][(c -= 1)]
        attacked_squares << attacked_square
        break if piece_at(attacked_square)
      end
      # down - right:
      l = li; c = ci;
      while l != 7 && c != 7 do
        attacked_square = SQUARES[(l += 1)][(c += 1)]
        attacked_squares << attacked_square
        break if piece_at(attacked_square)
      end
    when 'n', 'N'
      attacked_squares << SQUARES[li+2][ci+1] if (li+2).between?(0, 7) && (ci+1).between?(0, 7)
      attacked_squares << SQUARES[li+2][ci-1] if (li+2).between?(0, 7) && (ci-1).between?(0, 7)
      attacked_squares << SQUARES[li-2][ci+1] if (li-2).between?(0, 7) && (ci+1).between?(0, 7)
      attacked_squares << SQUARES[li-2][ci-1] if (li-2).between?(0, 7) && (ci-1).between?(0, 7)
      attacked_squares << SQUARES[li+1][ci+2] if (li+1).between?(0, 7) && (ci+2).between?(0, 7)
      attacked_squares << SQUARES[li+1][ci-2] if (li+1).between?(0, 7) && (ci-2).between?(0, 7)
      attacked_squares << SQUARES[li-1][ci+2] if (li-1).between?(0, 7) && (ci+2).between?(0, 7)
      attacked_squares << SQUARES[li-1][ci-2] if (li-1).between?(0, 7) && (ci-2).between?(0, 7)
    when 'k', 'K'
      attacked_squares << SQUARES[li-1][ci-1] if (li-1).between?(0, 7) && (ci-1).between?(0, 7)
      attacked_squares << SQUARES[li-1][ci]   if (li-1).between?(0, 7) && (ci).between?(0, 7)
      attacked_squares << SQUARES[li-1][ci+1] if (li-1).between?(0, 7) && (ci+1).between?(0, 7)
      attacked_squares << SQUARES[li][ci-1]   if (li).between?(0, 7) && (ci-1).between?(0, 7)
      attacked_squares << SQUARES[li][ci+1]   if (li).between?(0, 7) && (ci+1).between?(0, 7)
      attacked_squares << SQUARES[li+1][ci-1] if (li+1).between?(0, 7) && (ci-1).between?(0, 7)
      attacked_squares << SQUARES[li+1][ci]   if (li+1).between?(0, 7) && (ci).between?(0, 7)
      attacked_squares << SQUARES[li+1][ci+1] if (li+1).between?(0, 7) && (ci+1).between?(0, 7)
    end

    attacked_squares
  end

  def capture_moves_from(square)
    squares_attacked_by_piece_at(square).filter_map do |attacked_square|
      if is_this_move_attacking_an_opponent_piece?([square, attacked_square])
        [square, attacked_square]
      end
    end
  end

  def line_index(square)
    SQUARES.index { _1.include?(square) }
  end

  def column_index(square)
    column_index = SQUARES[line_index(square)].index(square)
  end

  def piece_belongs_to_active_player?(piece)
    if active_player == :white
      piece == piece.upcase
    else
      piece == piece.downcase
    end
  end

  def is_this_move_attacking_an_opponent_piece?(move)
    original_piece = piece_at(move.first)
    attacked_piece = piece_at(move.last)
    return false unless original_piece && attacked_piece

    original_piece_color = original_piece == original_piece.upcase ? :white : :black
    attacked_piece_color = attacked_piece == attacked_piece.upcase ? :white : :black

    original_piece_color != attacked_piece_color
  end
end
