%% Will Holdsworth 1353032
%
% Implements puzzle_solution/1 which solves incomplete proper math puzzles and 
% validates complete proper math puzzles.
% 
% A math puzzle is a matrix with a size between 2 and 4. The first row and first
% column of the puzzle are reserved for totals, which should always be ground. A
% total is either the sum or the product of its respective row/column. The top 
% and left corner can be ignored. A puzzle can be incomplete, partially 
% complete, or complete. An incomplete/partially complete puzzle should have 
% "_" where the cell is empty. A proper math puzzle has at most one solution.
% 
% We approach puzzle validation via the clpfd library. We apply constraints to 
% the puzzle in order of restrictiveness. 
%
% First, we unify the main diagonal by ensuring all cells are the same.
% Second, we verify that the rows are valid. A valid row's cells should all be 
% digits from 1 to 9 (inclusive), contain only distinct digits. Also, a valid 
% row's head should be the sum or the product of the cells in the row.
% Finally, we take the transpose of the puzzle and apply the row validation 
% predicate to the puzzle again, this time effectively validting the columns.
%
% The resulting puzzle is labelled using the "first fail" strategy outlined in 
% the clpfd docs.


:- use_module(library(clpfd)).


%% puzzle_solution(+Puzzle)
%
% Holds when `Puzzle` is a solved math puzzle.
% See the top of this file for more information.
puzzle_solution(Puzzle) :-
  Puzzle = [_|Rows],
  unify_diagonal(Puzzle),
  maplist(valid_row, Rows),
  transpose(Puzzle, Transposed_puzzle),
  Transposed_puzzle = [_|Columns],
  maplist(valid_row, Columns).


%% unify_diagonal(+Puzzle)
%
% Holds when every variable in the main diagonal of `Puzzle` is the same.
unify_diagonal(Puzzle) :-
  main_diagonal(Puzzle, [_|Diag]),
  all_same(Diag).


%% main_diagonal(+Matrix, -Diag)
% 
% Holds when the list `Diag` is the main diagonal of the 2d list `Matrix`.
main_diagonal(Matrix, Diag) :-
  main_diagonal(Matrix, 0, Diag).

main_diagonal([], _, []).
main_diagonal([Row|Rows], Column, [D|Ds]) :-
  nth0(Column, Row, D),
  Next_column is Column + 1,
  main_diagonal(Rows, Next_column, Ds).


%% all_same(+Vars)
% 
% Holds when the variables in the list `Vars` can be unified 
all_same([Var|Vars]) :-
  all_same(Var, Vars).

all_same(Var, [Var]).
all_same(Var, [Var|Vars]) :-
  all_same(Var, Vars).


%% valid(+Row)
%
% Holds when `Row` is valid.
% A row is valid when:
%   1. All elements except the head are integers from 1 to 9 (inclusive)
%   2. All elements except the head are distinct 
%   3. The head of the row is either the sum or the product of the tail of `Row`
valid_row([Total|Vars]) :-
  Vars ins 1..9, 
  all_distinct(Vars),
  valid_total(Total, Vars),
  labeling([ff], Vars).


%% valid_total(+Total, +Vars)
%
% Holds when the integer `Total` is either the sum or the product of the list 
% `Vars`.
valid_total(Total, Vars) :-
  sum(Vars, #=, Total)
; product(Vars, Total).


%% product(+Vars, -Product)
%
% Holds when the integer `Product` is the product of the list `Vars`.
product(Vars, Product) :-
  foldl(times, Vars, 1, Product).


%% times(?Int1, ?Int2, ?Int3)
%
% Holds when Int3 #= Int1 * Int2.
times(Int1, Int2, Int3) :-
  Int3 #= Int1 * Int2.


