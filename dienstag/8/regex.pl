%% eps --> []
%% a --> [a]
%% u(A, B) --> A oder B
%% ·(A, B) --> A dann B
%% *(A) --> A 0 oder öfter mal

%% matches(Regex, Pattern)
matches(eps, []).
matches(X, [X]) :- atom(X), not(X = eps).
matches(u(A, _), Y) :- matches(A, Y).
matches(u(_, B), Y) :- matches(B, Y).
matches(·(A, B), Y) :- append(Y1, Y2, Y), matches(A, Y1), matches(B, Y2).
matches(*(_), []).
matches(*(A), Y) :- append(Y1, Y2, Y), not(Y1 = []), matches(A, Y1), matches(*(A), Y2).
