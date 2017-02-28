require_relative 'piece';
require_relative '../stepping_piece'

class King < Piece
  include SteppingPiece

  def initialize(current_position, color)
    @symbol = color == :white ? "♔" : "♚"
    super
  end

  def move_dirs
    [
      [-1, 0], [1, 0], [0, -1], [0, 1],
      [-1, -1], [-1, 1], [1, -1], [1, 1]
    ]
  end
  
end
