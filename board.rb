require_relative 'piece'
require 'byebug'

class Board

  def self.empty_grid
    Array.new(8) { Array.new(8) }
  end

  def self.default_grid
    grid = []
    grid << Piece.ordered_pieces_row
    grid << Piece.pawn_row
    4.times { grid << Piece.empty_row }
    grid << Piece.pawn_row
    grid << Piece.ordered_pieces_row

    grid
  end

  def self.in_bounds?(delta, pos)
    row, col = pos
    delta_row, delta_col = delta
    new_pos = [row + delta_row, col + delta_col]
    new_pos.all? { |coord| coord.between?(0, 7) }
  end

  attr_reader :grid

  def initialize(board = Board.empty_grid)
    @grid = board
  end

  def move_piece(start_pos, end_pos)
    piece = self[start_pos]
    raise NoPieceError if piece.nil?
    raise InvalidMoveError unless piece.can_move?(start_pos, end_pos)

    self[start_pos] = nil
    self[end_pos] = piece
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def empty?(pos)
    self[pos].nil?
  end

end

class NoPieceError < StandardError
end

class InvalidMoveError < StandardError
end
