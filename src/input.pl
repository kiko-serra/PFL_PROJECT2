manageCoordinates(Move) :-
    read_characters(X1,Y1,X2,Y2),
    Move = [X1,Y1,X2,Y2],
    write('Move: '), write(Move). % Debugging only!

read_characters(X1,Y1,X2,Y2) :-
    repeat,
    read(String),
    sub_atom(String, 0, 1, _, A),
    sub_atom(String, 1, 1, _, B),
    sub_atom(String, 2, 1, _, C),
    sub_atom(String, 3, 1, _, D),
    (   validateColumn(A, X1),
        validateRow(B,Y1),
        validateColumn(C, X2),
        validateRow(D,Y2)
    ->  true
    ;   write('Invalid Input. Please try again.'), nl, fail
    ).


manageRow(NewRow) :-
    readRow(Row),
    validateRow(Row, NewRow).

manageColumn(NewColumn) :-
    readColumn(Column),
    validateColumn(Column, NewColumn).

readRow(Row) :-
    write('> Row --> '),
    read(Row).

readColumn(Column) :-
    write('> Column --> '),
    read(Column).

% --- Column --- %

validateColumn('a', NewColumn) :-
    NewColumn = 0.

validateColumn('b', NewColumn) :-
    NewColumn = 1.

validateColumn('c', NewColumn) :-
    NewColumn = 2.

validateColumn('d', NewColumn) :-
    NewColumn = 3.

validateColumn('e', NewColumn) :-
    NewColumn = 4.

validateColumn('f', NewColumn) :-
    NewColumn = 5.

validateColumn('g', NewColumn) :-
    NewColumn = 6.

validateColumn('h', NewColumn) :-
    NewColumn = 7.


% -------------- %


% --- ROW --- %
% We need to invert the values because of the display
validateRow('1', NewRow) :-
    NewRow = 7.

validateRow('2', NewRow) :-
    NewRow = 6.

validateRow('3', NewRow) :-
    NewRow = 5.

validateRow('4', NewRow) :-
    NewRow = 4.

validateRow('5', NewRow) :-
    NewRow = 3.

validateRow('6', NewRow) :-
    NewRow = 2.

validateRow('7', NewRow) :-
    NewRow = 1.

validateRow('8', NewRow) :-
    NewRow = 0.


% ----------- %