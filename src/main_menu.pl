main_menu :-
    clear_data,
    printmain_menu,
    askOption,
    read(Input),
    manage_option(Input).

askOption :-
    write('> Insert your option\n --> ').

manage_option(1) :-
    manage_side(1),
    manage_side(2),
    play_game(0),
    main_menu.

manage_option(2) :-
    side,
    level(Level),
    play_game(Level),
    main_menu.

manage_option(3) :-
    level(P1Level),
    level(P2Level),
    levels(P1Level, P2Level, Level),
    play_game(Level),
    main_menu.

manage_option(0) :-
    write('\nExiting. Thank you for playing Ski Jumps\n\n').

manage_option(_Other) :-
    write('\nERROR: that option does not exist.\n\n'),
    askOption,
    read(Input),
    manage_option(Input).

level(Level) :-
    repeat,
    write('What difficulty do you wish the computer to be?'),nl,
    write('1. Easy.'),nl,
    write('2. Hard.'),nl,
    read(Level),
    (   
        manage_level(Level)
    ;   write('\nERROR: that option does not exist.\n\n'),
        fail
    ).


side :-
    repeat,
    write('What side you wish to play?'),nl,
    write('1. Red side.'),nl,
    write('2. Black side.'),nl,
    read(Side),
    (   
        manage_side(Side)
    ;   write('\nERROR: that option does not exist.\n\n'),
        fail
    ).



manage_side(1) :-
    assertz(player(p1)).

manage_side(2) :-
    assertz(player(p2)).

manage_level(1).
manage_level(2).

levels(1,1,11).
levels(2,1,21).
levels(1,2,12).
levels(2,2,22).

    

printmain_menu :-
    nl,nl,
    write('======================================================='),nl,nl,
    write('               Welcome to SKI JUMPS'),nl,nl,
    write('            ---------------------------'),nl,nl,nl,
    write('               1. Player vs Player'),nl,nl,
    write('               2. Player vs Computer'),nl,nl,
	write('               3. Computer vs Computer'),nl,nl,
    write('               0. Exit'),nl,nl,
    write('======================================================='),nl,nl,nl.
