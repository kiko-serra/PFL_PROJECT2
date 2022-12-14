
addPieces(NewBoard, PiecesBoard, 'P', 'P') :-
      printBoard(NewBoard),
      write('\n------------------ PLAYER 1 -------------------\n\n'),
      write('1. Choose worker 1 cell.\n'),
      askCoords(NewBoard, red, Worker1Board, empty),
      printBoard(Worker1Board),
      write('\n------------------ PLAYER 2 -------------------\n\n'),
      write('1. Choose worker 2 cell.\n'),
      askCoords(Worker1Board, red, PiecesBoard, empty),
      printBoard(PiecesBoard).


startGame(P1, P2) :-
    newBoard(NewBoard),
    addPieces(NewBoard, PiecesBoard, P1, P2),
    gameLoop(PiecesBoard, P1, P2).