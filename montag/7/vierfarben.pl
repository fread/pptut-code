farbe(gelb).
farbe(rot).
farbe(gruen).
farbe(blau).

nachbar(X, Y) :- farbe(X), farbe(Y), X \== Y.

deutschland(O2, O3, O4, O5, O6, O7, O8, O9) :-
    nachbar(O1, O2), nachbar(O1, O3), nachbar(O1, O4), nachbar(O1, O5),
        nachbar(O1, O6), nachbar(O1, O7), nachbar(O1, O8), nachbar(O1, O9),
    nachbar(O2, O5), nachbar(O2, O6),
    nachbar(O3, O4), nachbar(O3, O5), nachbar(O3, O6), nachbar(O3, O9),
    nachbar(O4, O5),
    nachbar(O5, O6),
    nachbar(O6, O7), nachbar(O6, O9),
    nachbar(O7, O8), nachbar(O7, O9),
    nachbar(O8, O9).


mathematisch(x).
mathematisch(y).
mathematisch(z).
mathematisch(X + Y) :- mathematisch(X), mathematisch(Y).
