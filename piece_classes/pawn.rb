require_relative 'piece'

class Pawn < Piece
  attr_reader :initial_pos, :attack_deltas, :delta

  def initialize(current_position, color)
    super
    @symbol = color == :white ? "♙" : "♟"
    @initial_pos = current_position

    if color == :black
      @attack_deltas = [[1, -1], [1, 1]]
    else
      @attack_deltas = [[-1, -1], [-1, 1]]
    end

    @delta = color == :black ? [1, 0] : [-1, 0]
  end

  def moves
    possible_moves = []

    if valid_move?(one_space_move)
      possible_moves << one_space_move

      if  current_position == initial_pos &&
          valid_move?(two_space_move) &&
          board.empty?(two_space_move)
            possible_moves << two_space_move
      end

    end

    possible_moves + attack_positions
  end

  def one_space_move
    increment_position(current_position, delta)
  end

  def two_space_move
    new_pos = increment_position(current_position, delta)
    increment_position(new_pos, delta)
  end

  def attack_positions
    attack_positions = attack_deltas.map do |delta|
      increment_position(current_position, delta)
    end

    attack_positions.select do |pos|
      valid_move?(pos) && board[pos].color == opponent_color
    end

  end

end
