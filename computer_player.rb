require_relative './chess_node'
require 'byebug'

class ComputerPlayer

  attr_reader :board, :color

  def initialize(name, color, board)
    @name = name
    @color = color
    @board = board
  end

  def play_turn
    game_state_node = ChessNode.new(self.board, self.color) #0(1)
    max_node = nil
    max_rating = nil
    
    game_state_node.children.each do |child_node|
      child_rating = child_node.rating
      if max_node.nil? || child_rating > max_rating
        max_node = child_node
        max_rating = child_rating
      end
    end

    max_node.move
  end


end
