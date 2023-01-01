%%%%%%% TODO, pedir ao user se quer ver os movimentos válidos (pedir input 'help'.)

%     MAIN MENU         % 

% main_menu/0
% Calls every predicate related to the Main Menu
main_menu :-
      clear_data,
      print_main_menu,
      read(Input),
      manage_option(Input).

% clear_data/0
% Clears all the data from the database in use by Ski Jumps
clear_data :-
      abolish(size/1),
      abolish(player/1),
      abolish(red/2),
      abolish(slipper_red/2),
      abolish(black/2),
      abolish(slipper_black/2).

% print_main_menu/0
% Prints the Main Menu art style and options for the player to choose from
print_main_menu :- % TODO Edit Art Style later on to be readable on SICStus 4.7.1
      nl,nl,
      write('======================================================================================================================================='),nl,nl,
      write('     ________       ___  __        ___                        ___      ___  ___      _____ ______       ________    ________'),nl,      
      write('    |\\   ____\\     |\\  \\|\\  \\     |\\  \\                      |\\  \\    |\\  \\|\\  \\    |\\   _ \\  _   \\    |\\   __  \\  |\\   ____\\     '),nl,
      write('    \\ \\  \\___|_    \\ \\  \\/  /|_   \\ \\  \\    ____________     \\ \\  \\   \\ \\  \\\\\\  \\   \\ \\  \\\\\\__\\ \\  \\   \\ \\  \\|\\  \\ \\ \\  \\___|_    '),nl,
      write('     \\ \\_____  \\    \\ \\   ___  \\   \\ \\  \\  |\\____________\\ __ \\ \\  \\   \\ \\  \\\\\\  \\   \\ \\  \\\\|__| \\  \\   \\ \\   ____\\ \\ \\_____  \\   '),nl,
      write('      \\|____|\\  \\    \\ \\  \\\\ \\  \\   \\ \\  \\ \\|____________||\\  \\\\_\\  \\   \\ \\  \\\\\\  \\   \\ \\  \\    \\ \\  \\   \\ \\  \\___|  \\|____|\\  \\  '),nl,
      write('        ____\\_\\  \\    \\ \\__\\\\ \\__\\   \\ \\__\\               \\ \\________\\   \\ \\_______\\   \\ \\__\\    \\ \\__\\   \\ \\__\\       ____\\_\\  \\ '),nl,
      write('       |\\_________\\    \\|__| \\|__|    \\|__|                \\|________|    \\|_______|    \\|__|     \\|__|    \\|__|      |\\_________\\ '),nl,
      write('       \\|_________|                                                                                                   \\|_________|' ),nl,nl,
      write('         1. Player vs Player'),nl,nl,
      write('         2. Player vs Computer'),nl,nl,
      write('         3. Computer vs Computer'),nl,nl,
      write('         0. Exit'),nl,nl,
      write('======================================================================================================================================='),nl,nl,nl,
      write('> Insert your option\n --> ').

% Manage the option selected by the player and act upon it 
% Start a Player versus Player game
% manage_option(+Option)
manage_option(1) :-
      manage_side(1),
      manage_side(2),
      play_game(0),
      main_menu.

% Start a Player versus Computer game, choosing sides and level of difficulty of the computer
manage_option(2) :-
      side,
      level(Level),
      play_game(Level),
      main_menu.

% Start a Computer versus Computer game, choosing the level of difficulty of each computer
manage_option(3) :-
      nl,write('> Player 1'),nl, level(P1Level),
      nl,write('> Player 2'),nl, level(P2Level),
      levels(P1Level, P2Level, Level),
      play_game(Level),
      main_menu.

% Close the game
manage_option(0) :-
      write('\nExiting. Thank you for playing Ski Jumps\n\n').

% Output an error message upon unwanted input and retry
manage_option(_Other) :-
      write('\nERROR: that option does not exist.\n\n'),
      askOption,
      read(Input),
      manage_option(Input).

% Insert into the database that Player 1 is human
%manage_side(+Side)
manage_side(1) :-
      assertz(player(p1)).

% Insert into the database that Player 2 is human
manage_side(2) :-
      assertz(player(p2)).

% Choose the pieces the human wants to play with; Repeat if input not wanted
% side/0
side :-
      repeat,
      write('What side you wish to play?'),nl,
      write('1. Red side.'),nl,
      write('2. Black side.'),nl,
      read(Side),
      (   
            manage_side(Side)
      ;   write('\nERROR: that option does not exist.\n\n'),
            fail
      ).

% Reads the level of difficulty for the computer to be
% level(-Level)
level(Level) :-
      repeat,
      write('What difficulty do you wish the computer to be?'),nl,
      write('1. Easy.'),nl,
      write('2. Hard.'),nl,
      read(Level),
      (   
            manage_level(Level)
      ;   write('\nERROR: that option does not exist.\n\n'),
            fail
      ).

