require 'colorize'
require_relative 'cursor'
require_relative 'board'

class Display
  attr_reader :board, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
  end

  def render(name)
    system('clear')
    puts "Make your move, #{name}"

    board.each_with_index do |piece, pos|
      row, col = pos
      piece_display = piece ? piece.symbol : "_"
      print pos == cursor.cursor_pos ? piece_display.red : piece_display
      col == 7 ? (puts "") : (print " ")
    end

  end

  def get_input
    cursor.get_input
  end

end
