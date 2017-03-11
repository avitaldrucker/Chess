require_relative 'piece_classes/piece'
require_relative 'piece_classes/bishop'
require_relative 'piece_classes/king'
require_relative 'piece_classes/knight'
require_relative 'piece_classes/nullpiece'
require_relative 'piece_classes/pawn'
require_relative 'piece_classes/queen'
require_relative 'piece_classes/rook'
require_relative 'errors'


class Board

  BACKROW_PIECES = [
    Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook
  ]

  ROW_PIECE_COLORS = {
    0 => :black, 1 => :black, 6 => :white, 7 => :white
  }

  PIECES_FROM_INPUT = {
    "Queen" => Queen,
    "Knight" => Knight,
    "Rook" => Rook,
    "Bishop" => Bishop
  }

  def self.empty_grid
    Array.new(8) { Array.new(8) }
  end

  def self.default_grid
    grid = Array.new(8) { Array.new(8) }

    grid.each_with_index do |row, row_idx|
      row.each_with_index do |tile, col_idx|
        pos = [row_idx, col_idx]
          grid[row_idx][col_idx] = self.populate_tile(pos)
      end
    end

    grid
  end

  def pawn_promotion_necessary?(pos)
    self[pos].pawn_promotion_necessary?
  end

  def promote_pawn(piece_input, pos)
    color = self[pos].color

    piece_class = PIECES_FROM_INPUT[piece_input]
    raise WrongPieceInputError.new unless piece_class


    piece = piece_class.new(pos, color)

    self[pos] = piece
    piece.board = self
  end

  def self.populate_tile(pos)
    row, col = pos

    if row == 0 || row == 7
      BACKROW_PIECES[col].new(pos, ROW_PIECE_COLORS[row])
    elsif row == 1 || row == 6
      Pawn.new(pos, ROW_PIECE_COLORS[row])
    else
      NullPiece.instance
    end

  end

  def self.in_bounds?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  attr_reader :grid

  def initialize(grid = Board.default_grid)
    @grid = grid
    pass_board_to_pieces unless grid == Board.empty_grid
  end

  def pass_board_to_pieces
    self.each_with_index { |piece, _| piece.board = self }
  end

  def move_piece(start_pos, end_pos, current_color)
    piece = self[start_pos]

    raise NoPieceError.new if empty?(start_pos)
    validate_correct_color(piece, current_color)
    raise InvalidMoveError.new unless piece.can_move?(end_pos)
    raise MoveChecksKingError.new unless piece.no_check_move?(end_pos)

    self[start_pos] = NullPiece.instance

    piece.current_position = end_pos
    self[end_pos] = piece
  end

  def validate_correct_color(piece, current_color)
    unless pieces_with_color(current_color).include?(piece)
      raise WrongColorMoveError.new
    end
  end

  def move_piece!(start_pos, end_pos)
    piece = self[start_pos]

    raise NoPieceError.new if empty?(start_pos)
    raise InvalidMoveError.new unless piece.can_move?(end_pos)

    piece.current_position = end_pos
    self[start_pos] = NullPiece.instance
    self[end_pos] = piece
    piece.board = self
  end

  def in_check?(color)
    position_of_king = king_position(color)
    offense_color = self[position_of_king].opponent_color

    pieces_with_color(offense_color).any? do |piece|
      piece.can_move?(king_position(color))
    end

  end

  def checkmate?(color)
    in_check?(color) && pieces_with_color(color).none? do |piece|
      piece.valid_moves?
    end
  end

  def king_position(desired_color)
    each_with_index do |piece, pos|
      return pos if piece.is_a?(King) && piece.color == desired_color
    end
  end

  def dup
    new_board = Board.new(Board.empty_grid)

    new_board.each_with_index do |_, pos|
      piece = self[pos]

      new_board[pos] = Piece.dup(piece)
      new_board[pos].board = new_board
    end

    new_board
  end

  def pieces_with_color(kings_color)
    selected_pieces = []

    each_with_index do |piece, _|
      selected_pieces << piece if piece.color == kings_color
    end

    selected_pieces
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    self.grid[row][col] = piece
  end

  def empty?(pos)
    self[pos].is_a?(NullPiece)
  end

  def each_with_index(&prc)

    grid.each_with_index do |row, row_idx|
      row.each_with_index do |_, col_idx|
        prc.call(grid[row_idx][col_idx], [row_idx, col_idx])
      end
    end

  end

end
