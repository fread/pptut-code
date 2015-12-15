ufer(links).
ufer(rechts).

%% (M, Z, W, K)
erlaubt((M, Z, W, K)) :-
    ufer(M), ufer(Z), ufer(W), ufer(K),
    M = Z.
erlaubt((M, Z, W, K)) :-
    ufer(M), ufer(Z), ufer(W), ufer(K),
    Z \== W, Z \== K.


%% fahrt(Start, Beschreibung, Ziel)
fahrt((M, Z, W, K), leer, (M2, Z, W, K)) :-
    ufer(M), ufer(M2),
    M \== M2.
fahrt((MZ, MZ, W, K), ziege, (MZ2, MZ2, W, K)) :-
    ufer(MZ), ufer(MZ2),
    MZ \== MZ2.
fahrt((MW, Z, MW, K), wolf, (MW2, Z, MW2, K)) :-
    ufer(MW), ufer(MW2),
    MW \== MW2.
fahrt((MK, Z, W, MK), kohl, (MK2, Z, W, MK2)) :-
    ufer(MK), ufer(MK2),
    MK \== MK2.

erreichbar(Start, Besucht, [], Start).
erreichbar(Start, Besucht, [F|Weg], Ziel) :-
    erlaubt(Start), erlaubt(Ziel),
    fahrt(Start, F, X),
    not(member(X, Besucht)),
    erreichbar(X, [X|Besucht], Weg, Ziel).
