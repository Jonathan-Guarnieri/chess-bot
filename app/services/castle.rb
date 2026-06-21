module Castle
  def next_move_to_castle
    if active_player == :black
      return "e7", "e5" if piece_at("e7") == 'p' 
      return "f8", "e7" if piece_at("f8") == 'b'
      return "g8", "f6" if piece_at("g8") == 'n'
      return "e8", "g8" if piece_at("e8") == 'k'
    end
    # TODO: implement as white
  end
end
