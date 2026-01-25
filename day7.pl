:- use_module(library(pio)).
:- use_module(library(lists)).
:- use_module(library(assoc)).
:- use_module(library(lambda)).
:- use_module(library(tabling)).

parseLines([T|Ts]) --> parseLine(0, P), !, {list_to_assoc(P, T)}, seq(_), "\n", !, parseLines(Ts).
parseLines([]) --> "".


parseLine(_, []) --> "\n".
parseLine(N, T) --> ".", {N1 is N + 1}, parseLine(N1, T).
parseLine(N, [N-1|T]) --> [C], {member(C, "S^"), N1 is N + 1}, parseLine(N1, T).


iterateN(In, L, Out) :- empty_assoc(Out0), assoc_to_list(L, Pairs), iterateN(In, Pairs, Out0, Out).

iterateN(_, [], Out, Out).
iterateN(In, [I-N|Ns], Out0, Out) :- get_assoc(I, In, _), !, Il is I - 1, Ir is I + 1, addOrInsert(Il, Out0, N, Out1), addOrInsert(Ir, Out1, N, Out2), iterateN(In, Ns, Out2, Out).
iterateN(In, [I-N|Ns], Out0, Out) :- \+ get_assoc(I, In, _), !, addOrInsert(I, Out0, N, Out1), iterateN(In, Ns, Out1, Out).

addOrInsert(I, In, N, Out) :-
    (   get_assoc(I, In, M) -> N0 is M + N, put_assoc(I, In, N0, Out)
    ;   put_assoc(I, In, N, Out)
    ).

hit(83, 94).

run(File) :-
    phrase_from_file(parseLines([L|Ls]), File),
    foldl(iterateN, Ls, L, Out),
    assoc_to_values(Out, Vals),
    sum_list(Vals, Sum),
    write(Sum).
