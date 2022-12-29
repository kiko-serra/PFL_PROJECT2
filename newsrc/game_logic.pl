is_from_player(p1, r).
is_from_player(p1, s_r).
is_from_player(p2, b).
is_from_player(p2, s_b).

other_player(p1, Enemy) :-
      Enemy = p2.
other_player(p2, Enemy) :-
      Enemy = p1.

player_jumper_piece(p1, Piece):-
      Piece = r.

player_jumper_piece(p2, Piece):-
      Piece = b.

player_slipper_piece(p1, Piece):-
      Piece = s_r.

player_slipper_piece(p2, Piece):-
      Piece = s_b.

is_enemy(b, EnemyPiece):-
      EnemyPiece = r.
is_enemy(r, EnemyPiece):-
      EnemyPiece = b.

slipper_piece(r, Slipper) :-
      Slipper = s_r.     
slipper_piece(b, Slipper) :-
      Slipper = s_b.

get_row(Board, Y, Row):-
      nth0(Y, Board, Row).

get_piece(Board, X, Y, Piece):-
      nth0(Y, Board, Row),
      nth0(X, Row, Piece).

update_player(p1, NewPlayer) :-
      NewPlayer = p2.

update_player(p2, NewPlayer) :-
      NewPlayer = p1.

update_matrix(Board, Column, Row, Piece, NewBoard) :-
      nth0(Row,Board,CRow,TBoard),
      nth0(Column,CRow,_,TRow),
      nth0(Column,NewRow,Piece,TRow),
      nth0(Row,NewBoard,NewRow,TBoard).


update_board(Piece, Board, NewBoard, [X1,Y1,X2,Y2]) :- % Change this asap, the verification is done already!!
      update_matrix(Board, X1, Y1, ., TempBoard),
      update_matrix(TempBoard, X2, Y2, Piece, AnotherBoard),
      (     X1 =:= X2
      ->    (     Y2 =:= Y1 - 2
            ->    (
                        YEnemy is Y1 - 1,
                        get_piece(Board, X1, YEnemy, EnemyPiece),  
                        is_enemy(Piece, EnemyPiece)
                  ->    slipper_piece(EnemyPiece, Slipper), update_piece_type(EnemyPiece, X1, YEnemy),
                        update_matrix(AnotherBoard, X1, YEnemy, Slipper, NewBoard)
                  ;     write('fail 1\n'),fail
                  )
            ;     (     Y2 =:= Y1 + 2,
                        YEnemy is Y1 + 1,
                        get_piece(Board, X1, YEnemy, EnemyPiece), 
                        is_enemy(Piece, EnemyPiece)
                  ->    slipper_piece(EnemyPiece, Slipper), update_piece_type(EnemyPiece, X1, YEnemy),
                        update_matrix(AnotherBoard, X1, YEnemy, Slipper, NewBoard)
                  ;     write('fail 2\n'),fail
                  )
            )
      ;     NewBoard = AnotherBoard
      ).

off_the_board_pieces(Board, NewBoard, ListOfMoves) :-
      findall([X, Y], (red(X, Y), X = 7, \+ member([X,Y,_,_], ListOfMoves)), L1),
      findall([X, Y], (slipper_red(X, Y), X = 7, \+ member([X,Y,_,_], ListOfMoves)), L2),
      findall([X, Y], (black(X, Y), X = 0, \+ member([X,Y,_,_], ListOfMoves)), L3),
      findall([X, Y], (slipper_black(X, Y), X = 0, \+ member([X,Y,_,_], ListOfMoves)), L4),
      length(L1, Lenght1), length(L2, Lenght2), length(L3, Lenght3), length(L4, Lenght4),
      move_off_the_board(Board, B2, r, L1, Lenght1),
      move_off_the_board(B2, B3, s_r, L2, Lenght2),
      move_off_the_board(B3, B4, b, L3, Lenght3),
      move_off_the_board(B4, NewBoard, s_b, L4, Lenght4).

move_off_the_board(Board,NewBoard,_, [], 0):-
      NewBoard = Board.
move_off_the_board(Board, NewBoard, Piece, [[X,Y]|T], Lenght) :-
      Lenght1 is Lenght - 1,
      delete_piece_from_board(Piece, X, Y),
      update_matrix(TempBoard, X, Y, ., NewBoard),
      move_off_the_board(Board, TempBoard, Piece, T, Lenght1).

