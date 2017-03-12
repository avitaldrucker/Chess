require_relative 'piece'
require_relative '../sliding_piece'

class Queen < Piece

  include SlidingPiece

  def initialize(position, color)
    @symbol = color == :white ? "♕" : "♛"
    super
  end

  def move_dirs
    [
      :up, :down, :left, :right,
      :diag_ul, :diag_ur, :diag_dl, :diag_dr
    ]
  end

end
