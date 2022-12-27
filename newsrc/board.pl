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
    ].


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