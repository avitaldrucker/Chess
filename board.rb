require_relative 'piece_classes/piece'
require_relative 'piece_classes/bishop'
require_relative 'piece_classes/king'
require_relative 'piece_classes/knight'
require_relative 'piece_classes/nullpiece'
require_relative 'piece_classes/pawn'
require_relative 'piece_classes/queen'
require_relative 'piece_classes/rook'

class Board

  attr_reader :grid

  BACKROW_PIECES =
    [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

  ROW_COLORS =
    { 0 => :black, 1 => :black, 6 => :white, 7 => :white }

  PIECES_FROM_INPUT =
    { "Queen" => Queen, "Knight" => Knight,
      "Rook" => Rook, "Bishop" => Bishop }

  def self.default_grid
    grid = empty_grid
    grid.each_with_index do |row, row_i|
      row.each_with_index do |tile, col_i|
        grid[row_i][col_i] = fill_tile(row_i, col_i)
      end
    end
  end

  def self.empty_grid
    Array.new(8) { Array.new(8) }
  end

  def self.in_bounds?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def self.fill_tile(row, col)
    if row == 0 || row == 7
      BACKROW_PIECES[col].new([row, col], ROW_COLORS[row])
    elsif row == 1 || row == 6
      Pawn.new([row, col], ROW_COLORS[row])
    else NullPiece.instance
    end
  end

  def initialize(grid = Board.default_grid)
    @grid = grid
    pass_board_to_pieces unless grid == Board.empty_grid
  end

  def change_piece_pos(start_pos, end_pos)
    piece = self[start_pos]
    self[start_pos] = NullPiece.instance
    piece.position = end_pos
    self[end_pos] = piece
    piece.moved = true
  end

  def checkmate?(color)
    in_check?(color) && pieces_colored(color).none? do |piece|
      piece.valid_moves?
    end
  end

  def dup
    new_board = Board.new(Board.empty_grid)

    new_board.each_with_index do |_, pos|
      new_board[pos] = Piece.dup(self[pos])
      new_board[pos].board = new_board
    end

    new_board
  end

  def each_with_index
    grid.each_with_index do |row, row_i|
      row.each_with_index { |tile, col_i| yield(tile, [row_i, col_i]) }
    end
  end

  def empty?(pos)
    if pos.is_a?(Array)
      self[pos].is_a?(NullPiece)
    else grid[pos].all? { |tile| tile.is_a?(NullPiece) }
    end
  end

  def in_check?(color)
    king = Piece.find_piece(self, King, { color: color })

    pieces_colored(king.opponent_color).any? do |piece|
      piece.can_move?(king.position)
    end
  end

  def move_piece(start_pos, end_pos, current_color)
    Piece.validate_piece_move(end_pos, self[start_pos], current_color)
    change_piece_pos(start_pos, end_pos)

    if self[end_pos].is_a?(King) && ((start_pos[1] - end_pos[1]).abs == 2)
      end_pos[1] - start_pos[1] > 0 ? dir = :right : dir = :left
      if dir == :right
        range = (7..7)
        rook_end_pos = [end_pos[0], end_pos[1] - 1]
      else
        range = (0..0)
        rook_end_pos = [end_pos[0], end_pos[1] + 1]
      end
      rook_to_move = Piece.find_piece(self, Rook, { row: end_pos[0], col_range: range })
      change_piece_pos(rook_to_move.position, rook_end_pos)
    end
  end

  def move_piece!(start_pos, end_pos)
    change_piece_pos(start_pos, end_pos)
  end

  def pass_board_to_pieces
    each_with_index { |piece, _| piece.board = self }
  end

  def pawn_promotion_necessary?(pos)
    self[pos].pawn_promotion_necessary?
  end

  def pieces_colored(color)
    pieces = []

    grid.each do |row|
      row.each { |tile| pieces << tile if tile.color == color }
    end

    pieces
  end

  def promote_pawn(piece_input, pos)
    if self[pos].pawn_promotion_necessary?
      piece_class = PIECES_FROM_INPUT[piece_input]
      raise WrongPieceInputError.new unless piece_class

      piece = piece_class.new(pos, self[pos].color)

      self[pos] = piece
      piece.board = self
    end
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    grid[row][col] = piece
  end

end
