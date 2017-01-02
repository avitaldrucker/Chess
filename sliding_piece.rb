module SlidingPiece
  DIRECTIONS = {
    up:      [-1,  0],
    down:    [1,   0],
    left:    [0,  -1],
    right:   [0,   1],
    diag_dr: [1,   1],
    diag_ur: [-1,  1],
    diag_dl: [1,  -1],
    diag_ul: [-1, -1]
  }

  def moves
    possible_positions = [@current_position]

    move_dirs.each do |direction|
      new_pos = increment_position(possible_positions.last, direction)
      while valid_move?(new_pos)
        possible_positions << new_pos
        next unless board[new_pos].color == self.color
        new_pos = increment_position(possible_positions.last, direction)
      end
      next
    end

    possible_positions
  end

  def increment_position(position, direction)
    delta_row, delta_col = DIRECTIONS[direction]
    pos_row, pos_col = position
    [delta_row + pos_row, delta_col + pos_col]
  end

  def valid_move?(pos)
    return false unless board.empty?
    return false if color == board[pos].color
    true
  end

end
