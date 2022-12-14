% board 8 x 8
newBoard([
    [lefty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,righty],
    [lefty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,righty],
    [lefty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,righty],
    [lefty,empty,empty,empty,empty,empty,empty,empty],
    [empty,empty,empty,empty,empty,empty,empty,righty]
]).

symbol(empty, S) :- S='.'.
symbol(righty, S) :- S='R'.
symbol(lefty, S) :- S='L'.
symbol(slipper_righty, S) :- S='r'.
symbol(slipper_lefty, S) :- S='l'.

letter(1, L) :- L='A'.
letter(2, L) :- L='B'.
letter(3, L) :- L='C'.
letter(4, L) :- L='D'.
letter(5, L) :- L='E'.
letter(6, L) :- L='F'.
letter(7, L) :- L='G'.
letter(8, L) :- L='H'.

printBoard(X) :-
    nl,
    write('-----|---|---|---|---|---|---|---|---|\n'),
    printMatrix(X, 8),
    write('     |<A>|<B>|<C>|<D>|<E>|<F>|<G>|<H>|\n').

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