%%%%%%% TODO, pedir ao user se quer ver os movimentos válidos (pedir input 'help'.)
%%%%%%% TODO, adicionar um menu de instruções
%%%%%%% TODO, mudar a forma como escreve o move para uma forma legível
%%%%%%% TODO, simulate_move ainda morre no jump!!!
%%%%%%% TODO, encontrar bug no valid moves

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
      clear_data,
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
      level_current_player(GameState, Level, Difficulty),
      choose_move(GameState, Difficulty, Move),
      move(GameState, Move, NewGameState),
      display_game(NewGameState), !,
      game_cycle(NewGameState, Level).

% game_over(+GameState, -Winner)
% Counts the number of pieces on the board for each player.
% If both players still have pieces, it fails, otherwise it determines the winner.
% If there are no remaining pieces on the board for both players, it ends in a tie.
game_over([Player|_Board], Winner) :-
      get_all_player_pieces(Player, C1),
      other_player(Player, Opponent),
      get_all_player_pieces(Opponent, C2),
      (
            C1 =:= 0, C2 > 0
      ->    Winner = Player
      ;     (
                 C2 =:= 0, C1 > 0 
            ->    Winner = Opponent
            ;     (
                  C1 =:= 0, C2 =:= 0
                  -> Winner = tie
                  ; fail
                  )
            )
      ).

% get_all_player_pieces(+Player, -Length)
% Get all the *Player* pieces on the board and outputs the amount
get_all_player_pieces(p1, Length) :-
      findall(C1-R1, red(C1,R1), Jumpers),
      findall(C2-R2, slipper_red(C2,R2), Slippers),
      append(Jumpers, Slippers, List),
      length(List, Length).
  
get_all_player_pieces(p2, Length) :-
      findall(C1-R1, black(C1,R1), Blacks),
      findall(C2-R2, slipper_black(C2,R2), SBlacks),
      append(Blacks, SBlacks, List),
      length(List, Length).

% congratulate(+Winner)
% Unless there is a tie, congratulates the player that won
congratulate(tie) :-
      write('The game ended in a tie!').

congratulate(Winner) :-
      write('Congratulations Player'), symbol(Winner, S), write(S), write(', you won!'),nl.

% level_current_player(+GameState, +Level, -Difficulty)
% Determines the level of difficulty of the player to make the move
% If the *Difficulty* is 0, it represents the human is going to play
% If the *Difficulty* is 1 (2), the difficulty of the computer that is going to make a move is easy (hard).
% Corresponds to a Player versus Player game
level_current_player(_, 0, Difficulty) :-
      Difficulty = 0.

% Corresponds to a Player versus Computer game
% Determines if the current player is a human or a computer on a easy difficulty
% If there is an instance of *player(Player)* on the database, the next move is for the human 
level_current_player([Player|_Board], 1, Difficulty) :-
      (     player(X),
            X == Player
      ->    Difficulty = 0 
      ;     Difficulty = 1
      ).

% Corresponds to a Player versus Computer game
% Determines if the current player is a human or a computer on a hard difficulty 
% If there is an instance of *player(Player)* on the database, the next move is for the human
level_current_player([Player|_Board], 2, Difficulty) :-
      (     player(X),
            X == Player
      ->    Difficulty = 0 
      ;     Difficulty = 2
      ).

% Corresponds to a Computer versus Computer game
% Both computers are on a easy difficulty
level_current_player(_, 11, Difficulty) :-
      Difficulty = 1.

% Corresponds to a Computer versus Computer game
% Both computers are on a hard difficulty
level_current_player(_, 22, Difficulty) :-
      Difficulty = 2.

% Corresponds to a Computer versus Computer game
% If the next move is for the Player 1, then the difficulty is easy
level_current_player([p1|_Board], 12, Difficulty) :-
      Difficulty = 1.

% Corresponds to a Computer versus Computer game
% If the next move is for the Player 2, then the difficulty is hard
level_current_player([p2|_Board], 12, Difficulty) :-
      Difficulty = 2.

