% check(T,L,S,U,F)
% satisfies(T,L,U,F,S)
children(T,S,R):-
    member([S,R],T).

properties(L,S,R):-
    member([S,R],L).

unvisited(T,S,U,R):-
    children(T,S,R1),
    remove_duplicates(U,R1,R).

remove_duplicates(L1,L2,R):-
    append(L1,L2,L3),
    rem_dups(L3,[],R).
rem_dups([],Acc,Acc).
rem_dups([H|T],Acc,R):-
    (memberchk(H,T),delete(T,H,N),rem_dups(N,Acc,R));
    rem_dups(T,[H|Acc],R).

some(_C_2, []).
some( C_2, [X|Xs]) :-
   ( call(C_2, X) );
   ( some(C_2, Xs) ).

every(_C_2, []).
every( C_2, [X|Xs]) :-
    call(C_2, X),
    every(C_2, Xs).

satisfies(T,L,U,ax(F),S):-
    unvisited(T,S,U,R),
    every(satisfies(T,L,U,F),R).
satisfies(T,L,U,ex(F),S):-
    unvisited(T,S,U,R),
    some(satisfies(T,L,U,F),R).

satisfies(T,L,U,eg(F),S):-
    unvisited(T,S,U,R),
    satisfies(T,L,U,F,S),
    some(satisfies(T,L,[S|U],eg(F)),R).
satisfies(T,L,U,ag(F),S):-
    unvisited(T,S,U,R),
    satisfies(T,L,U,F,S),
    every(satisfies(T,L,[U|S],ag(F)),R).

satisfies(T,L,U,af(F),S):-
    unvisited(T,S,U,R),
    every(recur_af(T,L,[S|U],F),R).
satisfies(T,L,U,ef(F),S):-
    unvisited(T,S,U,R),
    some(recur_ef(T,L,[S|U],F),R).

satisfies(T,L,U,neg(F),S):-
    \+ satisfies(T,L,U,F,S).
satisfies(T,L,U,or(X,Y),S):-
    satisfies(T,L,U,X,S);
    satisfies(T,L,U,Y,S).
satisfies(T,L,U,and(X,Y),S):-
    satisfies(T,L,U,X,S),
    satisfies(T,L,U,Y,S).
satisfies(T,L,U,Atom,S):-
    properties(L,S,R),
    memberchk(Atom,R).

recur_ef(T,L,U,F,S):-
    satisfies(T,L,U,F,S);
    satisfies(T,L,[S|U],ef(F),S).
recur_af(T,L,U,F,S):-
    satisfies(T,L,U,F,S);
    satisfies(T,L,[S|U],af(F),S).

verify(Input) :-
    see(Input), read(T), read(L), read(S), read(F), seen,
    check(T, L, S, [], F).

check(T,L,S,U,F):-
    satisfies(T,L,U,F,S).
