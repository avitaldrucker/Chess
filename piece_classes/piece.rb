require_relative '../sliding_piece'
require_relative '../stepping_piece'
require_relative '../board'
require_relative '../errors'

class Piece

  attr_reader :symbol, :color, :opponent_color, :position
  attr_accessor :board, :moved

  def self.find_piece(board, piece_class, options)

    board.each_with_index do |tile, pos|
      row, col = pos
      if tile.is_a?(piece_class) && same?(options[:row], row) &&
        same?(options[:pos], pos) &&
        same?(options[:color], tile.color)
        return tile
      end
    end

    nil
  end

  def self.same?(value, desired_value)
    !value || value == desired_value
  end

  def self.dup(piece)
    return piece if piece.is_a?(NullPiece)
    new_piece = piece.dup
    new_piece.position = piece.position.dup

    new_piece
  end

  def self.validate_piece_move(end_pos, piece, current_color)
    raise NoPieceError.new if piece.is_a?(NullPiece)
    raise WrongColorMoveError.new unless piece.color == current_color
    raise InvalidMoveError.new unless piece.can_move?(end_pos)
    raise MoveChecksKingError.new unless piece.no_check_move?(end_pos)
  end

  def initialize(position = nil, color = nil)
    @position = position
    @color = color
    @opponent_color = color == :white ? :black : :white if color
    @moved = false
  end

  def position=(pos)
    @position = pos
    @moved = true
  end

  def increment_position(position, delta)
    delta_row, delta_col = delta
    pos_row, pos_col = position

    [delta_row + pos_row, delta_col + pos_col]
  end

  def can_move?(end_pos)
    moves.include?(end_pos)
  end

  def move_into_check?(end_pos)
    board_copy = board.dup
    board_copy.move_piece!(position, end_pos)
    board_copy.in_check?(color)
  end

  def no_check_move?(pos)
    valid_moves.include?(pos)
  end

  def pawn_promotion_necessary?
    false
  end

  def valid_moves
    moves.reject { |move| move_into_check?(move) }
  end

  def valid_moves?
    valid_moves.length > 0
  end

  def valid_move?(pos)
    return false unless pos && Board.in_bounds?(pos)
    return false if board[pos].color == self.color

    true
  end

end
