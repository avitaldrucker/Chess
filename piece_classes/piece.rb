require_relative '../sliding_piece'
require_relative '../stepping_piece'
require_relative '../board'


class Piece



  attr_reader :symbol, :color, :opponent_color
  attr_accessor :board, :current_position

  def initialize(current_position = nil, color = nil)
    @current_position = current_position
    @color = color
    @opponent_color = color == :white ? :black: :white unless color.nil?
  end

  def valid_moves
    moves.reject do |move|
      self.move_into_check?(move)
    end
  end

  def move_into_check?(end_pos)
    board_copy = board.dup
    board_copy.move_piece!(self.current_position, end_pos)
    board_copy.in_check?(color)
  end

  def self.dup(piece)
    position_copy = piece.current_position.dup
    new_piece = piece.dup
    new_piece.current_position = position_copy
    new_piece
  end

  def can_move?(end_pos)
    moves.include?(end_pos)
  end

  def valid_move?(pos)
    return false unless pos
    return false unless Board.in_bounds?(pos)
    return true if board.empty?(pos)
    return false if board[pos].color == self.color
    true
  end

  def increment_position(position, delta)
    delta_row, delta_col = delta
    pos_row, pos_col = position
    [delta_row + pos_row, delta_col + pos_col]
  end

end
