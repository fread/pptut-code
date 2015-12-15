ufer(links).
ufer(rechts).

%% (M, Z, W, K)
erlaubt((M, Z, W, K)) :-
    ufer(M), ufer(Z), ufer(W), ufer(K),
    M = Z.
erlaubt((M, Z, W, K)) :-
    ufer(M), ufer(Z), ufer(W), ufer(K),
    Z \== K, W \== Z.

ueberfahrt(links, rechts).
ueberfahrt(rechts, links).

%%fahrt(Start, Beschreibung, Ziel).
fahrt((M, Z, W, K), leer, (M2, Z, W, K)) :-
    ueberfahrt(M, M2).
fahrt((MZ, MZ, W, K), ziege, (MZ2, MZ2, W, K)) :-
    ueberfahrt(MZ, MZ2).
fahrt((MW, Z, MW, K), wolf, (MW2, Z, MW2, K)) :-
    ueberfahrt(MW, MW2).
fahrt((MK, Z, W, MK), kohl, (MK2, Z, W, MK2)) :-
    ueberfahrt(MK, MK2).


erreichbar(Start, _, [], Start).
erreichbar(Start, Besucht, [F|Fahrten2], Ziel) :-
    fahrt(Start, F, X),
    erlaubt(X),
    not(member(X, Besucht)),
    erreichbar(X, [Start|Besucht], Fahrten2, Ziel).
