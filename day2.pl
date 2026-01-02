:- use_module(library(dcg/basics)).
:- use_module(library(apply)).
:- use_module(library(lists)).
:- use_module(library(pure_input)).



parseRange(Lower, Higher)  --> number(Lower), "-", number(Higher).

parseRanges([(L, H)|LHs]) --> parseRange(L, H), ",", !, parseRanges(LHs).
parseRanges([(L, H)]) --> parseRange(L, H), blanks_to_nl.
parseRanges([]) --> blanks_to_nl.


specialPattern(XX) :- number(XX), !, number_codes(XX, XXCode), specialPattern(XXCode).
specialPattern(XX) :-
    length(XX, M), 0 is mod(M, 2),
    append(X, X, XX).

idsInRange((Low, High), Ids) :- idsInRange(Low, High, Ids).
idsInRange(Low, High, Ids) :- findall(N, (between(Low, High, N), specialPattern(N)), Ids).


run1(File, Answer) :-
    phrase_from_file(parseRanges(Rs), File),
    maplist(idsInRange, Rs, Ids),
    append(Ids, Idss),
    sum_list(Idss, Answer).



idsInRange2((Low, High), Ids) :- idsInRange2(Low, High, Ids).
idsInRange2(Low, High, Ids) :- findall(N, (between(Low, High, N), specialPattern2(N, _)), Ids).


specialPattern2(XX, R) :- number(XX), !, number_codes(XX, XXCode), specialPattern2(XXCode, R).
specialPattern2(Xs, Ys) :-
    prefix(X, Xs),
    length(Xs, Len),
    length(X, PreLen), PreLen > 0, Len =\= PreLen,
    0 is rem(Len, PreLen), Div is div(Len, PreLen),
    length(Ys, Div),
    maplist(=(X), Ys),
    append(Ys, Xs),
    !.


run2(File, Answer) :-
    phrase_from_file(parseRanges(Rs), File),
    maplist(idsInRange2, Rs, Ids),
    append(Ids, Idss),
    sum_list(Idss, Answer).
