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
    max_nodes = []
    max_rating = nil
    start = Time.now

    game_state_node.children.each do |child_node|
      child_rating = child_node.rating
      if max_nodes.empty?
        max_nodes << child_node
        max_rating = child_rating
      elsif max_rating < child_rating
        max_nodes = [child_node]
        max_rating = child_rating
      elsif max_rating == child_rating
        max_nodes << child_node
      end
      # puts "computer player possible move: #{child_node.move}"
      # puts "rating of that move: #{child_rating}"
    end

    max_nodes.sample.move
  end


end
