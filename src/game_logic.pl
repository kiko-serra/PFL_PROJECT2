checkPiece(Board, NewBoard, Player, RowIndex, ColumnIndex) :-
      (
            (getPieceFromMatrix(Board, RowIndex, ColumnIndex, Piece), Player =:= Piece);
            (askCoords(Board,Player,NewBoard))
      ).

/*Analise each turn.*/
askCoords(Board, Player, NewBoard) :-
      manageCoordinates(NewRow, NewColumn),
      ColumnIndex is NewColumn - 1,
      RowIndex is NewRow - 1,
      write('\n'),
      checkPiece(Board, NewBoard, Player, RowIndex, ColumnIndex).

addPieces(NewBoard, UpdatedBoard, 'P', 'P') :-
      printBoard(NewBoard),
      write('\n------------------ PLAYER 1 -------------------\n\n'),
      write('1. Choose skier.\n'),
      askCoords(NewBoard, lefty, UpdatedBoard),
      write('2. Choose skier.\n'),
      %write('\n------------------ PLAYER 2 -------------------\n\n'),
      %write('1. Choose skier.\n'),
      %askCoords(Worker1Board, righty, UpdatedBoard, empty),
      printBoard(UpdatedBoard).


startGame(P1, P2) :-
    newBoard(NewBoard),
    addPieces(NewBoard, UpdatedBoard, P1, P2),
    gameLoop(UpdatedBoard, P1, P2).


isValidPosLines(Board, Row, Column, Res) :-
      (
            (isEmptyCell(Board, Row, Column, Res), Res =:= 1,
                  (getWorkersPos(Board, Worker1Row, Worker1Column, Worker2Row, Worker2Column),
                  ((isWorkerLines(Board, Worker1Row, Worker1Column, Row, Column, ResIsWorkerLines1), ResIsWorkerLines1 =:= 1, Res is 1);
                  (isWorkerLines(Board, Worker2Row, Worker2Column, Row, Column, ResIsWorkerLines2), ResIsWorkerLines2 =:= 1, Res is 1);
                  Res is 0)));
            (Res is 0)
      ).