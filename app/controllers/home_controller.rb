class HomeController < ApplicationController
  def index
    fen = session[:game_fen].present? ? session[:game_fen] : Chess::Game.new.board.to_fen
    @board = Chess::Game.load_fen(fen).board
  end

  def move
    old_fen = session[:game_fen] || Chess::Game.new.board.to_fen
    game = Chess::Game.load_fen(old_fen)
    @from = params[:from]
    @to = params[:to]
    @piece = game.board[@from]

    move = "#{@from}#{@to}"
    game.move(move)

    session[:game_fen] = game.board.to_fen

    respond_to do |format|
      format.turbo_stream { render :move }
    end
  rescue Chess::IllegalMoveError => e
    head :unprocessable_entity
  end
end
