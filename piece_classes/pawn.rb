require_relative 'piece'

class Pawn < Piece

  attr_reader :initial_pos, :attack_deltas, :delta
  attr_accessor :moved_two_spaces

  def initialize(position, color)
    super
    @symbol = color == :white ? "♙" : "♟"
    @initial_pos = position

    if color == :black
      @attack_deltas = [[1, -1], [1, 1]]
    else @attack_deltas = [[-1, -1], [-1, 1]]
    end

    @delta = color == :black ? [1, 0] : [-1, 0]
    @moved_two_spaces = false
  end

  def attack_positions
    attack_positions = attack_deltas.map do |delta|
      increment_position(position, delta)
    end

    attack_positions.select do |pos|
      valid_move?(pos) && board[pos].color == opponent_color
    end

  end

  def moves
    possible_moves = []

    if valid_move?(one_space_move)
      possible_moves << one_space_move
      possible_moves << two_space_move if two_space_move_possible?
    end



    possible_moves + attack_positions + en_passant_directions
  end

  def en_passant_directions
    row, col = self.position
    directions = []

    return directions unless (self.color == :white && row == 3 ||
    self.color == :black && row == 4)
    row_move = self.color == :white ? -1 : 1

    left_piece = self.board[[row, col - 1]]

    previous_piece_moved = self.board.previous_piece

    if left_piece.is_a?(Pawn) && left_piece.moved_two_spaces && previous_piece_moved.position == left_piece.position
      directions << [row + row_move, col - 1]
    end

    right_piece = self.board[[row, col + 1]]

    if right_piece.is_a?(Pawn) && right_piece.moved_two_spaces && previous_piece_moved.position == right_piece.position
      directions << [row + row_move, col + 1]
    end

    directions
  end

  def moved_two_spaces?(start_pos)
    (self.position[0] - start_pos[0]).abs == 2
  end

  def two_space_move_possible?
    position == initial_pos &&
    valid_move?(two_space_move) &&
    board.empty?(two_space_move)
  end

  def one_space_move
    increment_position(position, delta)
  end

  def pawn_promotion_necessary?
    self.color == :white && self.position[0] == 0 ||
    self.color == :black && self.position[0] == 7
  end

  def two_space_move
    new_pos = increment_position(position, delta)
    increment_position(new_pos, delta)
  end

end
