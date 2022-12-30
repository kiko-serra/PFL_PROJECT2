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

    ?- consult('main.pl').

If you're using Windows, you can also do this by selecting `File` -> `Consult...` and selecting the file `main.pl`.
    
Finally, run the the predicate play/0 to enter the game main menu: 

    ?- play.

## Game Description
### Board

This game is played on a NxM board (say 10x10), with a number of red and black stones facing each other on each board edge.

### Gameplay
The players are Black and Red, with Black going first. Each has a supply of stones in their color.

On each turn, a player can take one of the following actions:

- Move any number of cells to the right or left depending on the color of the stone.
- When moving a jumper they can jump over one stone above or below them, landing on the immediate adjacent cell (this is only valid if that cell is empty) , demoting that stone to a slipper (if it was a jumper).

Wins the player that made the last move.

## Game Logic
### Game state internal representation



#### Initial state (10x10)



### Game state visualization



### Move execution


    
### Game Over



### List of valid moves:



### Game state evaluation



### Computer move



## Conclusion

The board game *Dan En Nacht* was successfully implemented in the SicStus Prolog 4.7 language. The game can be played Player vs Player, Player vs Computer or Computer vs Computer (with the same or different levels).

One of the difficulties on the project was displaying an intuitive board in the SicStus terminal, which has a very limited set of characters and customization. This limits the game design, since it's hard to display black/white cells and black/red pieces at the same time. This issue was mitigated by using the characters 'B' and 'R', which isn't ideal.

### Sources

