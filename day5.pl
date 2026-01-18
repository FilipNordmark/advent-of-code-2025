:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).
:- use_module(library(lists)).
:- use_module(library(apply)).


parseRange(L-H) --> number(L), "-", number(H), eol.
parseId(Id) --> integer(Id), eol.

parse(Ranges, Ids) --> sequence(parseRange, Ranges), eol, sequence(parseId, Ids), !.


inRange(Lo-Hi, Id) :- Id >= Lo, Id =< Hi.
inRanges(Ranges, Id) :- member(E, Ranges), inRange(E, Id).


mergeRanges(Ranges, Merged) :- keysort(Ranges, Sorted), Sorted = [H|T], mergeRanges(T, [H], Merged).

mergeRanges([], Merged, Merged).
mergeRanges([L-H|T], [L0-H0|T0], Merged) :- L =< H0, !, HMax is max(H, H0), mergeRanges(T, [L0-HMax|T0], Merged).
mergeRanges([H|T], T0, Merged) :- mergeRanges(T, [H|T0], Merged).


run(File) :-
    phrase_from_file(parse(Ranges, Ids), File),

    include(inRanges(Ranges), Ids, Fresh),
    length(Fresh, N),
    writeln(N),

    mergeRanges(Ranges, Merged),
    maplist([L-H, Len]>>(Len is H - L +1), Merged, Lengths),
    sum_list(Lengths, Sum),
    writeln(Sum).
