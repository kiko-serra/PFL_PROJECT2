# SKI JUMPS
Group G02_09:

Francisco Pimentel Serra - up202007723 (%)
João Paulo Moreira Araújo - up202004293 (%)


# TODO

[ ] - Fix bot. It only seems to fail with slippers (probably change retract_board method?)

[ ] - Clear up code.

[ ] - ...


## Instalattion and Execution

To play the game you first need to have SICStus Prolog 4.7 or a newer version currently installed on your machine plus the folder with the source code. 

Next, on the SICStus interpreter, consult the file *main.pl* located in the source root directory:

```prolog
?- consult('main.pl').
```

If you're using Windows, you can also do this by selecting `File` -> `Consult...` and selecting the file `main.pl`.
    
Finally, run the the predicate play/0 to enter the game main menu: 
```prolog
?- play.
```
## Game Description
### Board

This game is played on a NxM board (say 8x8), with a number of red and black stones facing each other on each board edge.

### Gameplay
The players are Black and Red, with Black going first. Each has a supply of stones in their color.
Jumpers are with capilized letters, Slippers are with lower case letters (i.e R-red jumper. b-black slipper).

On each turn, a player can take one of the following actions:

- Move any number of cells to the right or left depending on the color of the stone.
- When moving a jumper they can jump over one stone above or below them, landing on the immediate adjacent cell (this is only valid if that cell is empty) , demoting that stone to a slipper (if it was a jumper).

Wins the player that made the last move.

This information was taken from the [website](https://www.di.fc.ul.pt/~jpn/gv/skijump.htm) provided in moodle.
## Game Logic
### Game state internal representation



#### Initial state (8x8)



### Game state visualization



### Move execution

The `move(+GameState, +Move, -NewGameState)` predicate takes three arguments: the current game state (represented as a list), a proposed move (also represented as a list), and the resulting new game state after the move has been executed (also represented as a list). 
The function begins by obtaining a list of valid moves that can be made from the current game state by calling the `valid_moves` predicate. It then checks to see if the proposed move is a member of this list by using the `length` and `member` built-in predicates. 
If the proposed move is not valid, the new game state is set to be the same as the current game state. If the proposed move is valid, the function updates the game state to reflect the movement of the piece by calling the `get_piece,` `update_board,` `update_piece_position,` and `update_player` predicates. 
It also removes any pieces that have moved off the board by calling the `off_the_board_pieces` predicate.
### Game Over

The `gameOver(+GameState, -Winner)` predicate takes two arguments: the current game state (represented as a list) and the winner of the game (represented as a variable). 
It calls the `get_all_player_pieces` predicate to get the number of pieces belonging to the current player and the opponent player. It then uses a series of conditional statements to determine the winner of the game based on the number of pieces each player has. If the current player has no pieces and the opponent has at least one piece, the winner is declared to be player 1 (p1). 
If the opponent has no pieces and the current player has at least one piece, the winner is declared to be player 2 (p2). If both players have no pieces, the game is declared a tie. If none of these conditions are met, the function fails.

### List of valid moves:

The `valid_moves(+GameState, -ListOfMoves)` predicate takes two arguments: the current game state (represented as a list) and a list of valid moves. The function calls the `valid_move_forward` predicate to get a list of horizontal moves that can be made from the current game state. 
The `valid_move_forward` predicate, in turn, calls the `findall` and `find_moves` predicates to find all the pieces of a certain color and determine the possible moves that can be made with those pieces. The `valid_moves` predicate then returns this list of moves as its output. 

### Game state evaluation

The `value(+GameState, +Player, -Value)` predicate is a function in Prolog that takes two arguments: the current game state (represented as a list) and a value (represented as a variable). The function calls the `valid_moves` predicate to get the number of valid moves that can be made by the current player and the opponent player. It then calculates the difference between these two values and divides the result by 8. This resulting value is then returned as the output of the `value` predicate. This function is used to determine the value of a given game state in a game that involves moving pieces on a board.

### Computer move



## Conclusion

The board game *Dan En Nacht* was successfully implemented in the SicStus Prolog 4.7 language. The game can be played Player vs Player, Player vs Computer or Computer vs Computer (with the same or different levels).

One of the difficulties on the project was displaying an intuitive board in the SicStus terminal, which has a very limited set of characters and customization. This limits the game design, since it's hard to display black/white cells and black/red pieces at the same time. This issue was mitigated by using the characters 'B' and 'R', which isn't ideal.

### Sources
- https://www.di.fc.ul.pt/~jpn/gv/skijump.htm
- https://annarchive.com/files/Winning%20Ways%20for%20Your%20Mathematical%20Plays%20V1.pdf
