:- use_module(library(dcg/basics)).
:- use_module(library(lists)).

parseBank(Cs) --> digits(Cs), {Cs = [_|_], !}.

parseBanks([Ns|Nss]) --> parseBank(Ns), !, blanks_to_nl, parseBanks(Nss).
parseBanks([]) --> {true}.

maxJoltage(Ns, M) :- maxRest(Ns, Max, Rest), max_list(Rest, RestMax), number_chars(M, [Max, RestMax]).

maxJoltage(N, Ns, Max) :-
    length(Ms, N),
    findall(Ms, subseq(Ns, Ms, _), SubLists),
    maplist(number_chars, Nums, SubLists),
    max_list(Nums, Max).


% maxRest(List, Max, RestBest)
maxRest([N|Ns], Max, Rest) :- maxRest(Ns, N, Ns, Max, Rest).

maxRest([_], Max, Rest, Max, Rest).
maxRest([N|Ns], MaxC, _, Max, Rest) :- N > MaxC, maxRest(Ns, N, Ns, Max, Rest).
maxRest([N|Ns], MaxC, RestC, Max, Rest) :- N =< MaxC, maxRest(Ns, MaxC, RestC, Max, Rest).

% maxRest(Count, Rest, Res)
maxRest(0, RestC, _, RestC).
maxRest(C, [MaxC|_], [N|Ns], Res) :- N > MaxC, C1 is C - 1, maxRest(C1, [N|Ns], Ns, Res).
maxRest(C, [MaxC|RestC], [N|Ns], Res) :- N =< MaxC, C1 is C - 1, maxRest(C1, [MaxC|RestC], Ns, Res).


takeBest12(Ns, N) :- takeBestN(12, Ns, Res), number_chars(N, Res).

takeBestN(0, _, []).
takeBestN(NTake, Ns, [Max|Res]) :-
    length(Ns, Len),
    C is Len - NTake + 1,
    maxRest(C, Ns, Ns, [Max|Rem]),
    NTake1 is NTake - 1,
    takeBestN(NTake1, Rem, Res).



run1(File) :-
    phrase_from_file(parseBanks(Banks), File),
    maplist(maxJoltage, Banks, Joltage1), sum_list(Joltage1, Answer1), writeln(Answer1),
    maplist(takeBest12, Banks, Joltage2), sum_list(Joltage2, Answer2), writeln(Answer2).
