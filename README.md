# SKI JUMPS
Group SkiJumps_5:

| Name                        | UP                                        | Contribuition |
| ------------                | ------------                              |------------   |
| Francisco Pimentel Serra    | [up202007723](mailto:up202007723@fe.up.pt)|50%            |
| João Paulo Moreira Araújo   | [up202004293](mailto:up202004293@fe.up.pt)|50%            |

## Installation and Execution

To play the game you first need to have SICStus Prolog 4.7.1 or a newer version currently installed on your machine plus the folder with the source code. 

Next, on the SICStus interpreter, consult the file ***main.pl*** located in the source root directory:

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

This game is played on a NxM board (say 8x8), with an equal number of red and black stones facing each other on each board edge.

### Gameplay

There are 2 players, `Player 1` is Red and `Player 2` is Black, with Red going first. Each has a supply of stones in their color.
**Jumpers** are capitalized letters, while **Slippers** are lower case letters (`R` stands for a red jumper, while `b` for a black slipper).

On each turn, a player can take one of the following actions:

- If you are the `Player 1` (`Player 2`), you can move one stone any number of cells to the right (left).
- When moving a jumper, they can jump over an opponent stone that stands above or below it, landing on the immediate adjacent cell, if that cell is empty, demoting the jumped stone to a slipper (if it was a jumper).

Wins the player that made the last move.

