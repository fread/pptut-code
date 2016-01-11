del1([],_,[]).
del1([X|T1],X,L2):- !, del1(T1,X,L2).
del1([Y|T1],X,[Y|T2]) :- del1(T1,X,T2).

del2([],_,[]).
del2([X|T1],X,L2):- del2(T1,X,L2).
del2([Y|T1],X,[Y|T2]) :- del2(T1,X,T2), not(X=Y).

del3([X|L],X,L).
del3([Y|T1],X,[Y|T2]) :- del3(T1,X,T2).

%% del(L, 2, [1, 3]).
%% del([1, 2, 3], X, [1, 3]).
%% del([1, 2, 3, 2], X, [1, 3]).
%% del([1, 2, 3, 2], X, [1, 2, 3]).
%% del([1|L], 1, X).