% Corresponds to a Computer versus Computer game
% If the next move is for the Player 1, then the difficulty is hard
level_current_player([p1|_Board], 21, Difficulty) :-
      Difficulty = 2.

% Corresponds to a Computer versus Computer game
% If the next move is for the Player 1, then the difficulty is easy
level_current_player([p2|_Board], 21, Difficulty) :-
      Difficulty = 1.

% choose_move(+GameState, +Difficulty, -Move)
% Gets the next move to be taken by the current Player
% If the difficulty is 0, the player is a human and has to manually select the move
choose_move([Player|Board], 0, Move):-
      repeat,
      write(' > Choose skier. ---> '),
      get_move(Move),
      (     check_move([Player|Board], Move)
      ->    write('Move: '), write(Move)
      ;     write('Invalid move. Please try again.'), nl, fail
      ).

% If the difficulty is 1, the player is a computer on a easy difficulty and selects a random move from the valid moves available
choose_move([Player|Board], 1, Move):-
      write(' > Choose skier. ---> '),
      valid_moves([Player|Board], ListOfMoves),
      write(ListOfMoves),nl,
      random_index(Index, ListOfMoves),
      nth0(Index, ListOfMoves, Move),
      write('Move: '), write(Move), nl.

% If the difficulty is 2, the player is a computer on a hard difficulty and selects the move that will give the best evaluation after playing it
% It follows a greedy evaluation 
choose_move([Player|Board], 2, Move):-
      write(' > Choose skier. ---> '),
      valid_moves([Player|Board], ListOfMoves),
      greedy_evaluation([Player|Board], ListOfMoves, Move, Value),
      write('Move: '), write(Move), nl,
      write('Best Value: '), write(Value), nl.

% check_move(+GameState, +Move)
% Verifies if the move inserted by the human player contains in the list of valid moves
check_move([Player|Board], Move) :- % TODO mudar para valid moves
      valid_moves([Player|Board], ListOfMoves),
      member(Move, ListOfMoves).

% move(+GameState, +Move, -NewGameState)
% Makes the move and updates the state of the game
move([Player|Board], [X1,Y1,X2,Y2], [NewPlayer|NewBoard]) :-
      update_board(Board, NewBoard, [X1,Y1,X2,Y2], _),
      other_player(Player, NewPlayer).


% valid_moves(+GameState, -ListOfMoves)
% Get the available pieces for the player and retrieve a list with all the valid moves
valid_moves([p1|_Board], ListOfMoves) :-
      findall(Column1-Row1, red(Column1,Row1), Jumpers),
      findall(Column2-Row2, slipper_red(Column2,Row2), Slippers),
      append(Jumpers, Slippers, List),
      find_moves(List, p1, ListOfMoves).

valid_moves([p2|_Board], ListOfMoves) :-
      findall(Column1-Row1, black(Column1,Row1), Jumpers),
      findall(Column2-Row2, slipper_black(Column2,Row2), Slippers),
      append(Jumpers, Slippers, List),
      find_moves(List, p2, ListOfMoves).

% find_moves(+Pieces, +Player, -ListOfMoves)
% Retrieves a list with the valid moves for the given pieces
find_moves(Pieces, Player, ListOfMoves) :-
      find_normal_move(Pieces, Player, List1),
      find_upwards_jumps(Pieces, Player, List2),
      find_downwards_jumps(Pieces, Player, List3),
      append(List1, List2, List3, List4),
      remove_duplicates(List4, ListOfMoves).

% find_normal_move(+Pieces, +Player, -ListOfMoves)
% Retrieves a list with all the valid normal moves for the given pieces
find_normal_move(Pieces, Player, ListOfMoves) :-
      findall(
            Move,
            (
                  member(Col-Row, Pieces),
                  piece_moves(Col, Row, Player, Col, List),
                  member(Move, List)
            ),
            ListOfMoves
      ).

