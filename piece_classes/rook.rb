require_relative 'piece'
require_relative '../sliding_piece'

class Rook < Piece

  include SlidingPiece

  def self.castling_positions(king_positions)
    king_start_pos, king_end_pos = king_positions
    row = king_end_pos[0]

    if king_end_pos[1] - king_start_pos[1] > 0
      col = 7
      rook_end_col = king_end_pos[1] - 1
    else
      col = 0
      rook_end_col = king_end_pos[1] + 1
    end

    [[row, col], [row, rook_end_col]]
  end

  def initialize(position, color)
    @symbol = color == :white ? "♖" : "♜"
    super
  end

  def move_dirs
    [:up, :down, :left, :right]
  end

end
