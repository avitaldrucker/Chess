#Chess#

I created this two-player game through Ruby.

##How to Run the Game##
1. Clone this repository, or download it as a ZIP.
2. Navigate to the Chess directory where you downloaded the repository.
3. In your terminal, type and enter 'ruby game.rb'.

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

Board#move_piece! makes a move without checking whether a move leads to a king being checked, whereas Board#move_piece, which actually moves piece on the played board, does.

###Future Directions for the Project###
I am in the process of implementing a frontend for this project through React, with state managed by Redux. The frontend will send AJAX requests to create and update the game, and manage player interaction, while a Rails app will save the game as a YAML string in a database and manage game logic.

I also plan to  implement a computer AI to play against a player, using a minimax algorithm and tree nodes.
