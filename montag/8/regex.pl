%% eps --> []
%% a --> [a]
%% u(X, Y) --> X oder Y
%% ·(X, Y) --> X ++ Y
%% *(X) --> 0 oder mehr X

%% *(X) --> [] oder s1 ++ s2, wobei s1 /= [], (X --> S1), (*(X) --> S2)

%% matches(Regex, Liste)

matches(eps, []).
matches(X, [X]) :- atom(X), not(X = eps).

matches(u(X, Y), Z) :- matches(X, Z); matches(Y, Z).
matches(·(X, Y), Z) :- matches(X, Xm), matches(Y, Ym), append(Xm, Ym, Z).
matches(*(_), []).
matches(*(X), Z) :- append(Z1, Z2, Z), Z1 \== [], matches(X, Z1), matches(*(X), Z2).
