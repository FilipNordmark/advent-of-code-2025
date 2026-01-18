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



% 32 is space ' '
padToSameLength([], [], []).
padToSameLength([_|Ls], [], [32|Rest]) :- padToSameLength(Ls, [], Rest).
padToSameLength([_|Ls], [R|Rs], [R|Rest]) :- padToSameLength(Ls, Rs, Rest).


parseNumbers([]) --> blanks_to_nl.
parseNumbers([N|Ns]) --> blanks, integer(N), blanks_to_nl, parseNumbers(Ns).


parseCollumn((Op, [N|Ns])) --> blanks, integer(N), whites, parseOperator(Op), blanks, parseNumbers(Ns).

run2(File) :-
    phrase_from_file(sequence(string_without("\n"), "\n", Rows), File),
    Rows = [H|_],
    maplist(padToSameLength(H), Rows, PaddedRows),
    transpose(PaddedRows, Colls),
    maplist([List, List0]>>append(List,`\n`, List0), Colls, Colls0),
    flatten(Colls0, Codes),
    phrase(sequence(parseCollumn, Problems), Codes),
    maplist([(Op, Nums), Res]>>(applyOperator(Op, Nums, Res)), Problems, Results),
    sum_list(Results, Sum),
    writeln(Sum).
