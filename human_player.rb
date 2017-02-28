require_relative 'display'

class HumanPlayer
  attr_reader :name, :color, :display

  def initialize(name, color, display)
    @name = name
    @color = color
    @display = display
  end

  def play_turn
    start_pos = nil
    end_pos = nil
    while start_pos.nil? && end_pos.nil?
      display.render(name)
      start_pos = display.get_input
    end

    while end_pos.nil?
      display.render(name)
      end_pos = display.get_input
    end

    [start_pos, end_pos]
  end

  private

  attr_reader :board
end
