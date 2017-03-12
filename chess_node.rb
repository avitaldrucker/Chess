require_relative 'piece_classes/piece'
require_relative 'piece_classes/bishop'
require_relative 'piece_classes/king'
require_relative 'piece_classes/knight'
require_relative 'piece_classes/nullpiece'
require_relative 'piece_classes/pawn'
require_relative 'piece_classes/queen'
require_relative 'piece_classes/rook'
require 'byebug'

class ChessNode

  attr_reader :next_mover_color, :board, :move

  PIECE_VALUES = {
    Pawn => 1,
    Knight => 3,
    Bishop => 3,
    Rook => 5,
    Queen => 9,
    King => 100
  }

  def initialize(board, next_mover_color, move = nil)
    @board = board
    @next_mover_color = next_mover_color
    @move = move
  end

  def rating(depth = 0)
    debugger if self.move[1] == [4, 3]
    if board.checkmate?(:white) || board.checkmate?(:black)
      return board.winner == next_mover_color ? 1000 : -1000
    end

    if depth >= 1
      sum = 0
      board.pieces_colored(toggle_mark).each do |piece|
        sum += PIECE_VALUES[piece.class]
      end
      board.pieces_colored(next_mover_color).each do |piece|
        sum -= PIECE_VALUES[piece.class]
      end

      return sum
    end

    children.map { |node| node.rating(depth + 1) }.min * -1
  end

  def children
    return @children if @children
    nodes = []

    board.pieces_colored(self.next_mover_color).each do |piece|
      piece.valid_moves.each do |end_pos|
        new_board = board.dup #O(n)
        new_board.change_piece_pos(piece.position, end_pos) #O(1)
        nodes << ChessNode.new(new_board, toggle_mark, [piece.position, end_pos]) #O(1)
      end
    end

    @children = nodes
    @children
  end



  def toggle_mark
    next_mover_color == :white ? :black : :white
  end

  def possible_moves
  end
end
