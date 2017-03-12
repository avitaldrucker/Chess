require_relative 'piece'
require_relative '../sliding_piece'

class Rook < Piece

  include SlidingPiece

  def initialize(position, color)
    @symbol = color == :white ? "♖" : "♜"
    super
  end

  def move_dirs
    [:up, :down, :left, :right]
  end

end
