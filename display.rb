require 'colorize'
require_relative 'cursor'
require 'byebug'
require_relative 'board'

class Display
  attr_reader :board, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
  end

  def render
    system('clear')
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
    while true
      render
      cursor.get_input
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  display = Display.new(Board.new)
  display.move_cursor
end
