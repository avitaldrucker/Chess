require_relative 'display'

class HumanPlayer
  attr_reader :name, :color, :display

  def initialize(name, color, display)
    @name = name
    @color = color
    @display = display
  end

  def play_turn
    start_pos = prompt_for_pos
    end_pos = prompt_for_pos
    
    [start_pos, end_pos]
  end

  def prompt_for_pos
    pos = nil

    until pos
      display.render(name)
      pos = display.get_input
    end

    pos
  end

  private

  attr_reader :board
end
