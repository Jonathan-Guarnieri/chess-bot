module GameHelpers
  def active_player_char
    @fen.split(' ')[1]
  end

  def possible_castles
    @fen.split(' ')[2]
  end

  def active_player
    active_player_char == 'b' ? :black : :white
  end

  def can_active_player_castle?
    castles = active_player_char == 'w' ? %w[K Q] : %w[k q]
    possible_castles.chars.intersect?(castles)
  end
end
