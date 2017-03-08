#Chess#

##How to Run the Game##
1. Clone this repository, or download it as a ZIP.
2. Navigate to the Chess directory where you downloaded the repository.
3. In your terminal, type and enter `ruby game.rb`.

![Screenshot](/docs/chess_screenshot.png)

##Technical Implementation Details##

The game logic makes use of Game, Board, and Display classes, as well as a Piece class. The various chess pieces inherit from Piece.

The game populates empty spots with an instance of NullPiece, which uses the Singleton module and inherits from Piece. Because the game employs the Singleton module, all empty spots are represented by the same instance. Thus, NullPiece instances have the same properties and are in sync. This leads to fewer bugs. Because NullPiece is a subclass of Piece, details about an instance are abstracted away as much as possible when moving a piece or rendering the board.

Functionality for sliding pieces (queens, bishops, and rooks) and stepping pieces (kings and knights) was implemented by including Slideable and Steppable modules respectively in Piece subclasses. By determining valid moves for sliding pieces in the Slideable module and moves for stepping pieces in the Steppable module, I standardized and abstracted away move logic from individual Piece subclasses, minimizing code duplication. Pawn move logic is handled separately in the Pawn class because of pawns' atypical behavior, namely the ability to step two spaces and move diagonally to attack.

The game employs custom error classes to deal with various types of invalid moves, in order to display custom error messages.

The game prevents player moves that would lead to the player being checked by deep-dupping the board and and its pieces, and playing out the player's intended move on the copied board. If the player's move leads to a check, the board will raise an error inheriting from StandardError. The game deals with king-checking moves in this way to ensure the integrity of the board at all times. No illegal moves are ever made on the board, and moves are never undone. While the game could prevent king-checking moves by making a move on the board, evaluating whether the player's king is now in check, and undoing the move if it had led to a check, this would require the board to have functionality for undoing moves. Making a possibly dangerous move on a copy of the board abstracts away invalid moves from the board that is being played on, thus separating concerns.

Moves that lead to a check are calculated as follows in the Piece class:

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

`Board#move_piece!` makes a move without checking whether a move leads to a king being checked, whereas `Board#move_piece`, which actually moves the piece on the played board, does.

###Future Directions for the Project###
- [ ] I plan to implement a frontend for this project through React, with state managed by Redux. This involves reprogramming the game in JavaScript.
- [ ] I also plan to implement a computer AI to play against a player, using a minimax algorithm and tree nodes.
- [ ] Other future features include pawn promotion, castling, en passant, and functionality to check whether a win by any player is possible in the game.
