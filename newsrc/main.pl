:- consult('main_menu.pl').
:- consult('board.pl').
:- consult('game_logic.pl').
:- consult('input.pl').
:- use_module(library(lists)).
:- use_module(library(aggregate)).

play :-
    mainMenu.