This information was taken from the [website](https://www.di.fc.ul.pt/~jpn/gv/skijump.htm) provided in moodle and from the volume I of [Winning Ways](https://annarchive.com/files/Winning%20Ways%20for%20Your%20Mathematical%20Plays%20V1.pdf).

## **Game Logic**

### **Game state internal representation**

At any moment in the game, the Gamestate is represented by a list of 2 elements: [Player, Board], where Player is the current player and Board is the current board state.

`Player` is represented by the atom `p1` or `p2`, depending on the current player.
`Board` is represented by a list of 8 lists, each representing a row of the board, and in a row each element is a cell of the row. Each cell is represented by the atom `r` for a red jumper, `b` for a black jumper, `.` for an empty cell, `s_r` for a red slipper and `s_b` for a black slipper.

### **`GameState` troughout one game**
#### **Inicial State**
```prolog
[p1,
    [r,.,.,.,.,.,.,.],
    [.,.,.,.,.,.,.,b],
    [r,.,.,.,.,.,.,.],
    [.,.,.,.,.,.,.,b],
    [r,.,.,.,.,.,.,.],
    [.,.,.,.,.,.,.,b],
    [r,.,.,.,.,.,.,.],
    [.,.,.,.,.,.,.,b]
]
```
#### **Intermediate State**
```prolog
[p2,
    [.,.,.,.,.,.,.,.],
    [.,.,.,.,s_b,.,.,.],
    [r,.,.,.,r,.,.,.],
    [.,.,.,.,.,b,.,.],
    [.,.,.,r,.,.,.,.],
    [.,.,.,.,.,.,.,.],
    [.,.,s_r,.,.,.,.,.],
    [.,.,b,.,.,.,.,.]
]
```
#### **Final State**
```prolog
[p2,
    [.,.,.,.,.,.,.,.],
    [.,.,.,.,.,.,.,.],
    [.,.,.,.,.,.,.,.],
    [.,.,.,.,.,.,.,.],
    [.,.,.,.,.,.,.,.],
    [.,.,.,.,.,.,.,.],
    [.,.,.,.,.,.,.,.],
    [.,.,b,.,.,.,.,.]
]
```

### **Game state visualization**
The game menu is diplayed as such:
```
=======================================================================================================================================
     ________       ___  __        ___                        ___      ___  ___      _____ ______       ________    ________
    |\   ____\     |\  \|\  \     |\  \                      |\  \    |\  \|\  \    |\   _ \  _   \    |\   __  \  |\   ____\     
    \ \  \___|_    \ \  \/  /|_   \ \  \    ____________     \ \  \   \ \  \\\  \   \ \  \\\__\ \  \   \ \  \|\  \ \ \  \___|_    
     \ \_____  \    \ \   ___  \   \ \  \  |\____________\ __ \ \  \   \ \  \\\  \   \ \  \\|__| \  \   \ \   ____\ \ \_____  \   
      \|____|\  \    \ \  \\ \  \   \ \  \ \|____________||\  \\_\  \   \ \  \\\  \   \ \  \    \ \  \   \ \  \___|  \|____|\  \  
        ____\_\  \    \ \__\\ \__\   \ \__\               \ \________\   \ \_______\   \ \__\    \ \__\   \ \__\       ____\_\  \ 
       |\_________\    \|__| \|__|    \|__|                \|________|    \|_______|    \|__|     \|__|    \|__|      |\_________\ 
       \|_________|                                                                                                   \|_________|

         1. Player vs Player

         2. Player vs Computer

         3. Computer vs Computer

         0. Exit

=======================================================================================================================================
```
Once the game starts, the board is displayed as such:
```
-----|---|---|---|---|---|---|---|---|
 <8> | R |   |   |   |   |   |   |   | 
-----|---|---|---|---|---|---|---|---|
 <7> |   |   |   |   |   |   |   | B | 
-----|---|---|---|---|---|---|---|---|
 <6> | R |   |   |   |   |   |   |   | 
-----|---|---|---|---|---|---|---|---|
 <5> |   |   |   |   |   |   |   | B | 
-----|---|---|---|---|---|---|---|---|
 <4> | R |   |   |   |   |   |   |   | 
-----|---|---|---|---|---|---|---|---|
 <3> |   |   |   |   |   |   |   | B | 
-----|---|---|---|---|---|---|---|---|
 <2> | R |   |   |   |   |   |   |   | 
-----|---|---|---|---|---|---|---|---|
 <1> |   |   |   |   |   |   |   | B | 
-----|---|---|---|---|---|---|---|---|
     |<A>|<B>|<C>|<D>|<E>|<F>|<G>|<H>|


    > Player 1 turn to play <
```

The board display predicate, `display_game(+GameState)`. The Red jumpers are represented as `R` and the Black as `B`, the Red slippers are represented as `r` and the Black as `b`.

### **Move execution**

The `move(+GameState, +Move, -NewGameState)` predicate takes three arguments: the current game state, the move to make, and the resulting new game state after the move has been executed. It starts by updating the board with the new move calling the `update_board(+Board, -NewBoard, +Move, -WasSlipper)` predicate:

- Update the position of the stone that was moved both on the board and on the database;
- If the move was a jump, update the piece type of the jumped piece (if it wasn't a slipper already).

Afterwards, it removes (takes off the board) the stones that don't have any valid moves left by calling the `off_the_board_stones(+Board, -NewBoard)` predicate. These stones are on the opponents starting positions and are not able to jump over an adjacent stone. Finally, it updates the new game state with the next player to make a move.

### **Game Over**

The `gameOver(+GameState, -Winner)` predicate takes two arguments: the current game state (represented as a list) and the winner of the game (represented as a variable).
It calls the `get_all_player_stones` predicate to get the number of stones belonging to the current player and the opponent player. This number is calculated by the adding the lenght of the two resulting list of stones (jumpers and slippers) that each player has. 
Then uses a series of conditional statements to determine the winner of the game based on the number of stones each player has. 
- If the current player has no stones and the opponent has at least one stone, the winner is declared to be player 1 (p1).
- If the opponent has no stones and the current player has at least one stone, the winner is declared to be player 2 (p2).
- If none of these conditions are met, the function fails.

### **List of valid moves**

The `valid_moves(+GameState, -ListOfMoves)` predicate takes two arguments: the current game state and a list of valid moves. The function is defined twice, once for each player (p1 and p2).

For player p1, the function begins by calling the `findall` predicate to find all the red stones on the board (represented as a list of column-row pairs). It then calls the `find_moves` predicate to determine the possible moves (jump up, jump down and move sideways) that can be made with the jumpers, and it assigns the resulting list of moves to the `List1` variable. 
Next, it calls `findall` again to find all the slipper stones belonging to player p1 and calls the `find_normal_move` predicate to determine the possible moves (sideways) that can be made with the slippers. It assigns the resulting list of moves to the `List2` variable. 
The function then uses the `append` predicate to concatenate these two lists of moves into a single list, which is stored in the `List3` variable. 
Finally, it calls the `remove_duplicates` predicate to remove any duplicate moves from this list, and it assigns the resulting list to the `ListOfMoves` variable, which is returned as the output of the predicate.

For player p2, the function follows a similar process, but it uses the `findall` predicate to find all the black stones (jumpers and slippers) belonging to player p2, and it determines the possible moves that can be made with these stones.
The resulting list of moves is then concatenated and de-duplicated in the same way as for player p1.

### **Game state evaluation**

The `value(+GameState, -Value)` predicate takes two arguments: the current game state (represented as a list) and a value (represented as a variable).
The function calls the `valid_moves` predicate to get the number of valid moves that can be made by the current player and the opponent player. It then calculates the difference between these two values and divides the result by 8.
This resulting value is then returned as the output of the `value` predicate.

### **Computer move**

The `choose_move(+GameState, +Level, -Move)` predicate takes three arguments, the current game state (represented as a list) that also contains the next player to make a move, the level of difficulty of that player and the Move that it will make (this is represented as a list just such as `[X1,Y1,X2,Y2]`, being `*1` the stone origin and `*2` the stone destination cell).
The level of difficulty can take one of the following values:

- **1** if it is an easy difficulty computer. Chooses randomly a move from the list of valid moves using the library `random` to choose an index of that list (with the predicates `random_index` and `nth0`);
- **2** if it is an hard difficulty computer. Uses the predicate `greedy_evaluation` that goes recursively through every move in the list of moves and retrieve the one that has the biggest value for the computer, by simmulating all moves possible.

`greedy_evaluation(+GameState, +ListOfMoves, -BestMove, -BestValue)` predicate takes four arguments: the current game state (represented as a list), a list of moves, the best move (represented as a variable), and the best value (represented as a variable). The function is defined twice, once for the case where the list of moves has a single element and once for the case where it has more than one element.

For the case where the list of moves has a single move, the function calls the `simulate_move` predicate to determine the value of making this move from the current game state. It then assigns this value to the `BestValue` variable and the move to the `BestMove` variable, which are returned as the output of the predicate.

For the case where the list of moves has more than one move, the function calls the `simulate_move` predicate to determine the value of making the first move in the list. It then calls itself recursively (using the `greedy_evaluation` predicate) to determine the best move and value from the remaining moves in the list.
Finally, it compares the value of the first move to the value of the best move from the remaining moves.
- If the value of the first move is greater, it assigns this move and value to the `BestMove` and `BestValue` variables.
- If the value of the first move is not greater, it assigns the best move and value from the remaining moves to these variables.

This process continues until all the moves in the list have been evaluated, and the final result is returned as the output of the predicate.

### **Human move**

The player uses the same predicate `choose_move(+GameState, +Level, -Move)` to get the move he is about to make only if the *`Level`* is **0**. He is prompted to write a move with the predicate `get_move(-Move, +ListOfMoves)`. This last predicate also allows the user to ask for help (with the input `help.`), which shows all the available moves he can make at that time.

## **Conclusion**

The board game *Ski Jumps* was successfully implemented in the SicStus Prolog 4.7.1 language. The game can be played Player vs Player, Player vs Computer or Computer vs Computer (with the same or different levels).

One of the difficulties on the project was displaying an intuitive board in the SicStus terminal, which has a very limited set of characters and customization. This limits the game design, since it's hard to display black/white cells and black/red stones at the same time.

Also, we would've liked to have further time to develop the game and add the possibility for the user to choose the board dimensions.

Regardless, the development of *Ski Jumps* was crucial for the deepening of our knowledge on the Prolog language, and we may have ended up understanding the need for such a language in our paths as computer engineers.

### **Sources**

- [Game Rules](https://www.di.fc.ul.pt/~jpn/gv/skijump.htm)
- [Book](https://annarchive.com/files/Winning%20Ways%20for%20Your%20Mathematical%20Plays%20V1.pdf)
