:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).
:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(assoc)).



parseRange(L-H) --> number(L), "-", number(H), eol.
parseId(Id) --> integer(Id), eol.

parse(Ranges, Ids) --> sequence(parseRange, Ranges), eol, sequence(parseId, Ids), !.


inRange(Lo-Hi, Id) :- Id >= Lo, Id =< Hi.

inRanges(Ranges, Id) :- member(E, Ranges), inRange(E, Id).

run(File) :-
    phrase_from_file(parse(Ranges, Ids), File),
    include(inRanges(Ranges), Ids, Fresh),
    length(Fresh, N),
    writeln(N).