% find_upwards_jumps(+Pieces, +Player, -ListOfMoves)
% Retrieves a list with all the valid upward jumps for the given pieces
find_upwards_jumps(Pieces, Player, ListOfMoves) :-
      findall(
            JumpUp,
            (
                  member(Col-Row, Pieces),
                  piece_jumps_upwards(Col, Row, Player, Row, List),
                  member(JumpUp, List)
            ),
            ListOfMoves
      ).

% find_downwards_jumps(+Pieces, +Player, -ListOfMoves)
% Retrieves a list with all the valid downward jumps for the given pieces
find_downwards_jumps(Pieces, Player, ListOfMoves) :-
      findall(
            JumpDown,
            (
                  member(Col-Row, Pieces),
                  piece_jumps_downwards(Col, Row, Player, Row, List),
                  member(JumpDown, List)
            ),
            ListOfMoves
      ).

% piece_moves(+Column, +Row, +Player, +TargetColumn, -List )
% Get recursively a list with the valid normal moves a certain piece has
piece_moves(Column, Row, p1, TargetColumn, List) :-
      (     
            TargetColumn < 7,
            NextTargetColumn is TargetColumn + 1,
            \+ red(NextTargetColumn,Row), \+ slipper_red(NextTargetColumn,Row),
            piece_moves(Column, Row, p1, NextTargetColumn, Tail),
            Move = [Column, Row, NextTargetColumn, Row],
            append([Move], Tail, List)
      ;     List = []
      ).

piece_moves(Column, Row, p2, TargetColumn, List) :-
      (     
            TargetColumn > 0,
            NextTargetColumn is TargetColumn - 1,
            \+ black(NextTargetColumn,Row), \+ slipper_black(NextTargetColumn,Row),
            piece_moves(Column, Row, p2, NextTargetColumn, Tail),
            Move = [Column, Row, NextTargetColumn, Row],
            append([Move], Tail, List)
      ;     List = []
      ).

% piece_jumps_upwards(+Column, +Row, +Player, +TargetRow, -List )
% Get recursively a list with the valid upward jumps a certain piece has
piece_jumps_upwards(Column, Row, p1, TargetRow, List) :-
      (     
            TargetRow < 6,
            TargetRow1 is TargetRow + 1, TargetRow2 is TargetRow + 2,
            (black(Column, TargetRow1); slipper_black(Column, TargetRow2)), \+ red(Column, TargetRow2),
            piece_jumps_upwards(Column, Row, p1, TargetRow2, Tail),
            Move = [Column, Row, Column, TargetRow2],
            append([Move], Tail, List)
      ;     List = []
      ).

piece_jumps_upwards(Column, Row, p2, TargetRow, List) :-
      (     
            TargetRow < 6,
            TargetRow1 is TargetRow + 1, TargetRow2 is TargetRow + 2,
            (red(Column, TargetRow1); slipper_red(Column, TargetRow2)), \+ black(Column, TargetRow2),
            piece_jumps_upwards(Column, Row, p2, TargetRow2, Tail),
            Move = [Column, Row, Column, TargetRow2],
            append([Move], Tail, List)
      ;     List = []
      ).

% piece_jumps_upwards(+Column, +Row, +Player, +TargetRow, -List )
% Get recursively a list with the valid upward jumps a certain piece has
piece_jumps_downwards(Column, Row, p1, TargetRow, List) :-
      (     
            TargetRow > 0,
            TargetRow1 is TargetRow - 1, TargetRow2 is TargetRow - 2,
            (black(Column, TargetRow1); slipper_black(Column, TargetRow2)), \+ red(Column, TargetRow2),
            piece_jumps_upwards(Column, Row, p1, TargetRow2, Tail),
            Move = [Column, Row, Column, TargetRow2],
            append([Move], Tail, List)
      ;     List = []
      ).

piece_jumps_downwards(Column, Row, p2, TargetRow, List) :-
      (     
            TargetRow > 1,
            TargetRow1 is TargetRow - 1, TargetRow2 is TargetRow - 2,
            (red(Column, TargetRow1); slipper_red(Column, TargetRow2)), \+ black(Column, TargetRow2),
            piece_jumps_upwards(Column, Row, p2, TargetRow2, Tail),
            Move = [Column, Row, Column, TargetRow2],
            append([Move], Tail, List)
      ;     List = []
      ).

