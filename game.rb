require 'board'
require 'human_player'
require 'cursor'
require 'display'

class Game

  def initialize(player1, player2)
    @player1 = Player.new(player1, :white, board)
    @player2 = Player.new(player2, :black, board)
    @current_player = @player1
    @board = Board.new
  end

  def play
    play_turn until over?
    puts "#{winner} wins!"
  end

  def play_turn
    display
    begin
      start_pos, end_pos = current_player.play_turn
      board.move_piece(start_pos, end_pos)
    rescue NoPieceError
      puts "There is no piece at the position you selected! Select a piece"
      retry
    rescue InvalidMoveError
      puts "This piece can't move that way! Try again"
      retry
    rescue MoveChecksKingError
      puts "That move would leave your king in check! Don't do it"
      retry
    end
    switch_players!
  end

  def display
  end

  def switch_players!
    current_player = current_player == player1 ? player2 : player1
  end

  def winner
    if board.checkmate?(:white)
      player1
    elsif board.checkmate?(:black)
      player2
    end
  end

  def over?
    board.checkmate?(:white) || board.checkmate?(:black)
  end

  private
  attr_reader :player1, :player2, :board, :current_player
end
