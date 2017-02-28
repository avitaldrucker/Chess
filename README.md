#Chess#

I created this two-player game through Ruby on the backend and React and Redux on the frontend. Drag and drop pieces to capture the opponent's king.

##Technical Implementation Details##

The game logic makes use of Game, Board, and Display classes, as well as Piece class. The various chess pieces inherit from Piece. I dealt with empty spots by populating them will NullPiece instances, which uses the Singleton module and inherits from Piece. Functionality for sliding pieces such as queens and bishops, and stepping pieces such as kings and knights, was implemented by including Slideable and Steppable modules respectively in Piece subclasses.

I prevent player moves that would lead to the player being checked by deep-dupping the board and and its pieces, and playing out the player's intended move on that copied board. If the player's move leads to a check, the board will raise an error inheriting from StandardError. I also created other custom error classes to deal with various types of error moves, in order to display custom error messages.

Moves that lead to a check are calculating as follows in the Piece class:

```ruby
def valid_moves
  moves.reject { |move| move_into_check?(move) }
end

def move_into_check?(end_pos)
  board_copy = board.dup
  board_copy.move_piece!(current_position, end_pos)
  board_copy.in_check?(color)
end
```

Board#move_piece! makes a move without checking whether a move leads to a king being cheked, wheras Board#move_piece, which actually moves piece on the played board, does.

In the future, I would like to implement a computer AI to play against a player, using a minimax algorithm and tree nodes.