% Assure the level of difficulty of the computer is 1 (Easy)
% manage_level(+Level)
manage_level(1).

% Assure the level of difficulty of the computer is 2 (Hard)
manage_level(2).

% Rewrite difficulty of the computers into a two digit number for easier comprehension
% levels(+L1,+L2,-Level)
levels(1,1,11).
levels(2,1,21).
levels(1,2,12).
levels(2,2,22).

%%%%%%%%%%%%%%%%%%%%%%%%%

%     BOARD             %

% initial_state(+Size, -GameState)
% Builds the initial state of a 8 by 8 board and saves it into *GameState*
% Asserts into the database every red and black piece of the initial board, and the size of the board
initial_state(Size, GameState) :-
      GameState = [p1,
            [r,.,.,.,.,.,.,.],
            [.,.,.,.,.,.,.,b],
            [r,.,.,.,.,.,.,.],
            [.,.,.,.,.,.,.,b],
            [r,.,.,.,.,.,.,.],
            [.,.,.,.,.,.,.,b],
            [r,.,.,.,.,.,.,.],
            [.,.,.,.,.,.,.,b]
      ],
      assertz(size(Size)),
      assertz(red(0,0)),
      assertz(red(0,2)),
      assertz(red(0,4)),
      assertz(red(0,6)),
      assertz(black(7,1)),
      assertz(black(7,3)),
      assertz(black(7,5)),
      assertz(black(7,7)),
      assertz(slipper_red(9,9)), % TODO see if it can be changed
      assertz(slipper_black(9,9)),
      retract(slipper_red(9,9)),
      retract(slipper_black(9,9)).

% display_game(+GameState)
% Displays the current status of the board and who is going to play next
display_game([Player|Board]) :-
    nl,
    write('-----|---|---|---|---|---|---|---|---|'),nl,
    size(Size),
    print_matrix(Board, Size),
    write('     |<A>|<B>|<C>|<D>|<E>|<F>|<G>|<H>|\n'),nl,nl,
    write('    > Player '),
    symbol(Player, Symbol), write(Symbol),
    write(' turn to play <'),nl,nl.

% print_matrix(+Matrix, +RemainingLines)
% Displays each line of the Matrix recursively
print_matrix([], 0).
print_matrix([Line|RestOfMatrix], RemainingLines) :-
    write(' <'),
    write(RemainingLines),
    write('> | '),
    print_line(Line),
    write('\n-----|---|---|---|---|---|---|---|---|\n'),
    NewRemaining is RemainingLines - 1,
    print_matrix(RestOfMatrix, NewRemaining).

% print_line(+Line)
% Displays each element of the line recursively
print_line([]).
print_line([CurrentElement|RestOfLine]) :-
    symbol(CurrentElement, Symbol),
    write(Symbol),
    write(' | '),
    print_line(RestOfLine).

% symbol(+Element, -Symbol)
% Translates the constant into a symbol to be used on the output
symbol(p1, S) :- S='1'.       % Player 1
symbol(p2, S) :- S='2'.       % Player 2
symbol(., S) :- S=' '.        % Empty field on the board
symbol(r, S) :- S='R'.        % Red Jumper Piece
symbol(b, S) :- S='B'.        % Black Jumper Piece
symbol(s_r, S) :- S='r'.      % Red Slipper Piece
symbol(s_b, S) :- S='b'.      % Black Slipper Piece

%%%%%%%%%%%%%%%%%%%%%%%%%

%     GAME LOGIC        % 

% Predicate to start a game
% The *Level* indicates what type of game it is and, if it is dealing with a computer, the level of difficulty he is configured to play
% play_game(+Level)
play_game(Level) :-
      initial_state(8, GameState),
      display_game(GameState),
      game_cycle(GameState, Level).

% game_cycle(+GameState, +Level)
% If on the current cycle of the game there is a winner, it congratulates the winner and the game Ends
game_cycle(GameState, _Level):-
      game_over(GameState, Winner), !,
      congratulate(Winner).

% Normal cycle that the game follows. Gets the difficulty of the current player (if it is a computer)
% And gets to choose a move to make. After the move, the cycle resumes.
game_cycle(GameState, Level):-
      level_current_player(GameState, Level, PlayerLevel),
      choose_move(GameState, PlayerLevel, Move),
      move(GameState, Move, NewGameState),
      display_game(NewGameState), !,
      game_cycle(NewGameState, Level).



% congratulate(+Winner)
% Unless there is a tie, congratulates the winner player
congratulate(tie) :-
      write('The game ended in a tie!').

congratulate(Winner) :-
      write('Congratulations Player'), symbol(Winner, S), write(S), write(', you won!'),nl.



%%%%%%%%%%%%%%%%%%%%%%%%%


