require_relative 'sliding_piece'
require_relative 'stepping_piece'
require_relative 'board'
require 'singleton'


class Piece

  ORDERED_PIECES = [
    :rook, :knight, :bishop, :queen, :king, :bishop, :knight, :rook
  ]

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


class King < Piece
  include SteppingPiece

  def initialize(current_position, color)
    @symbol = color == :white ? "♔" : "♚"
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
    @symbol = color == :white ? "♘" : "♞"
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


class Rook < Piece
  include SlidingPiece

  def initialize(current_position, color)
    @symbol = color == :white ? "♖" : "♜"
    super
  end

  def move_dirs
    [:up, :down, :left, :right]
  end

end


class NullPiece < Piece
  include Singleton

  def initialize
    @symbol = "_"
    super
  end

end


class Pawn < Piece
  attr_reader :initial_row, :attack_deltas, :delta

  def initialize(current_position, color)
    super
    @symbol = color == :white ? "♙" : "♟"
    @initial_row = color == :black ? 1 : 6
    @attack_deltas = color == :black ? [[1, -1], [1, 1]] : [[-1, -1], [-1, 1]]
    @delta = color == :black ? [1, 0] : [-1, 0]
  end

  def moves
    possible_moves = []

    new_pos = increment_position(current_position, delta)

    if valid_move?(new_pos)
      possible_moves << new_pos if board[new_pos].is_a?(NullPiece)

      if current_position.first == initial_row
        possible_moves << two_space_move if valid_move?(two_space_move) && board[two_space_move].is_a?(NullPiece)
      end

    end

    possible_moves.concat(attack_positions) unless attack_positions.empty?

    possible_moves

  end

  def two_space_move
    new_pos = increment_position(current_position, delta)
    increment_position(new_pos, delta)
  end

  def attack_positions
    attack_positions = attack_deltas.map do |delta|
      increment_position(current_position, delta)
    end

    attack_positions.select! do |pos|
      valid_move?(pos) && board[pos].color == opponent_color
    end

    attack_positions
  end

end