% greedy_evaluation(+GameState, +ListOfMoves, -BestMove, -BestValue)
% Goes recursively through every move in the list of moves and retrieve the one that has the biggest value for the player
% Simulates a move in order to obtain its value
greedy_evaluation([Player|Board], [H], BestMove, BestValue) :-
      simulate_move([Player|Board], H, Value),
      BestMove = H,
      BestValue = Value.

greedy_evaluation([Player|Board], [H|T], BestMove, BestValue) :-
      (
            simulate_move([Player|Board], H, Value),
            greedy_evaluation([Player|Board], T, CurrBestMove, CurrBestValue),
            (
                  Value > CurrBestValue
            ->    BestMove = H, BestValue = Value 
            ;     BestMove = CurrBestMove, BestValue = CurrBestValue       
            )
      ).

% simulate_move(+GameState, +Move, -Value)
% Simulates a move and obtains the evaluation of the board after it
simulate_move([Player|Board], [C1,R1,C2,R2], Value) :-
      update_board(Piece, Board, NewBoard, [C1,R1,C2,R2], WasSlipper),
      value([Player|NewBoard], Value),
      retract_board(Piece, NewBoard, [C2,R2,C1,R1], WasSlipper).

% update_board(+Board, -NewBoard, +Move, -WasSlipper)
% Updates the board with the given move. Stores *WasSlipper* to use in retraction, if needed
% Updates for a normal move
update_board(Board, NewBoard, [X,Y1,X,Y2], WasSlipper) :-
      Y2 =:= Y1 - 2,
      EmptySpace = .,
      YOpponentPiece is Y1 - 1,
      get_piece(Board, X, Y1, Piece),
      get_piece(Board, X, YOpponentPiece, OpponentPiece), 
      slipper_piece(OpponentPiece, Slipper),  
      update_matrix(Board, X, Y1, EmptySpace, TempBoard),
      update_matrix(TempBoard, X, Y2, Piece, SecondTempBoard),
      update_matrix(SecondTempBoard, X, YOpponent, Slipper, NewBoard),
      (
            update_piece_type(OpponentPiece, X, YOpponent)
      ->    WasSlipper = 1
      ;     WasSlipper = 0
      ),
      update_piece_position(Piece, [X,Y1,X,Y2]).

% Updates for a upwards jump 
update_board(Board, NewBoard, [X,Y1,X,Y2], WasSlipper) :-
      Y2 =:= Y1 + 2,
      EmptySpace = .,
      YOpponentPiece is Y1 + 1,
      get_piece(Board, X, Y1, Piece),
      get_piece(Board, X, YOpponentPiece, OpponentPiece), 
      slipper_piece(OpponentPiece, Slipper),  
      update_matrix(Board, X, Y1, EmptySpace, TempBoard),
      update_matrix(TempBoard, X, Y2, Piece, SecondTempBoard),
      update_matrix(SecondTempBoard, X, YOpponent, Slipper, NewBoard),
      (
            update_piece_type(OpponentPiece, X, YOpponent)
      ->    WasSlipper = 1
      ;     WasSlipper = 0
      ),
      update_piece_position(Piece, [X,Y1,X,Y2]).

% Updates for a downwards jump
update_board(Board, NewBoard, [X1,Y,X2,Y], WasSlipper) :-
      X1 =\= X2,
      WasSlipper = 0,
      EmptySpace = .,
      get_piece(Board, X1, Y, Piece),
      update_matrix(Board, X1, Y, EmptySpace, TempBoard),
      update_matrix(TempBoard, X2, Y, Piece, NewBoard),
      update_piece_position(Piece, [X1,Y,X1,Y]).

