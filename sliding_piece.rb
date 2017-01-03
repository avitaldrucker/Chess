require 'byebug'

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
    possible_positions = []

    move_dirs.each do |direction|
      new_pos = increment_position(current_position, DIRECTIONS[direction])

      while valid_move?(new_pos)
        possible_positions << new_pos
        break if board[new_pos].color == opponent_color
        delta = DIRECTIONS[direction]
        new_pos = increment_position(new_pos, delta)
      end

    end
    possible_positions
  end



end
