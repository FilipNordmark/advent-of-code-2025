:- use_module(library(dcg/basics)).
:- use_module(library(lists)).
:- use_module(library(apply)).

parseLines([]) --> eos.
parseLines([C|Cs]) --> string_without("\n", C), "\n", string_without("\n", _), "\n", parseLines(Cs).


% '.' -> 46, 'S' -> 83, '^' -> 94

fallThrough([X, 94, Z|T], [83, 46, 83|T]) :- !.
fallThrough([X, Y, Z|T], [X, 83, Z|T]).

iterate([], In, In).
iterate([83|T], In, [Done|Rest]) :- !, fallThrough(In, [Done|In0]), iterate(T, In0, Rest).
iterate([_|T], [Done|In], [Done|Rest]) :- iterate(T, In, Rest).


hit(83, 94).

run(File) :-
    phrase_from_file(parseLines([H|Ls]), File),
    scanl([Spliter, [_|Laser], Next]>>iterate(Laser, Spliter, Next), Ls, H, Lasers),
    append(LasersExceptLast, [_], Lasers),
    maplist(maplist([Laser, Spliter, Hit]>>(hit(Laser, Spliter) -> Hit = 1 ; Hit = 0)), LasersExceptLast, Ls, Hits),
    maplist(sum_list, Hits, NrHits),
    sum_list(NrHits, N),
    write(N).