check_normal_move(Board, [X1,Y1,X2,Y2], Piece) :-
      (     (Piece = r; Piece = s_r),
            X2 > X1
      ->    true
      ;     (     (Piece = b; Piece = s_b),
                  X2 < X1 
            -> true
            ;  fail
            )
      ).


check_jump_move(Board, [X1,Y1,X2,Y2], r) :-
      (     Y2 =:= Y1 - 2
      ->    (     YEnemy is Y1 - 1,
                  get_piece(Board, X1, YEnemy, EnemyPiece),  
                  (EnemyPiece == b; EnemyPiece == s_b)
            ->    true
            ;     fail
            )
      ;     (     Y2 =:= Y1 + 2
            ->    (     YEnemy is Y1 + 1,
                        get_piece(Board, X1, YEnemy, EnemyPiece),  
                        (EnemyPiece == b; EnemyPiece == s_b)
                  ->    true
                  ;     fail
                  )
            ; fail
            )   
      ).


check_jump_move(Board, [X1,Y1,X2,Y2], b) :-
      (     Y2 =:= Y1 - 2
      ->    (     YEnemy is Y1 - 1,
                  get_piece(Board, X1, YEnemy, EnemyPiece),  
                  (EnemyPiece == r; EnemyPiece == s_r )
            ->    true
            ;     fail
            )
      ;     (     Y2 =:= Y1 + 2
            ->    (     YEnemy is Y1 + 1,
                        get_piece(Board, X1, YEnemy, EnemyPiece),  
                        (EnemyPiece == r; EnemyPiece == s_r )
                  ->    true
                  ;     fail
                  )
            ; fail
            )   
      ).



check_move(Player, Board, [X1,Y1,X2,Y2]) :-
      get_piece(Board, X1, Y1, Piece), nl,
      is_from_player(Player, Piece),
      (     Y1 =:= Y2, X1 =\= X2 % Normal Move
      ->    check_normal_move(Board, [X1,Y1,X2,Y2], Piece)     
      ;     (     X1 =:= X2, Y1 =\= Y2 % falta checkar se é jumper ou não
            -> check_jump_move(Board, [X1,Y1,X2,Y2], Piece)
            ; fail
            )
      ).
      %Falta fazer o resto das verificações (se é jumper ou nao, etc etc)
      
random_index(Index, ListOfMoves) :-
      length(ListOfMoves, Length),
      random(0, Length, Index).

simulate_move([Player|Board], [X1,Y1,X2,Y2], Value) :-
      (
            write([X1,Y1,X2,Y2]),nl,
            get_piece(Board, X1, Y1, Piece), % Update ao get piece quando possivel para usar a db
            update_board(Piece, Board, NewBoard, [X1,Y1,X2,Y2]),
            value([Player|NewBoard], Value)
      ).

greedy_evaluation([Player|Board], [H], BestMove, BestValue) :-
      value([Player|Board], CurrentValue),
      simulate_move([Player|Board], H, Value),
      BestMove = H,
      BestValue = Value.


greedy_evaluation([Player|Board], [H|T], BestMove, BestValue) :- % Deep of search de 1 move ?
      (
            simulate_move([Player|Board], H, Value),
            greedy_evaluation([Player|Board], T, CurrBestMove, CurrBestValue),
            (
                  Value @> CurrBestValue
            ->    BestMove = H, BestValue = Value 
            ;     BestMove = CurrBestMove, BestValue = CurrBestValue       
            )
      ).

choose_move([Player|Board], 0, Move):-
      repeat,
      write(' > Choose skier. ---> '),
      manageCoordinates(Move),
      (     check_move(Player, Board, Move)
      ->    true
      ;     write('Invalid move. Please try again.'), nl, fail
      ).

choose_move([Player|Board], 1, Move):-
      write(' > Choose skier. ---> '),
      valid_moves([Player|Board], ListOfMoves),
      random_index(Index, ListOfMoves),
      nth0(Index, ListOfMoves, Move).

choose_move([Player|Board], 2, Move):-
      write(' > Choose skier. ---> '),
      read(Input),
      valid_moves([Player|Board], ListOfMoves),
      greedy_evaluation([Player|Board], ListOfMoves, Move, Value).

