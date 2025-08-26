% Two = [[0,10,9],[11,_,_],[10,_,_]], puzzle_solution(Two).
% Three = [[0,14,10,35],[14,_,_,_],[15,_,_,_],[28,_,1,_]].

:- use_module(library(clpfd)).
:- use_module(library(apply)).


%% puzzle_solution(+Puzzle)
%
puzzle_solution(Puzzle) :-
  Puzzle = [_|Rows],
  unify_diagonal(Puzzle),
  maplist(valid_row, Rows),
  transpose(Puzzle, TransposedPuzzle),
  TransposedPuzzle = [_|Columns],
  maplist(valid_row, Columns).


%% valid(+Row)
%
valid_row([Head|Row]) :-
  Row ins 1..9, 
  all_distinct(Row),
  valid_head(Head, Row),
  label(Row).


%% valid_head(+Head, +Tail)
%
valid_head(Head, List) :-
  sum(List, #=, Head)
; product(List, Head).


%% product(+List, -Product)
%
product(List, Product) :-
  foldl(times, List, 1, Product).


%% times(?Int1, ?Int2, ?Int3)
%
% true if Int3 #= Int1 * Int2
times(Int1, Int2, Int3) :-
  Int3 #= Int1 * Int2.


%% unify_diagonal(+Puzzle)
%
unify_diagonal(Puzzle) :-
  main_diagonal(Puzzle, [_|Diag]),
  all_same(Diag).


%% main_diagonal(+Matrix, -Diag)
%
main_diagonal(Matrix, Diag) :-
  main_diagonal(Matrix, 0, Diag).

main_diagonal([], _, []).
main_diagonal([M|Ms], I, [D|Ds]) :-
  nth0(I, M, D),
  I1 is I + 1,
  main_diagonal(Ms, I1, Ds).


%% all_same(+List)
% 
all_same([Head|Tail]) :-
  all_same(Head, Tail).

all_same(X, [X]).
all_same(Head, [X|Xs]) :-
  Head #= X,
  all_same(Head, Xs).
   
