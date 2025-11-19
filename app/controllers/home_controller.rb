class HomeController < ApplicationController
  def index
    fen = session[:game_fen].present? ? session[:game_fen] : Chess::Game.new.board.to_fen
    game = Chess::Game.load_fen(fen)
    @board = game.board
    @active_player = game.active_player
  end
end
