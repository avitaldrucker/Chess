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

  def same_color_pieces
    @same_color_pieces ||= board.pieces_colored()
  end

  def rating(depth = 0)

    if board.checkmate?(:white)
      next_mover_color == :white ? -1000 : 1000
    end
    if board.checkmate?(:black)
      next_mover_color == :black ? -1000 : 1000
    end

    if depth >= 1 #(n)
      sum = 0
      board.pieces_colored(toggle_mark).each do |piece|
        sum += PIECE_VALUES[piece.class]
      end
      board.pieces_colored(next_mover_color).each do |piece|
        sum -= PIECE_VALUES[piece.class]
      end
      return sum
    end

    max_rating = nil
    max_node = nil

    children.each do |node|
      node_rating = node.rating(depth + 1)
      if max_node.nil? || max_rating < node_rating
        max_node = node
        max_rating = node_rating
      end
    end

    max_rating * -1
    # children.map { |node| node.rating(depth + 1, rook) }.max * -1 #O(n^3)
  end

  def children #O(n)
    # return @children if @children
    nodes = []

    board.pieces_colored(self.next_mover_color).each do |piece| #O(1)
      piece.moves.each do |end_pos| #O(n)
        new_board = board.dup #O(1)
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
