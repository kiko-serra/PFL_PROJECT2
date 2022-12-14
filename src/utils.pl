
% get value of a certain row & column of a matrix

getPieceFromLine([Head|_Tail], _Index, Value) :-
    Value = Head.

getPieceFromLine([_Head|Tail], Index, Value) :-
    Index > 0,
    Index1 is Index - 1,
    getPieceFromLine(Tail, Index1, Value).

getPieceFromMatrix([Head|_Tail], 0, Column, Value) :-
    getPieceFromLine(Head, Column, Value).

getPieceFromMatrix([_Head|Tail], Row, Column, Value) :-
    Row > 0,
    Row1 is Row - 1,
    getPieceFromMatrix(Tail, Row1, Column, Value).