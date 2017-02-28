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

  def render(name)
    system('clear')
    puts "Make your move, #{name}"
    board.grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        piece_representation = piece.nil? ? "_" : piece.symbol
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

  def get_input
    cursor.get_input
  end

end
