require 'colorize'
require_relative 'cursor'
require_relative 'board'

class Display
  
  attr_reader :board, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
  end

  def background_color(pos)
    if pos == cursor.start_pos
      :light_blue
    elsif pos == cursor.cursor_pos
      :red
    else
      unselected_piece_color(pos)
    end
  end

  def get_input
    cursor.get_input
  end

  def piece_display(piece, pos)
    " #{piece.symbol} ".colorize(background: background_color(pos))
  end

  def render(name)
    system('clear')
    puts "Make your move, #{name}"

    board.each_with_index do |piece, pos|
      print piece_display(piece, pos)
      puts "" if pos[1] == 7
    end
  end

  def unselected_piece_color(pos)
    row, col = pos

    if row.even?
      col.even? ? :white : :light_black
    else
      col.odd? ? :white : :light_black
    end
  end

end
