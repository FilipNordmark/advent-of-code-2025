:- use_module(library(dcg/basics)).
:- use_module(library(dcg/high_order)).
:- use_module(library(lists)).
:- use_module(library(apply)).
:- use_module(library(clpfd)).


parseLine(Parser, Ns) --> sequence(whites, call(Parser), (" ", whites), blanks_to_nl, Ns), { Ns = [_|_]}.

parseOperator(+) --> "+".
parseOperator(*) --> "*".

parse(Nums, Ops) --> sequence(parseLine(integer), Nums), parseLine(parseOperator, Ops).


applyOperator(+, List, Res) :- sum_list(List, Res).
applyOperator(*, List, Res) :- foldl([X, Y, Z]>>(Z is X * Y), List, 1, Res).

run(File) :-
    phrase_from_file(parse(Nums, Ops), File),
    transpose(Nums, Transp),
    maplist(applyOperator, Ops, Transp, Results),
    sum_list(Results, Res),
    writeln(Res).
