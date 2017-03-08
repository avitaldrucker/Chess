require_relative 'board'
require_relative 'human_player'
require_relative 'cursor'

class Game
  attr_accessor :current_player

  def initialize(player1, player2)
    @board = Board.new
    display = Display.new(@board)

    @player1 = HumanPlayer.new(player1, :white, display)
    @player2 = HumanPlayer.new(player2, :black, display)
    @current_player = @player1
  end

  def play
    play_turn until over?
    puts "#{winner.name} wins!"
  end

  def play_turn
    begin
      board.move_piece(*current_player.play_turn, current_player.color)
    rescue ChessError => e
      puts e.message
      sleep(2)
      retry
    end

    switch_players!
  end

  def switch_players!
    self.current_player = current_player == player1 ? player2 : player1
  end

  def winner
    if board.checkmate?(:white)
      player2
    elsif board.checkmate?(:black)
      player1
    end
  end

  def over?
    board.checkmate?(:white) || board.checkmate?(:black)
  end

  private

  attr_reader :player1, :player2, :board
end

if __FILE__ == $PROGRAM_NAME
  system('clear')
  puts "Player 1, type your name and hit enter. Your pieces are white."
  name1 = gets.chomp
  puts "Player 2, type your name and hit enter. Your pieces are black."
  name2 = gets.chomp
  Game.new(name1, name2).play
end
