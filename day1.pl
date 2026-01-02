:- use_module(library(dcg/basics)).


parseLine(left(R))  --> "L", number(R).
parseLine(right(R)) --> "R", number(R).

parseLines([X|Xs]) --> parseLine(X), !, blanks_to_nl, parseLines(Xs).
parseLines([]) --> "".




positionHelp(left(X), Initial, (End, Rotations)) :- End is mod(Initial - X, 100), Rotations is div(mod(100 - Initial, 100) + X, 100).
positionHelp(right(X), Initial, (End, Rotations)) :- End is mod(Initial + X, 100), Rotations is div(Initial + X, 100).

position(X, Initial, End) :- positionHelp(X, Initial, (End, _)).


positions(Initial, Inputs, Positions) :- scanl(position, Inputs, Initial, Positions).


run1(File, Answer) :-
    phrase_from_file(parseLines(Rotations), File),
    positions(50, Rotations, Xs),
    include(=(0), Xs, Ys),
    length(Ys, Answer).




rotations(_, [], []).
rotations(Initial, [I|Is], [R|Rs]) :- positionHelp(I, Initial, (End, R)), rotations(End, Is, Rs).

run2(File, Answer) :-
    phrase_from_file(parseLines(Rotations), File),
    rotations(50, Rotations, Rs),
    sumlist(Rs, Answer).
