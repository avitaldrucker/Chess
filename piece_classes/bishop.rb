require_relative 'piece';
require_relative '../sliding_piece';

class Bishop < Piece
  include SlidingPiece

  def initialize(current_position, color)
    @symbol = color == :white ? "♗" : "♝"
    super
  end

  def move_dirs
    [:diag_ul, :diag_ur, :diag_dl, :diag_dr]
  end
end
