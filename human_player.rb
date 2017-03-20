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

    display.render(name)
    pos
  end

  def notify_game_end(name)
    display.render
    puts "#{name} wins!"
  end

  def prompt_promote_piece(pos)
    puts "What piece would you like to promote your pawn at #{pos} to?"
    puts "Type Queen, Knight, Rook, or Bishop, and then press enter."
    [gets.chomp.capitalize, pos]
  end

  private

  attr_reader :board
end
