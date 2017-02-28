require_relative 'piece'

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
