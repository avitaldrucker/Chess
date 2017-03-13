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

###AI###

This game offers the option to play against a computer AI. The game implements a computer AI through the minimax algorithm and through creating a tree based off of the available moves for the computer's pieces. The game assumes that for any node in the tree, the computer player will play to maximize its advantage, and the human player will play to maximize his/her advantage. These assumptions allow the computer player to play as well as it can and guard itself against attacks by the human player.

For each a computer player's piece can take, a node is created. The game dups the board and executes this move on that board. It then looks at the children of the current node, and creates child nodes that reflect the human player's moves. The tree of hypothetical game states has a height of three: the current game state is the root node, the first-tier children are possible moves by the computer player, and the third tier-children are the human player's hypothetical responses.

The computer player decides which move to implement by selecting the node in the first-tier of the tree that has the highest ranking. Ranking is calculated through the difference in points between the computer player and the human player; points are calculated by the number of pieces each player has. Pieces are weighted by their value: a pawn is worth one point, and a king is worth 100 points. The game recurses through the nodes, assigning to each node the highest ranking of the node's children.

Below are some of the instance methods of the `ChessNode` class that are relevant to ranking nodes:

```ruby
def rating(depth = 0)
  return checkmate_rating if checkmate_rating

  if depth >= 1
    return pieces_sum(toggle_mark) - pieces_sum(next_mover_color)
  end

  max_children_rating(depth) * -1
end

def max_children_rating(depth)
  max_node = nil
  max_rating = nil

  children.each do |node|
    node_rating = node.rating(depth + 1)
    if max_node.nil? || max_rating < node_rating
      max_node = node
      max_rating = node_rating
    end
  end

  max_rating
end
```

###More Complex Moves###
The `Board` and relevant `Piece` classes work together to implement more complex chess moves, ensuring separation of concerns: the Piece class handles the details of validating and providing the move, and the Board executes the move.

####Pawn Promotion####
This game implements pawn promotion through an instance method in the `Pawn` class that checks whether pawn promotion is necessary - in other words, whether a pawn is on its eight rank on the board. If so, the game will prompt the player to select a piece to transform the pawn into. The board is updated with that piece.

####Castling####
The `Board` and `King` classes are responsible for castling functionality. The King provides as a valid move two spaces left or right, if the conditions specified by the `King#castling_possible?` method are fulfilled. If a player chooses to castle, the Board will ensure that the castling is permissible, and will move the king and update the rook accordingly, depending on the direction of the castling.

####En Passant####
En passant is implemented in the `Pawn` class. `Pawn#moves` includes results of `Pawn#en_passant_directions`. This method returns end positions on the board corresponding to en passant moves if the conditions specified by `Pawn#en_passant_capture?` are fulfilled. The board checks whether a move is en passant in its `Board#move_piece` method by calling the helper method `Board#check_if_en_passant`. If the move is en passant, the board will move the offensive piece properly and remove the captured pawn from the board.

###Future Directions for the Project###
- [ ] Functionality to check stalemate
- [ ] Frontend through React, with state managed by Redux. This involves reprogramming the game in JavaScript.
- [ ] An AI that can strategize more steps ahead and more quickly checkmate.
- [X] Pawn promotion, castling, and en passant
- [X] Computer AI
