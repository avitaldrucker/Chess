require_relative 'piece_classes/piece'
require_relative 'piece_classes/bishop'
require_relative 'piece_classes/king'
require_relative 'piece_classes/knight'
require_relative 'piece_classes/nullpiece'
require_relative 'piece_classes/pawn'
require_relative 'piece_classes/queen'
require_relative 'piece_classes/rook'

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

  def checkmate_rating
    [:white, :black].each do |color|
     if board.checkmate?(color)
       return next_mover_color == color ? -1000 : 1000
     end
    end

    nil
  end

  def rating(depth = 0)
    return checkmate_rating if checkmate_rating

    if depth >= 1
      return pieces_sum(toggle_mark) - pieces_sum(next_mover_color)
    end

    max_children_rating(depth) * -1
  end

  def max_children_rating(depth)
    max_node = nil
    max_rating = nil

    children.each do |node|
      node_rating = node.rating(depth + 1)
      if max_node.nil? || max_rating < node_rating
        max_node = node
        max_rating = node_rating
      end
    end

    max_rating
  end

  def pieces_sum(color)
    sum = 0

    board.pieces_colored(color).each do |piece|
      sum += PIECE_VALUES[piece.class]
    end

    sum
  end

  def children
    nodes = []

    board.pieces_colored(next_mover_color).each do |piece|
      piece.valid_moves.each do |end_pos|
        new_board = board.dup
        new_board.move_piece(piece.position, end_pos, next_mover_color)
        nodes << ChessNode.new(new_board, toggle_mark, [piece.position, end_pos])
      end
    end

    nodes
  end

  def toggle_mark
    next_mover_color == :white ? :black : :white
  end

  def possible_moves
  end
end