% retract_board(+Board, -NewBoard, +Move, +WasSlipper)
% Retracts the board from a given move
% Retracts from a downwards jump
retract_board(Board, NewBoard, [X,Y1,X,Y2], WasSlipper) :-
      Y2 =:= Y1 - 2, !,
      EmptySpace = .,
      YOpponentPiece is Y1 - 1,
      get_piece(Board, X, Y1, Piece),
      get_piece(Board, X, YOpponentPiece, OpponentPiece),
      update_matrix(Board, X, Y1, EmptySpace, TempBoard),
      update_matrix(TempBoard, X, Y2, Piece, SecondTempBoard),  
      (
            WasSlipper =:= 1
      ->    NewBoard = SecondTempBoard
      ;     jumper_piece(OpponentPiece, Jumper), 
            retract_piece_type(OpponentPiece, X, YOpponentPiece),
            update_matrix(SecondTempBoard, X, YOpponentPiece, Jumper, NewBoard)
      ).

% Retracts from a upwards jump 
retract_board(Board, NewBoard, [X,Y1,X,Y2], WasSlipper) :-
      Y2 =:= Y1 + 2, !,
      EmptySpace = .,
      YOpponentPiece is Y1 + 1,
      get_piece(Board, X, Y1, Piece),
      get_piece(Board, X, YOpponentPiece, OpponentPiece),
      update_matrix(Board, X, Y1, EmptySpace, TempBoard),
      update_matrix(TempBoard, X, Y2, Piece, SecondTempBoard),  
      (
            WasSlipper =:= 1
      ->    NewBoard = SecondTempBoard
      ;     jumper_piece(OpponentPiece, Jumper), 
            retract_piece_type(OpponentPiece, X, YOpponentPiece),
            update_matrix(SecondTempBoard, X, YOpponentPiece, Jumper, NewBoard)
      ).

% Retracts from a normal move
retract_board(Board, NewBoard, [X1,Y,X2,Y], WasSlipper) :-
      X1 =\= X2, !,
      WasSlipper = 0,
      EmptySpace = .,
      get_piece(Board, X1, Y, Piece),
      update_matrix(Board, X1, Y, EmptySpace, TempBoard),
      update_matrix(TempBoard, X2, Y, Piece, NewBoard).

% value(+GameState, -Value)
% Get the value of the current state of the game
% The value is obtained by the difference between the number of possible moves of the current player and the opponent and divided by 8
value([Player|Board], Value) :-
      valid_moves([Player|Board], PlayerMoves),
      other_player(Player, Opponent),
      valid_moves([Opponent|Board], OpponentMoves),
      length(PlayerMoves, V1),
      length(OpponentMoves, V2),
      Val is V1 - V2,
      Value is Val / 8.


%%%%%%%%%%%%%%%%%%%%%%%%%

%  AUXILIAR PREDICATES  %

% other_player(+Player, -Opponent)
% Gets the constant of the opponent player
other_player(p1, Opponent) :-
      Opponent = p2.
other_player(p2, Opponent) :-
      Opponent = p1.

% get_move(-Move)
% Gets the move from the input and validates it
get_move(Move) :-
      repeat,
      read(String),
      (     sub_atom(String, 0, 1, _, A),
            sub_atom(String, 1, 1, _, B),
            sub_atom(String, 2, 1, _, C),
            sub_atom(String, 3, 1, _, D),
            \+ sub_atom(String, 4, 1, _, _),
            validate_column(A, C1),
            validate_row(B,R1),
            validate_column(C, C2),
            validate_row(D,R2)
      ->    Move = [C1,R1,C2,R2]
      ;     write('Invalid Input. Please try again writing in the format *a1b1*.'), nl, fail
      ).

% validate_column(+Letter, -Column)
% Validates the letter of the column chosen
validate_column('a', Column) :-
      Column = 0.
  
validate_column('b', Column) :-
      Column = 1.
  
validate_column('c', Column) :-
      Column = 2.
  
validate_column('d', Column) :-
      Column = 3.
  
validate_column('e', Column) :-
      Column = 4.
  
validate_column('f', Column) :-
      Column = 5.
  
validate_column('g', Column) :-
      Column = 6.
  
validate_column('h', Column) :-
      Column = 7.

% validate_row(+Letter, -Row)
% Validates the number of the row chosen
validate_row('1', Row) :-
      Row = 7.
  
