require_relative 'piece';
require_relative '../stepping_piece'
require 'byebug'

class King < Piece

  include SteppingPiece

  TRADITIONAL_MOVE_DIRS =
    [
      [-1, 0], [1, 0], [0, -1], [0, 1],
      [-1, -1], [-1, 1], [1, -1], [1, 1]
    ]

  def initialize(position, color)
    @symbol = color == :white ? "♔" : "♚"
    super
  end

  def castling_possible?(dir)
    row, col = self.position

    range = dir === :left ? (0...col) : (col + 1..7)

    rook = Piece.find_piece(self.board, Rook, { row: row })

    !self.moved && rook && self.color == rook.color && !rook.moved &&
      board.empty?(col + 1...rook.position[1]) &&
      skipped_spots_safe?
  end

  def skipped_spots_safe?
    row, col = self.position
    (col..col + 2).count do |new_col|
      move_into_check?([row, new_col])
    end === 0
  end

  def move_dirs
    moves = TRADITIONAL_MOVE_DIRS
    moves = moves + [[0, -2]] if castling_possible?(:left)
    moves = moves + [[0, 2]] if castling_possible?(:right)

    moves
  end

end
