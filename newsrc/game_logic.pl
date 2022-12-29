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


update_board(Piece, Board, NewBoard, [X1,Y1,X2,Y2]) :-
      update_matrix(Board, X1, Y1, ., TempBoard),
      nl,write(Piece),nl,
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
      % write('Is from Player? '), write(Piece), nl, % Debugging only!
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
      get_piece(Board, X1, Y1, Piece),
      update_board(Piece, Board, NewBoard, [X1,Y1,X2,Y2]),
      update_piece_position(Piece, [X1,Y1,X2,Y2]),
      update_player(Player, NewPlayer).

positions(Piece, Row, Positions) :-
    findall(Position, nth0(Position, Row, Piece), Positions).


iteration(_,_,_,-1).
iteration(Board, p1, [ListOfMoves|NewListOfMoves], N) :- % Move é do tipo [x1,y1,x2,y2]
      (
            (     
                  get_row(Board, N, Row),
                  positions(r, Row, Positions),
                  write(N), write(' ------ '),
                  foreach(member(Position, Positions),
                  (
                        nth0(Position, Row, Piece),
                        write(Position), write(' <-> ')
                  )),nl
            )
      -> true
      ; true
      ),
      N1 is N - 1,
      iteration(Board, p1, NewListOfMoves, N1).

valid_moves([Player|Board], ListOfMoves) :- % Mudar Board para Gamestate later % First, get only horizontal moves
      valid_move_forward(Player, Set1),
      border_pieces(Player, Set2),
      append(Set1, Set2, ListOfMoves).


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
            Jump,
            (
                  member(Col-Row, Pieces),
                  piece_jumps(Col, Row, Player, Row, List),
                  member(Jump, List)
            ),
            L2
      ),
      append(L1, L2, List),
      write('List of jumps: '), write(L2), nl,
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

piece_jumps(Column, Row, p1, Y, List) :-
      (     
            Y > 0, Y < 7,
            Y1 is Y + 1, Y2 is Y + 2,
            (black(Column, Y1); slipper_black(Column, Y2)), \+ red(Column, Y2),
            piece_jumps(Column, Row, p1, Y2, Tail),
            Move = [Column, Row, Column, Y2],
            append([Move], Tail, List)
      ;     List = []
      ).

piece_jumps(Column, Row, p1, Y, List) :-
      (     
            Y > 0, Y < 7,
            Y1 is Y - 1, Y2 is Y - 2,
            (black(Column, Y1); slipper_black(Column, Y2)), \+ red(Column, Y2),
            piece_jumps(Column, Row, p1, Y2, Tail),
            Move = [Column, Row, Column, Y2],
            append([Move], Tail, List)
      ;     List = []
      ).

piece_jumps(Column, Row, p2, Y, List) :-
      (     
            Y > 0, Y < 7,
            Y1 is Y + 1, Y2 is Y + 2,
            (red(Column, Y1); slipper_red(Column, Y2)), \+ black(Column, Y2),
            piece_jumps(Column, Row, p1, Y2, Tail),
            Move = [Column, Row, Column, Y2],
            append([Move], Tail, List)
      ;     List = []
      ).
piece_jumps(Column, Row, p2, Y, List) :-
      (     
            Y > 0, Y < 7,
            Y1 is Y - 1, Y2 is Y - 2,
            (red(Column, Y1); slipper_red(Column, Y2)), \+ black(Column, Y2),
            piece_jumps(Column, Row, p1, Y2, Tail),
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

count_piece(Board, Count, Piece) :-
    count_piece(Board, 0, Count, Piece).

count_piece([], Count, Count, Piece).
count_piece([Row|Rows], Acc, Count, Piece) :-
    (   member(r, Row)
    ->  Acc1 is Acc + 1
    ;   Acc1 is Acc
    ),
    count_piece(Rows, Acc1, Count, Piece).

player_piece_counter(Player, Board, Counter) :-
      player_jumper_piece(Player, Jumper),
      count_piece(Board, Counter1, Jumper),
      player_slipper_piece(Player, Slipper),
      count_piece(Board, Counter2, Slipper), 
      Counter is Counter1 + Counter2.

game_over([Player|Board], Winner) :-
      player_piece_counter(Player, Board, C1),
      other_player(Player, Enemy),
      player_piece_counter(Player, Board, C2),
      (
            C1 =:= 0
      ->    Winner = p1,
            write('Win condition 1'),nl
      ;     (
                 C2 =:= 0 
            ->    Winner = p2,
                  write('Win condition 2'),nl
            ;     fail
            )
      ).

congratulate(Winner) :-
      write('Congratulations Player'), symbol(Winner, S), write(S), write(', you won!'),nl.

play_game(P1, P2):-
      flush_output,
      initial_state(Size, GameState),
      display_game(GameState),
      game_cycle(GameState).

game_cycle(GameState):-
      game_over(GameState, Winner), !,
      congratulate(Winner).

game_cycle(GameState):-
      valid_moves(GameState, ListOfMoves), write('Valid moves: '), write(ListOfMoves),nl,nl,
      choose_move(GameState, Level, Move),
      move(GameState, Move, NewGameState),
      display_game(NewGameState), !,
      game_cycle(NewGameState).


