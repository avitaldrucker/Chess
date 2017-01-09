class HumanPlayer
  attr_reader :name, :color

  def initialize(name, color, board)
    @name = name
    @color = color
    @board = board
  end

  def play_turn
  end

  private
  attr_reader :board
end
