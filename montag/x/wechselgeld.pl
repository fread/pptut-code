% [(50, 2), (20, 2), (10, 1), (5, 3)]

% remove(Vorher, Muenze, Nachher)
remove([(M, N) | Rest], M, [(M, N1) | Rest]) :- N > 0, N1 is N - 1.
remove([M1 | Rest], M, [M1 | X]) :- remove(Rest, M, X).
% Für change ohne doppelte Möglichkeiten:
% remove([M1 | Rest], M, X) :- remove(Rest, M, X).

% put(Vorher, Muenze, Nachher)
put([(M, N) | Rest], M, [(M, N1) | Rest]) :- N1 is N + 1, !.
put([MN | Rest], M, [MN | X]) :- put(Rest, M, X).
put([], M, [(M, 1)]).

% change(Vorrat, Betrag, Ausgabe)
change(_, 0, []).
change(Vorrat, Betrag, Ausgabe) :-
    remove(Vorrat, M, VorratRest),
    M =< Betrag,
    BetragRest is Betrag - M,
    change(VorratRest, BetragRest, AusgabeRest),
    put(AusgabeRest, M, Ausgabe).
