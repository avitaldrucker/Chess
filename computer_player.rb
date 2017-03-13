require_relative './chess_node'

class ComputerPlayer

  attr_reader :board, :color, :display, :name

  def initialize(color, board, display)
    @name = "ChessBot"
    @color = color
    @board = board
    @display = display
  end

  def play_turn
    display.render(name)
    result = best_moves.sample.move
    result
  end

  def best_moves
    max_nodes = nil
    max_rating = nil

    ChessNode.new(board, color).children.each do |node|
      rating = node.rating
      if max_nodes.nil? || max_rating < rating
        max_nodes = [node]
        max_rating = rating
      elsif max_rating == rating
        max_nodes << node
      end
    end

    max_nodes
  end

  def prompt_promote_piece(pos)
    ["Queen", pos]
  end


end