move([Player|Board], [X1,Y1,X2,Y2], [NewPlayer|NewBoard]) :-
      valid_moves([Player|Board], ListOfMoves),
      (
            length(ListOfMoves, Length),
            Length > 0,
            member([X1,Y1,X2,Y2], ListOfMoves), 
            get_piece(Board, X1, Y1, Piece), % Update ao get piece quandopossivel para usar a db
            update_board(Piece, Board, SecondBoard, [X1,Y1,X2,Y2]),
            update_piece_position(Piece, [X1,Y1,X2,Y2]),
            update_player(Player, NewPlayer),
            valid_moves([Player|SecondBoard], CurrentPlayerMoves),
            valid_moves([NewPlayer|SecondBoard], OtherPlayerMoves),
            append(CurrentPlayerMoves, OtherPlayerMoves, FullList),
            off_the_board_pieces(SecondBoard, NewBoard, FullList)
      ;     NewBoard = Board
      ).

valid_moves([Player|Board], ListOfMoves) :- % Mudar Board para Gamestate later % First, get only horizontal moves
      valid_move_forward(Player, ListOfMoves).
      %border_pieces(Player, Set2), % Deixar as borders de fora
      %append(Set1, Set2, ListOfMoves).


valid_move_forward(p1, List) :-
      findall(C1-R1, red(C1,R1), Reds),
      findall(C2-R2, slipper_red(C2,R2), SReds),
      append(Reds, SReds, L1),
      find_moves(L1, p1, List).

valid_move_forward(p2, List) :-
      findall(C1-R1, black(C1,R1), Blacks),
      findall(C2-R2, slipper_black(C2,R2), SBlacks),
      append(Blacks, SBlacks, L1),
      find_moves(L1, p2, List).

find_moves(Pieces, Player, NewList) :- % CHANGE THISSSSSS
      findall(
            Move,
            (
                  member(Col-Row, Pieces),
                  piece_moves(Col, Row, Player, Col, List),
                  member(Move, List)
            ),
            L1
      ),
      findall(
            JumpUp,
            (
                  member(Col-Row, Pieces),
                  piece_jumps_upwards(Col, Row, Player, Row, List),
                  member(JumpUp, List)
            ),
            L2
      ),
      findall(
            JumpDown,
            (
                  member(Col-Row, Pieces),
                  piece_jumps_downwards(Col, Row, Player, Row, List),
                  member(JumpDown, List)
            ),
            L3
      ),
      append(L1, L2, AuxL),
      append(AuxL, L3, List),
      remove_duplicates(List, NewList).


piece_moves(Column, Row, p1, X, List) :-
      (     X < 7,
            X1 is X + 1,
            \+ red(X1,Row), \+ slipper_red(X1,Row),
            piece_moves(Column, Row, p1, X1, Tail),
            Move = [Column, Row, X1, Row],
            append([Move], Tail, List)
      ;     List = []
      ).

piece_moves(Column, Row, p2, X, List) :-
      (     
            X > 0,
            X1 is X - 1,
            \+ black(X1,Row), \+ slipper_black(X1,Row),
            piece_moves(Column, Row, p2, X1, Tail),
            Move = [Column, Row, X1, Row],
            append([Move], Tail, List)
      ;     List = []
      ).

piece_jumps_upwards(Column, Row, p1, Y, List) :-
      (     
            Y < 6,
            Y1 is Y + 1, Y2 is Y + 2,
            (black(Column, Y1); slipper_black(Column, Y2)), \+ red(Column, Y2),
            piece_jumps_upwards(Column, Row, p1, Y2, Tail),
            Move = [Column, Row, Column, Y2],
            append([Move], Tail, List)
      ;     List = []
      ).

piece_jumps_downwards(Column, Row, p1, Y, List) :-
      (     
            Y > 1,
            Y1 is Y - 1, Y2 is Y - 2,
            (black(Column, Y1); slipper_black(Column, Y2)), \+ red(Column, Y2),
            piece_jumps_downwards(Column, Row, p1, Y2, Tail),
            Move = [Column, Row, Column, Y2],
            append([Move], Tail, List)
      ;     List = []
      ).

