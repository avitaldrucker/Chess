require 'colorize'
require_relative 'cursor'
require 'byebug'
require_relative 'board'

class Display
  attr_reader :board, :cursor

  def initialize(board, debug = false)
    @board = board
    @cursor = Cursor.new([0, 0], board)
    @debug = debug
  end

  def render
    #system('clear') if gets.chomp == ""
    puts "  #{(0..7).to_a.join(" ")}"
    board.grid.each_with_index do |row, row_idx|
      print "#{row_idx} "
      row.each_with_index do |piece, col_idx|
        piece_representation = piece.nil? ? "_" : piece.symbol.to_s
        if [row_idx, col_idx] == cursor.cursor_pos
          print piece_representation.red
        else
          print piece_representation
        end
        print " "
      end
      puts ""
    end
  end

  def move_cursor
    start_pos = nil
    end_pos = nil
    while start_pos.nil? && end_pos.nil?
      render
      start_pos = cursor.get_input
    end
    p "valid moves: #{board[start_pos].valid_moves}" if @debug
    p "in check? #{board.in_check?(board[start_pos].color)}"
    p "checkmate? #{board.checkmate?(board[start_pos].color)}"
    while end_pos.nil?
      render
      end_pos = cursor.get_input
    end
    board.move_piece(start_pos, end_pos)
  end

  def play
    while true
      move_cursor
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  display = Display.new(Board.new, true)
  display.play
end
