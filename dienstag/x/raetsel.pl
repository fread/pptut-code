% Solution = [[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]]
% [BuchOderFilm, Sprache, Spiel, Name]

% indexOf(X, L, N).
indexOf(X, [X|Rest], 0).
indexOf(X, [Y|Rest], N) :- indexOf(X, Rest, M), N is M + 1.

links(T1, T2, L) :- indexOf(T1, L, N1), indexOf(T2, L, N2), N1 < N2.
rechts(T1, T2, L) :- indexOf(T1, L, N1), indexOf(T2, L, N2), N1 > N2.
benachbart(T1, T2, L) :- indexOf(T1, L, N1), indexOf(T2, L, N2), 1 is abs(N1 - N2).


%% 1.) Der Tutor, dessen Lieblingsbuch Per Anhalter durch die Galaxis ist, befindet sich links von dem Tutor, der am liebsten in Java programmiert.
clue1(L) :- links([anhalter, _, _, _], [_, java, _, _], L).

%% 2.) Der Tutor, der gern Portal spielt, befindet sich links von dem Tutor der gern in Ceylon programmiert.
clue2(L) :- links([_, _, portal, _], [_, ceylon, _, _], L).

%% 3.) Mindestens ein Tutor steht zwischen Andreas und dem Tutor der gern Tiny Tiger spielt.
clue3(L) :-
    indexOf([_, _, _, andreas], L, N1),
    indexOf([_, _, tinytiger, _], L, N2),
    abs(N1 - N2) >= 2.

%% 4.) Mindestens ein Tutor befindet sich rechts von dem Tutor, der gern Donkey Kong Country spielt, und links von dem Tutor, der Fan von Game Of Thrones ist.
clue4(L) :- T = [_, _, _, _],
	    rechts(T, [_, _, donkeykong, _], L),
	    links(T, [gameofthrones, _, _, _], L).

%% 5.) Der Tutor, der am liebsten in C\# programmiert, steht direkt neben dem Tutor, der gern Tiny Tiger spielt.
clue5(L) :- benachbart([_, csharp, _, _], [_, _, tinytiger, _], L).

%% 6.) Der Tutor, der gern Anathem liest, steht direkt links neben Jonas.
clue6(L) :- links([anathem, _, _, _], [_, _, _, jonas], L),
	    benachbart([anathem, _, _, _], [_, _, _, jonas], L).

%% 7.) Zwischen dem OCaml-Programmierer und Michael stehen genau zwei Tutoren.
clue7(L) :-
    indexOf([_, ocaml, _, _], L, N1),
    indexOf([_, _, _, michael], L, N2),
    3 is abs(N1 - N2).

%% 8.) Der Tutor, der direkt rechts neben Lucas steht, spielt gern Broforce.
clue8(L) :- rechts([_, _, broforce, _], [_, _, _, lukas], L),
	    benachbart([_, _, broforce, _], [_, _, _, lukas], L).

%% 9.) Derjenige Tutor, dessen Lieblingsfilm Pulp Fiction ist, spielt gern Donkey Kong Country.
clue9(L) :- indexOf([pulpfiction, _, donkeykong, _], L, _).

solution(L) :-
    L = [[_,_,_,_],[_,_,_,_],[_,_,_,_],[_,_,_,_]],
    clue1(L),
    clue2(L),
    clue3(L),
    clue4(L),
    clue5(L),
    clue6(L),
    clue7(L),
    clue8(L),
    clue9(L).
