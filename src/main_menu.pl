mainMenu :-
    printMainMenu,
    askOption,
    read(Input),
    manageOption(Input).

askOption :-
    write('> Insert your option\n --> ').

manageOption(1) :-
    startGame('P','P'),
    mainMenu.

manageOption(2) :-
    startGame('P','C'),
    mainMenu.

manageOption(3) :-
    startGame('C','C'),
    mainMenu.

manageOption(0) :-
    write('\nExiting. Thank you for playing Ski Jumps\n\n').

manageOption(_Other) :-
    write('\nERROR: that option does not exist.\n\n'),
    askOption,
    read(Input),
    manageOption(Input).

printMainMenu :-
    nl,nl,
    write('======================================================='),nl,nl,
    write('               Welcome to SKI JUMPS'),nl,nl,
    write('            ---------------------------'),nl,nl,nl,
    write('               1. Player vs Player'),nl,nl,
    write('               2. Player vs Computer'),nl,nl,
	write('               3. Computer vs Computer'),nl,nl,
    write('               0. Exit'),nl,nl,
    write('======================================================='),nl,nl,nl.
