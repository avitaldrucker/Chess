class ChessError < StandardError
  attr_reader :message
end

class NoPieceError < ChessError
  def initialize
    @message = "There is no piece at that position! Select a piece."
    super(@message)
  end
end

class InvalidMoveError < ChessError
  def initialize
    @message = "This piece can't move that way! Try again."
    super(@message)
  end
end

class MoveChecksKingError < ChessError
  def initialize
    @message = "That move would leave your king in check!"
    super(@message)
  end
end

class WrongColorMoveError < ChessError
  def initialize
    @message = "That's not your piece! You can't move that. Try again."
    super(@message)
  end
end

class WrongPieceInputError < ChessError
  def initialize
    @message = "That is not a valid piece name."
    super(@message)
  end
end
