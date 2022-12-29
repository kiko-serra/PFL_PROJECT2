% board 8 x 8
initial_state(8, GameState) :-
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
    assertz(red(0,0)),
    assertz(red(0,2)),
    assertz(red(0,4)),
    assertz(red(0,6)),
    assertz(black(7,1)),
    assertz(black(7,3)),
    assertz(black(7,5)),
    assertz(black(7,7)),
    assertz(slipper_red(9,9)),
    assertz(slipper_black(9,9)),
    retract(slipper_red(9,9)),
    retract(slipper_black(9,9)).


symbol(p1, S) :- S='1'.
symbol(p2, S) :- S='2'.
symbol(., S) :- S=' '.
symbol(r, S) :- S='R'.   % jumper_red
symbol(b, S) :- S='B'.   % jumper_black
symbol(s_r, S) :- S='r'. % slipper_red
symbol(s_b, S) :- S='b'. % slipper_black

letter(1, 'A').
letter(2, 'B').
letter(3, 'C').
letter(4, 'D').
letter(5, 'E').
letter(6, 'F').
letter(7, 'G').
letter(8, 'H').

clear_data :-
    abolish(red/2),
    abolish(slipper_red/2),
    abolish(black/2),
    abolish(slipper_black/2).

get_pieces(Pieces) :-
    findall(C1-R1, red(C1,R1), Reds),
    findall(C2-R2, black(C2,R2), Blacks),
    findall(C3-R3, slipper_red(C3,R3), SReds),
    findall(C4-R4, slipper_black(C4,R4), SBlacks),
    append(Reds, SReds, L1), append(L1, Blacks, L2), append(L2, SReds, L3), append(L3, SBlacks, L4),
    remove_duplicates(L4, Pieces).

get_all_player_pieces(p1, Lenght) :-
    findall(X1-Y1, red(X1,Y1), Reds),
    findall(X2-Y2, slipper_red(X2,Y2), SReds),
    append(Reds, SReds, List),
    length(List, Lenght).

get_all_player_pieces(p2, Lenght) :-
    findall(X1-Y1, black(X1,Y1), Blacks),
    findall(X2-Y2, slipper_black(X2,Y2), SBlacks),
    append(Blacks, SBlacks, List),
    length(List, Lenght).

remove_duplicates([], []).
remove_duplicates([H|T], List) :- member(H, T), remove_duplicates(T, List).
remove_duplicates([H|T], [H|List]) :- \+ member(H, T), remove_duplicates(T, List).

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

delete_piece_from_board(r, X, Y) :-
    retract(red(X,Y)).

delete_piece_from_board(s_r, X, Y) :-
    retract(slipper_red(X,Y)).

delete_piece_from_board(b, X, Y) :-
    retract(black(X,Y)).

delete_piece_from_board(s_b, X, Y) :-
    retract(slipper_black(X,Y)).

update_piece_type(r, X, Y) :-
    retract(red(X,Y)),
    assertz(slipper_red(X,Y)).

update_piece_type(b, X, Y) :-
    retract(black(X,Y)),
    assertz(slipper_black(X,Y)).

display_game([Player|Board]) :-
    nl,
    write('-----|---|---|---|---|---|---|---|---|'),nl,
    printMatrix(Board, 8),
    write('     |<A>|<B>|<C>|<D>|<E>|<F>|<G>|<H>|\n'),nl,nl,
    write('    > Player '),
    symbol(Player, S), write(S),
    write(' turn to play <'),nl,nl.

printMatrix([], _N).
printMatrix([Head|Tail], N) :-
    write(' <'),
    write(N),
    write('> | '),
    printLine(Head),
    write('\n-----|---|---|---|---|---|---|---|---|\n'),
    N1 is N - 1,
    printMatrix(Tail, N1).

printLine([]).
printLine([Head|Tail]) :-
    symbol(Head, S),
    write(S),
    write(' | '),
    printLine(Tail).