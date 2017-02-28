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
    positions = []

    move_dirs.each do |direction|
      delta = DIRECTIONS[direction]
      positions.concat(positions_in_direction(delta))
    end

    positions
  end

  def positions_in_direction(delta)
    positions = []

    new_pos = increment_position(current_position, delta)

    while valid_move?(new_pos)
      positions << new_pos
      break if board[new_pos].color == opponent_color
      new_pos = increment_position(new_pos, delta)
    end

    positions
  end

end
