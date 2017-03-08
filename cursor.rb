require "io/console"

KEYMAP = {
  " " => :space,
  "h" => :left,
  "j" => :down,
  "k" => :up,
  "l" => :right,
  "w" => :up,
  "a" => :left,
  "s" => :down,
  "d" => :right,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :board
  attr_accessor :cursor_pos, :start_pos, :end_pos

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board
    @start_pos = nil
    @end_pos = nil
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  private

  def read_char
    STDIN.echo = false

    STDIN.raw!

    input = STDIN.getc.chr

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def handle_key(key)
    case key
    when :return, :space
      if self.start_pos.nil?
        self.start_pos = cursor_pos
      else
        self.end_pos = cursor_pos
        self.start_pos = nil
      end
      cursor_pos
    when :left, :right, :up, :down
      delta_row, delta_col = MOVES[key]
      cursor_row, cursor_col = cursor_pos
      new_pos = [cursor_row + delta_row, cursor_col + delta_col]
      update_pos(MOVES[key]) if Board.in_bounds?(new_pos)
      nil
    when :ctrl_c
      Process.exit(0)
    end
  end

  def update_pos(delta)
    cursor_row, cursor_col = cursor_pos
    delta_row, delta_col = delta
    self.cursor_pos = [cursor_row + delta_row, cursor_col + delta_col]
  end
end
