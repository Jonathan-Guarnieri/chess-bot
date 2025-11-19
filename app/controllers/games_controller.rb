class GamesController < ApplicationController
  def move
    old_fen = session[:game_fen] || Chess::Game.new.board.to_fen
    game = Chess::Game.load_fen(old_fen)
    @from = params[:from]
    @to = params[:to]

    move = "#{@from}#{@to}"
    game.move(move)

    @piece = game.board[@to]
    @active_player = game.active_player
    @sound_name= get_sound_event_from(game)

    session[:game_fen] = game.board.to_fen

    respond_to do |format|
      format.turbo_stream { render :move }
    end
  rescue Chess::IllegalMoveError => e
    head :unprocessable_entity
  end

  private

  def get_sound_event_from(game)
    # TODO: Implement all sounds logic
    return :'move-check' if game.board.check?
    :'move-self'
  end
end
