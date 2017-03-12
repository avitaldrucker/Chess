require_relative 'piece'

class Pawn < Piece

  attr_reader :initial_pos, :attack_deltas, :delta
  attr_accessor :moved_two_spaces

  ATTACK_DELTAS = {
    white: [[-1, -1], [-1, 1]],
    black: [[1, -1], [1, 1]]
  }

  def initialize(position, color)
    super
    @symbol = color == :white ? "♙" : "♟"
    @initial_pos = position

    @attack_deltas = ATTACK_DELTAS[color]
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
    row, col = position
    dirs = []

    return dirs unless fifth_rank?
    new_row = color == :white ? row - 1 : row + 1
    l_col = col - 1
    r_col = col + 1

    dirs << [new_row, l_col] if en_passant_capture?(board[[row, l_col]])
    dirs << [new_row, r_col] if en_passant_capture?(board[[row, r_col]])

    dirs
  end

  def fifth_rank?
    self.color == :white && self.position[0] == 3 ||
    self.color == :black && self.position[0] == 4
  end

  def en_passant_capture?(piece)
    piece.is_a?(Pawn) &&
    piece.moved_two_spaces &&
    self.board.previous_piece == piece.position
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
