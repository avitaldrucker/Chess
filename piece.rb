require_relative 'sliding_piece'
require_relative 'stepping_piece'

class Piece
  #make a move_dirs method
  attr_reader :symbol, :color
  attr_accessor :board

  def initialize(current_position, color)
    @current_position = current_position
    @color = color
  end

  def self.pawn_row
    [Pawn.new] * 8
  end

  def self.ordered_pieces_row
    [Rook.new, Knight.new, Bishop.new, Queen.new, King.new, Bishop.new, Knight.new, Rook.new]
  end

  def self.empty_row
    [nil] * 8
  end

  def can_move?(start_pos, end_pos)
    true
  end

  def valid_move?(pos)
    return true if board.empty?(pos)
    return false if board[pos].color == self.color
    true
  end

end



class King < Piece
  include SteppingPiece

  def initialize(current_position, color)
    @symbol = :K
    super
  end

  def move_dirs
    [ [-1, 0], [1, 0], [0, -1], [0, 1],
      [-1, -1],[-1, 1], [1, -1], [1, 1] ]
  end
end

class Knight < Piece
  include SteppingPiece

  def initialize(current_position, color)
    @symbol = :N
    super
  end

  def move_dirs
    [ [1, 2], [1, -2], [-1, 2], [-1, -2],
      [2, 1], [2, -1], [-2, 1], [-2, -1] ]
  end

end


class Queen < Piece
  include SlidingPiece

  def initialize(current_position, color)
    @symbol = :Q
    super
  end

  def move_dirs
    [
      :up, :down, :left, :right,
      :diagonal_ul, :diagonal_ur, :diagonal_dl, :diagonal_dr
    ]
  end

end

class Bishop < Piece
  include SlidingPiece

  def initialize(current_position, color)
    @symbol = :B
    super
  end

  def move_dirs
    [:diagonal_ul, :diagonal_ur, :diagonal_dl, :diagonal_dr]
  end
end



class Rook < Piece
  include SlidingPiece

  def initialize(current_position, color)
    @symbol = :R
    super
  end

  def move_dirs
    [:up, :down, :left, :right]
  end
end

class NullPiece < Piece
end


class Pawn < Piece

  def initialize(current_position, color)
    @symbol = :p
    super
  end

  def move_dirs
    #do later
  end
end
