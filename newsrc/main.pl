:- consult('main_menu.pl').
:- consult('game_logic.pl').
:- use_module(library(lists)).
:- use_module(library(aggregate)).
:- use_module(library(random)).

play :-
    main_menu.