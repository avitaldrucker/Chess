module SteppingPiece

  def moves
    possible_moves = []

    move_dirs.each do |delta|
      delta_row, delta_col = delta
      current_row, current_col = position
      new_pos = [delta_row + current_row, delta_col + current_col]
      possible_moves << new_pos if valid_move?(new_pos)
    end

    possible_moves
  end

end