piece_jumps_upwards(Column, Row, p2, Y, List) :-
      (     
            Y < 6,
            Y1 is Y + 1, Y2 is Y + 2,
            (red(Column, Y1); slipper_red(Column, Y2)), \+ black(Column, Y2),
            piece_jumps_upwards(Column, Row, p1, Y2, Tail),
            Move = [Column, Row, Column, Y2],
            append([Move], Tail, List)
      ;     List = []
      ).
piece_jumps_downwards(Column, Row, p2, Y, List) :-
      (     
            Y > 1,
            Y1 is Y - 1, Y2 is Y - 2,
            (red(Column, Y1); slipper_red(Column, Y2)), \+ black(Column, Y2),
            piece_jumps_downwards(Column, Row, p1, Y2, Tail),
            Move = [Column, Row, Column, Y2],
            append([Move], Tail, List)
      ;     List = []
      ).


border_pieces(p1, List) :-
      findall([X, Y, ., .], (red(X, Y), X = 7), L1),
      findall([X, Y, ., .], (slipper_red(X, Y), X = 7), L2),
      append(L1, L2, List).

border_pieces(p2, List) :-
      findall([X, Y, ., .], (black(X, Y), X = 0), L1),
      findall([X, Y, ., .], (slipper_black(X, Y), X = 0), L2),
      append(L1, L2, List).

value([Player|Board], Value) :-
      valid_moves([Player|Board], PlayerMoves),
      update_player(Player, Opponent),
      valid_moves([Opponent|Board], OpponentMoves),
      length(PlayerMoves, V1),
      length(OpponentMoves, V2),
      Val is V1 - V2,
      Value is Val / 8,
      write('Your position value is: '),
      (
            Value @>= 0
      ->    write('+')
      ;     true
      ),
      write(Value), nl.


level_current_player(_, 0, PlayerLevel) :-
      PlayerLevel = 0.


level_current_player([Player|Board], 1, PlayerLevel) :-
      (     player(X),
            X = Player
      ->    PlayerLevel = 0 
      ;     PlayerLevel = 1
      ).

level_current_player([Player|Board], 2, PlayerLevel) :-
      (     player(X),
            X = Player
      ->    PlayerLevel = 0 
      ;     PlayerLevel = 2
      ).

level_current_player([Player|Board], 11, PlayerLevel) :-
      PlayerLevel = 1.

level_current_player([Player|Board], 22, PlayerLevel) :-
      PlayerLevel = 2.

level_current_player([p1|Board], 12, PlayerLevel) :-
      PlayerLevel = 1.

level_current_player([p2|Board], 12, PlayerLevel) :-
      PlayerLevel = 2.

level_current_player([p1|Board], 21, PlayerLevel) :-
      PlayerLevel = 2.

level_current_player([p2|Board], 21, PlayerLevel) :-
      PlayerLevel = 1.

game_over([Player|Board], Winner) :-
      get_all_player_pieces(Player, C1),
      other_player(Player, Opponent),
      get_all_player_pieces(Opponent, C2),
      (
            C1 =:= 0, C2 > 0
      ->    Winner = p1,
            write('Win condition 1'),nl
      ;     (
                 C2 =:= 0, C1 > 0 
            ->    Winner = p2,
                  write('Win condition 2'),nl
            ;     (
                  C1 =:= 0, C2 =:= 0
                  -> Winner = p1, %FOR NOW CHANGE LATER TO TIE
                  write('It was a tie somehow'),nl
                  ; fail
                  )
            )
      ).

congratulate(Winner) :-
      write('Congratulations Player'), symbol(Winner, S), write(S), write(', you won!'),nl.


play_game(Level) :-
      flush_output,
      initial_state(Size, GameState),
      display_game(GameState),
      game_cycle(GameState, Level).

game_cycle(GameState, Level):-
      game_over(GameState, Winner), !,
      congratulate(Winner).

game_cycle(GameState, Level):-
      level_current_player(GameState, Level, PlayerLevel),
      choose_move(GameState, PlayerLevel, Move),
      move(GameState, Move, NewGameState),
      display_game(NewGameState), !,
      game_cycle(NewGameState, Level).



% Apenas precisa de dar update à db enquanto faz o algoritmo greedy e o bot está feito
% Trabalho bem encaminhado
