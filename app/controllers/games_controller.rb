class GamesController < ApplicationController
  before_action :set_game, only: [:player_move, :bot_move, :possible_moves]

  def player_move
    @from = params[:from]
    @to = params[:to]

    do_move

    render :move, formats: :turbo_stream
  rescue Chess::IllegalMoveError => e
    head :unprocessable_entity
  end

  def bot_move
    @from, @to = calculate_bot_move#(fen) # TODO: input as fen

    do_move

    render :move, formats: :turbo_stream
  end

  def restart
    @game = Chess::Game.new
    session[:game_fen] = @game.board.to_fen

    redirect_to root_path
  end

  def possible_moves
    possible_moves = @game.board.generate_moves(params[:square])
    possible_moves.map! do |possible_move|
      game_dup = Chess::Game.load_fen(session[:game_fen])
      game_dup.move(possible_move)
      game_dup.coord_moves.last[-2..]
    end

    render json: { possible_moves: }
  end

  private

  def set_game
    old_fen = session[:game_fen] || Chess::Game.new.board.to_fen
    @game = Chess::Game.load_fen(old_fen)
  end

  def do_move
    unless @from && @to
      raise "You need to set @from and @to before calling #do_move"
    end

    @game.move("#{@from}#{@to}")
    session[:game_fen] = @game.board.to_fen

    @second_to_last_move = session[:last_move]
    @last_move = { from: @from, to: @to }
    session[:last_move] = @last_move

    @piece = @game.board[@to]
    @active_player = @game.active_player
    @sound_name= sound_event
  end

  def sound_event
    # TODO: Implement all sounds logic
    return :'move-check' if @game.board.check?
    :'move-self'
  end

  def calculate_bot_move # TODO: isolate in its own class
    squares = %w(
      a1 a2 a3 a4 a5 a6 a7 a8
      b1 b2 b3 b4 b5 b6 b7 b8
      c1 c2 c3 c4 c5 c6 c7 c8
      d1 d2 d3 d4 d5 d6 d7 d8
      e1 e2 e3 e4 e5 e6 e7 e8
      f1 f2 f3 f4 f5 f6 f7 f8
      g1 g2 g3 g4 g5 g6 g7 g8
      h1 h2 h3 h4 h5 h6 h7 h8
    )

    squares.shuffle.each do |from|
      possible_moves = @game.board.generate_moves(from)
      next unless possible_moves.any?

      squares.shuffle.each do |to| 
        move = "#{from}#{to}"
        test_game = Chess::Game.load_fen(@game.board.to_fen)
        test_game.move(move) rescue next
        return from, to
      end
    end

    raise "Unable to find a bot move"
  end
end
