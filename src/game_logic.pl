checkPiece(Board,  Player, RowIndex, ColumnIndex) :-
      (
            (getPieceFromMatrix(Board, RowIndex, ColumnIndex, Piece), Player == Piece);
            (
                  write('\nERROR: That is not your piece!\n\n'),
                  PieceColumn is ColumnIndex + 1,
                  PieceRow is RowIndex + 1,
                  askPiece(Board,Player, PieceRow, PieceColumn)
            )
      ).


checkPosition(Board, Player, NewColumnIndex, ColumnIndex, RowIndex) :-
      (
            (
                  (Player == lefty,
                        NewColumnIndex > ColumnIndex,
                        NewColumnIndex < 8
                  );
                  (
                        write(NewColumnIndex),nl,
                        write('ERROR: That is not a valid new position!\n\n'),
                        PieceColumn is ColumnIndex + 1,
                        PieceRow is RowIndex + 1,
                        askRow(Board,Player, PieceRow, PieceColumn, NewColumn)
                  )
            );
            (
                  (Player == righty,
                        NewColumnIndex < ColumnIndex,
                        NewColumnIndex >= 0
                  );
                  (
                        write('\nERROR: That is not a valid new position!\n\n'),
                        PieceColumn is ColumnIndex + 1,
                        PieceRow is RowIndex + 1,
                        askRow(Board,Player, PieceRow, PieceColumn, NewColumn)
                  )
            )
      ).

% Firstly done without jumping %
askRow(Board, Player, PieceRow, PieceColumn, NewColumn) :-
      manageCoordinates(_NewRow, NewColumn),
      NewColIndex is NewColumn - 1,
      ColumnIndex is PieceColumn - 1,
      RowIndex is PieceRow - 1,
      write(NewColumn),nl, % Debug
      write('\n'),
      checkPosition(Board, Player, NewColIndex, ColumnIndex, RowIndex).

askPiece(Board, Player, PieceRow, PieceColumn) :-
      manageCoordinates(PieceRow, PieceColumn),
      ColumnIndex is PieceColumn - 1,
      RowIndex is PieceRow - 1,
      write('\n'),
      checkPiece(Board, Player, RowIndex, ColumnIndex).

addPieces(Board, UpdatedBoard, 'P', 'P') :-
      printBoard(Board),
      write('\n------------------ PLAYER 1 -------------------\n\n'),
      write('1. Choose skier.\n'),
      askPiece(Board, lefty, PieceRow, PieceColumn),
      write('2. Choose row to move the skier to\n'),
      write(PieceRow),nl,nl, % Debug
      write(PieceColumn),nl,nl, % Debug
      askRow(Board, lefty, PieceRow, PieceColumn, NewColumn),
      printBoard(UpdatedBoard).

gameLoop(Board, P1, P2) :-
      playerOneTurn(Board, FirstMoveBoard, P1),
      playerOneTurn(FirstMoveBoard, SecondMoveBoard, P2),
      gameLoop(SecondMoveBoard,P1, P2).

startGame(P1, P2) :-
      flush_output,
      newBoard(Board),
      addPieces(Board, UpdatedBoard, P1, P2),
      gameLoop(UpdatedBoard, P1, P2).