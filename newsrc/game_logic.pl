is_from_player(p1, r).
is_from_player(p2, b).

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


update_board(Piece, Board, NewBoard, [X1,Y1,X2,Y2]) :-
      nth0(Y1, Board, Row),
      nth0(X1, Row, Piece),
      update_matrix(Board, X1, Y1, ., TempBoard),
      update_matrix(TempBoard, X2, Y2, Piece, NewBoard).

check_normal_move(Board, [X1,Y1,X2,Y2], Piece) :-
      (     Piece == r; Piece == s_r,
            Y2 > Y1
      ->    true
      ;     (     Piece == b; Piece == s_b,
                  Y2 < Y1 
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
      %nth0(Y1, Board, Row),
      %nth0(X1, Row, Piece),
      get_piece(Board, X1, Y1, Piece),
      write('Is from Player? '), write(Piece), nl, % Debugging only!
      is_from_player(Player, Piece),
      (     Y1 =:= Y2, X1 =\= X2 % Normal Move
      ->    check_normal_move(Board, [X1,Y1,X2,Y2], Piece)     
      ;     (     X1 =:= X2, Y1 =\= Y2 % falta checkar se é jumper ou não
            -> check_jump_move(Board, [X1,Y1,X2,Y2], Piece)
            ; fail
            )
      ).
       %Falta fazer o resto das verificações (se é jumper ou nao, etc etc)
      

choose_move([Player|Board], Level, Move):-
      repeat,
      write(' > Choose skier. ---> '),
      manageCoordinates(Move),
      (     check_move(Player, Board, Move)
      ->    true
      ;     write('Invalid move. Please try again.'), nl, fail
      ).


move([Player|Board], [X1,Y1,X2,Y2], [NewPlayer|NewBoard]) :-
      update_board(Piece, Board, NewBoard, [X1,Y1,X2,Y2]),
      update_player(Player, NewPlayer).


play_game(P1, P2):-
      flush_output,
      initial_state(Size, GameState),
      display_game(GameState),
      game_cycle(GameState).

%game_cycle(GameState, Player):-
%      game_over(GameState, Winner), !,
%      congratulate(Winner).

game_cycle(GameState):-
      choose_move(GameState, Level, Move),
      move(GameState, Move, NewGameState),
      display_game(NewGameState), !,
      game_cycle(NewGameState).


