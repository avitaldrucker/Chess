require_relative 'piece_classes/piece'
require_relative 'piece_classes/bishop'
require_relative 'piece_classes/king'
require_relative 'piece_classes/knight'
require_relative 'piece_classes/nullpiece'
require_relative 'piece_classes/pawn'
require_relative 'piece_classes/queen'
require_relative 'piece_classes/rook'


class Board

  def self.empty_grid
    Array.new(8) { Array.new(8) }
  end

  def self.default_grid
    grid = Array.new(8) { Array.new(8) }

    grid.each_with_index do |row, row_idx|
      row.each_with_index do |tile, col_idx|
        pos = [row_idx, col_idx]
          grid[row_idx][col_idx] = Board.populate_tile(pos)
      end
    end

    grid
  end

  def self.populate_tile(pos)
    row, col = pos
    row_colors = { 0 => :black, 1 => :black, 6 => :white, 7 => :white }

    if row == 0 || row == 7
      piece_symbol = Piece::ORDERED_PIECES[col]

      case piece_symbol
      when :rook
        Rook.new(pos, row_colors[row])
      when :knight
        Knight.new(pos, row_colors[row])
      when :bishop
        Bishop.new(pos, row_colors[row])
      when :queen
        Queen.new(pos, row_colors[row])
      when :king
        King.new(pos, row_colors[row])
      end
    elsif row == 1 || row == 6
      Pawn.new(pos, row_colors[row])
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
    grid.each do |row|
      row.each do |piece|
        piece.board = self
      end
    end
  end

  def move_piece(start_pos, end_pos, color)
    piece = self[start_pos]


    raise NoPieceError.new if self.empty?(start_pos)

    unless pieces_with_color(color).include?(piece)
      raise WrongColorMoveError.new
    end

    raise InvalidMoveError.new unless piece.can_move?(end_pos)
    raise MoveChecksKingError.new unless piece.valid_moves.include?(end_pos)

    piece.current_position = end_pos
    self[start_pos] = NullPiece.instance
    self[end_pos] = piece
    piece.board = self
  end

  def move_piece!(start_pos, end_pos)
    piece = self[start_pos]

    raise NoPieceError.new if self.empty?(start_pos)
    raise InvalidMoveError.new unless piece.can_move?(end_pos)

    piece.current_position = end_pos
    self[start_pos] = NullPiece.instance
    self[end_pos] = piece
    piece.board = self
  end

  def in_check?(color)
    position_of_king = king_position(color)
    offensive_color = self[position_of_king].opponent_color

    pieces_with_color(offensive_color).any? do |piece|
      piece.can_move?(king_position(color))
    end
  end

  def checkmate?(color)
    in_check?(color) && pieces_with_color(color).all? do |piece|
      piece.valid_moves.empty?
    end
  end

  def king_position(desired_color)
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        if piece.is_a?(King) && piece.color == desired_color
          return [row_idx, col_idx]
        end
      end
    end
    nil
  end

  def dup
    new_board = Board.new(Board.empty_grid)
    new_board.grid.each_with_index do |row, row_idx|
      row.each_with_index do |tile, col_idx|
        pos = [row_idx, col_idx]
        piece = self[pos]
        if piece.is_a?(NullPiece)
          new_board[pos] = piece
        else
          new_board[pos] = Piece.dup(self[pos])
        end
      end
    end
    new_board.pass_board_to_pieces
    new_board
  end

  def pieces_with_color(kings_color)
    selected_pieces = []
    grid.each do |row|
      row.each do |piece|
        selected_pieces << piece if piece.color == kings_color
      end
    end
    selected_pieces
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def empty?(pos)
    self[pos].is_a?(NullPiece)
  end

  def each_with_index(&prc)
    self.grid.each_with_index do |row, row_idx|
      row.each_with_index do |el, col_idx|
        prc.call(self.grid[row_idx][col_idx], [row_idx, col_idx])
      end
    end
  end

end

class NoPieceError < StandardError
  def initialize
    @message = "There is no piece at that position! Select a piece."
    super(@message)
  end
  attr_reader :message
end

class ChessError < StandardError
end

class InvalidMoveError < ChessError
  def initialize
    @message = "This piece can't move that way! Try again."
    super(@message)
  end
  attr_reader :message
end

class MoveChecksKingError < ChessError
  def initialize
    @message = "That move would leave your king in check!"
    super(@message)
  end
  attr_reader :message
end

class WrongColorMoveError < ChessError
  def initialize
    @message = "That's not your piece! You can't move that. Try again."
    super(@message)
  end
  attr_reader :message
end
