# Project 1: Maths Puzzles

## Math Puzzle
- each digit must be 1-9
- each row contains no repeated digit
- each column contains no repeated digit
- all squares on the diagonal line from top left corner to bottom right corner must contain the same value
- the heading of each row holds either:
    - the sum of all the digits in that row
    - the product of all the digits in that row
- the heading of each column holds either:
    - the sum of all the digits in that column
    - the product of all the digits in that column

## Input
A math puzzle with most/all squares empty **except** for the headings

## Solution

### Structure
A predicate `puzzle_solution/1` which holds when the argument is a solved math puzzle

### Approach
Utilise constraint logic programming
1. unify all squares on the diagonal
2. check rows are valid
    1. all distinct
    2. sum to heading
    3. product to head
3. check columns are valid via `transpose/2` 
