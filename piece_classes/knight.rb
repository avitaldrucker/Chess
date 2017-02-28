require_relative 'knight'
require_relative '../stepping_piece';

class Knight < Piece
  include SteppingPiece

  def initialize(current_position, color)
    @symbol = color == :white ? "♘" : "♞"
    super
  end

  def move_dirs
    [
      [1, 2], [1, -2], [-1, 2], [-1, -2],
      [2, 1], [2, -1], [-2, 1], [-2, -1]
    ]
  end

end