validate_row('2', Row) :-
      Row = 6.
  
validate_row('3', Row) :-
      Row = 5.
  
validate_row('4', Row) :-
      Row = 4.
  
validate_row('5', Row) :-
      Row = 3.
  
validate_row('6', Row) :-
      Row = 2.
  
validate_row('7', Row) :-
      Row = 1.
  
validate_row('8', Row) :-
      Row = 0.

% append(+List1, +List2, +List3, -NewList)
% Joins 3 lists into a single one
append(List1, List2, List3, NewList) :-
      append(List1, List2, AuxiliarList),
      append(AuxiliarList, List3, NewList).

% get_piece(+Board, +C, +R, -Piece)
% Gets a piece from the board
get_piece(Board, C, R, Piece):-
      nth0(R, Board, Row),
      nth0(C, Row, Piece).

% update_matrix(+Board, +Column, +Row, +Piece, -NewBoard)
% Updates the matrix of the board on a given position with a new piece
update_matrix(Board, Column, Row, Piece, NewBoard) :-
      nth0(Row,Board,CRow,TBoard),
      nth0(Column,CRow,_,TRow),
      nth0(Column,NewRow,Piece,TRow),
      nth0(Row,NewBoard,NewRow,TBoard).

% update_piece_position(+Piece, +Move)
% Updates a piece from the database with the new position from the move
update_piece_position(r, [X1,Y1,X2,Y2]) :-
      retract(red(X1,Y1)),
      assertz(red(X2,Y2)).
  
update_piece_position(s_r, [X1,Y1,X2,Y2]) :-
      retract(slipper_red(X1,Y1)),
      assertz(slipper_red(X2,Y2)).
  
update_piece_position(b, [X1,Y1,X2,Y2]) :-
      retract(black(X1,Y1)),
      assertz(black(X2,Y2)).
  
update_piece_position(s_b, [X1,Y1,X2,Y2]) :-
      retract(slipper_black(X1,Y1)),
      assertz(slipper_black(X2,Y2)).

% update_piece_type(+Piece, +X, +Y)
% Downgrades a Jumper to a Slipper from the database
update_piece_type(r, X, Y) :-
      retract(red(X,Y)),
      assertz(slipper_red(X,Y)).
  
update_piece_type(b, X, Y) :-
      retract(black(X,Y)),
      assertz(slipper_black(X,Y)).

% update_piece_type(+Piece, +X, +Y)
% Upgrades a Slipper to a Jumper from the database
% Only used when simulating the moves
retract_piece_type(s_r, X, Y) :-
      retract(slipper_red(X,Y)),
      assertz(red(X,Y)).
  
retract_piece_type(s_b, X, Y) :-
      retract(slipper_black(X,Y)),
      assertz(black(X,Y)).

% delete_piece_from_board(+Piece, +X, +Y)
% Deletes the piece from the database
delete_piece_from_board(r, X, Y) :-
      retract(red(X,Y)).
  
delete_piece_from_board(s_r, X, Y) :-
      retract(slipper_red(X,Y)).
  
delete_piece_from_board(b, X, Y) :-
      retract(black(X,Y)).
  
delete_piece_from_board(s_b, X, Y) :-
      retract(slipper_black(X,Y)).

% jumper_piece(+Slipper, -Jumper)
% Get the jumper piece for a given Slipper
jumper_piece(s_r, Jumper) :-
      Jumper = r.     
jumper_piece(s_b, Jumper) :-
      Jumper = b.

% random_index(-Index, +ListOfMoves)
% Obtain a random index from a list of moves
random_index(Index, ListOfMoves) :-
      length(ListOfMoves, Length),
      random(0, Length, Index).

% remove_duplicates(+List, -NewList)
% Removes duplicates from a list recursively
remove_duplicates([], []).
remove_duplicates([H|T], List) :- member(H, T), remove_duplicates(T, List).
remove_duplicates([H|T], [H|List]) :- \+ member(H, T), remove_duplicates(T, List).

%%%%%%%%%%%%%%%%%%%%%%%%%
