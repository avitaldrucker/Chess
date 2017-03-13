require_relative 'board'
require_relative 'human_player'
require_relative 'cursor'
require './computer_player'

class Game

  attr_accessor :current_player

  def initialize(player1, player2, computer)
    @board = Board.new
    display = Display.new(@board)

    @player1 = HumanPlayer.new(player1, :white, display)

    if computer
      @player2 = ComputerPlayer.new(:black, @board, display)
    else
      @player2 = HumanPlayer.new(player2, :black, display)
    end

    @current_player = @player1
  end

  def over?
    board.checkmate?(:white) || board.checkmate?(:black)
  end

  def play
    play_turn until over?
    puts "#{winner.name} wins!"
  end

  def play_turn
    start_pos, end_pos = current_player.play_turn
    board.move_piece(start_pos, end_pos, current_player.color)
    promote_pawn(end_pos) if board.pawn_promotion_necessary?(end_pos)
    switch_players!
    rescue ChessError => e
      puts e.message
      sleep(2)
      retry
  end

  def promote_pawn(end_pos)
    board.promote_pawn(*current_player.prompt_promote_piece(end_pos));
    rescue ChessError => e
      puts e.message
      retry
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

  private

  attr_reader :player1, :player2, :board
end

if __FILE__ == $PROGRAM_NAME
  system('clear')
  puts "Player 1, type your name and hit enter. Your pieces are white."
  name1 = gets.chomp
  begin
    puts "#{name1.capitalize}, would you like to play against a human or computer?"
    puts "Type 'human' or 'computer'."
    player2_class_input = gets.chomp
    unless ['human', 'computer'].include?(player2_class_input)
      raise "Wrong input. Please type 'human' or 'computer'."
    end
  rescue => e
    puts e
    retry
  end

  player2_class = case player2_class_input
  when "human"
    computer = false
    puts "Player 2, type your name and hit enter. Your pieces are black."
    name2 = gets.chomp
  when "computer"
    computer = true
  end

  Game.new(name1, name2, computer).play
end
