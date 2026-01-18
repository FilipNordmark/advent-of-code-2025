:- use_module(library(dcg/basics)).
:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(assoc)).


buildDict(_, _, []) --> eos, !.
buildDict(Y, _, XYs) --> eol, !, {Y1 is Y + 1}, buildDict(Y1, 0, XYs).
buildDict(Y, X, [(X, Y)-1|XYs]) --> `@`, !, {X1 is X + 1}, buildDict(Y, X1, XYs).
buildDict(Y, X, XYs) --> [_], !, {X1 is X + 1}, buildDict(Y, X1, XYs).

buildDict(Assoc) --> buildDict(0, 0, XYs), {list_to_assoc(XYs, Assoc)}.

arround(X, Y, X1, Y1) :- X1 is X - 1, Y1 is Y + 1.
arround(X, Y, X, Y1) :- Y1 is Y + 1.
arround(X, Y, X1, Y1) :- X1 is X + 1, Y1 is Y + 1.
arround(X, Y, X1, Y) :- X1 is X - 1.
arround(X, Y, X1, Y) :- X1 is X + 1.
arround(X, Y, X1, Y1) :- X1 is X - 1, Y1 is Y - 1.
arround(X, Y, X, Y1) :- Y1 is Y - 1.
arround(X, Y, X1, Y1) :- X1 is X + 1, Y1 is Y - 1.


getNeighbours(Dict, X, Y, Bag) :- findall((X1, Y1), (arround(X, Y, X1, Y1), get_assoc((X1, Y1), Dict, _)), Bag).
nrNeighbour(Dict, X, Y, N) :- getNeighbours(Dict, X, Y, Bag), length(Bag, N).

accessiblePosition(Dict, (X, Y)) :- nrNeighbour(Dict, X, Y, N), N < 4.
notAccessiblePosition(Dict, (X, Y)) :- nrNeighbour(Dict, X, Y, N), N >= 4.

nrRolls(Dict, N) :- assoc_to_list(Dict, List), length(List, N).

iterateRolls(Dict, Dict1) :-
    assoc_to_keys(Dict, Keys),
    convlist({Dict}/[K, K-1]>>notAccessiblePosition(Dict, K), Keys, Remaining),
    list_to_assoc(Remaining, Dict1).

iterateUntilStable(Iter, Start, End) :- call(Iter, Start, Next), (Next = Start -> End = Start ; iterateUntilStable(Iter, Next, End)).

run(File) :-
    phrase_from_file(buildDict(D), "day4Input.txt"),
    iterateRolls(D, D1),
    nrRolls(D, NBeg),
    nrRolls(D1, NFirst),
    Res is NBeg - NFirst,
    writeln(Res),

    iterateUntilStable(iterateRolls, D1, DN),
    nrRolls(DN, NLast),
    Res1 is NBeg - NLast,
    writeln(Res1).
