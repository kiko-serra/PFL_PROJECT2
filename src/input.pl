manageCoordinates(NewRow, NewColumn) :-
    manageColumn(NewColumn),
    manageRow(NewRow).

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

validateColumn('A', NewColumn) :-
    NewColumn = 1.

validateColumn('B', NewColumn) :-
    NewColumn = 2.

validateColumn('C', NewColumn) :-
    NewColumn = 3.

validateColumn('D', NewColumn) :-
    NewColumn = 4.

validateColumn('E', NewColumn) :-
    NewColumn = 5.

validateColumn('F', NewColumn) :-
    NewColumn = 6.

validateColumn('G', NewColumn) :-
    NewColumn = 7.

validateColumn('H', NewColumn) :-
    NewColumn = 8.


validateColumn('a', NewColumn) :-
    NewColumn = 1.

validateColumn('b', NewColumn) :-
    NewColumn = 2.

validateColumn('c', NewColumn) :-
    NewColumn = 3.

validateColumn('d', NewColumn) :-
    NewColumn = 4.

validateColumn('e', NewColumn) :-
    NewColumn = 5.

validateColumn('f', NewColumn) :-
    NewColumn = 6.

validateColumn('g', NewColumn) :-
    NewColumn = 7.

validateColumn('h', NewColumn) :-
    NewColumn = 8.

validateColumn(_OtherColumn, NewColumn) :-
    write('ERROR: Column is not valid!\n\n'),
    readColumn(Input),
    validateColumn(Input, NewColumn).

% -------------- %


% --- ROW --- %
% We need to invert the values because of the display
validateRow(1, NewRow) :-
    NewRow = 8.

validateRow(2, NewRow) :-
    NewRow = 7.

validateRow(3, NewRow) :-
    NewRow = 6.

validateRow(4, NewRow) :-
    NewRow = 5.

validateRow(5, NewRow) :-
    NewRow = 4.

validateRow(6, NewRow) :-
    NewRow = 3.

validateRow(7, NewRow) :-
    NewRow = 2.

validateRow(8, NewRow) :-
    NewRow = 1.

validateRow(_OtherRow, NewRow) :-
    write('ERROR: Row is not valid!\n\n'),
    readRow(Input),
    validateRow(Input, NewRow).
% ----------- %