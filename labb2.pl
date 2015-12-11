% check(T,L,S,U,F)
% satisfies(T,L,U,F,S)
children(T,S,R):-
    member([S,R],T).

properties(L,S,R):-
    member([S,R],L).

unvisited(T,S,U,R):-
    children(T,S,R1),
    remove_duplicates(U,R1,R).

%Implementera remove_duplicates
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
every(C_2, [X|Xs]) :-
    call(C_2, X),
    every(C_2, Xs).

accumulating_every(_,_,_,_,[]).
accumulating_every(T,L,U,F,[S|Ss]):-
    satisfies(T,L,U,F,S),
    accumulating_every(T,L,[S|U],F,Ss).

accumulating_some(_,_,_,_,[]).
accumulating_some(T,L,U,F,[S|Ss]):-
    satisfies(T,L,U,F,S);
    accumulating_every(T,L,[S|U],F,Ss).


satisfies(T,L,U,ax(F),S):-
    unvisited(T,S,U,R),
    accumulating_every(satisfies(T,L,U,F),R).
satisfies(T,L,U,ex(F),S):-
    unvisited(T,S,U,R),
    accumulating_some(satisfies(T,L,U,F),R).
satisfies(T,L,U,eg(F),S):-
    unvisited(T,S,U,R),
    satisfies(T,L,[],F,S),
    accumulating_some(T,L,[S|U],eg(F),R).
satisfies(T,L,U,ag(F),S):-
    every(go_into_ag(T,L,[],F),T).
satisfies(T,L,U,af(F),S):-
    unvisited(T,S,U,R),
    every(recur_af(T,L,[S|U],F),R).
satisfies(T,L,U,ef(F),S):-
    unvisited(T,S,U,R),
    some(recur_ef(T,L,[S|U],F),R).

satisfies(T,L,U,neg(F),S):-
    \+ satisfies(T,L,U,F,S).
satisfies(T,L,U,or(X,Y),S):-
    satisfies(T,L,[],X,S);
    satisfies(T,L,[],Y,S).
satisfies(T,L,U,and(X,Y),S):-
    satisfies(T,L,[],X,S),
    satisfies(T,L,[],Y,S).
satisfies(T,L,U,Atom,S):-
    properties(L,S,R),
    memberchk(Atom,R).


go_into_ag(T,L,U,F,[S,_]):-
    satisfies(T,L,U,F,S).
recur_ef(T,L,U,F,S):-
    satisfies(T,L,[],F,S);
    satisfies(T,L,U,ef(F),S).
recur_af(T,L,U,F,S):-
    satisfies(T,L,[],F,S);
    satisfies(T,L,U,af(F),S).

verify(Input) :-
    see(Input), read(T), read(L), read(S), read(F), seen,
    check(T, L, S, [], F).

check(T,L,S,U,F):-
    satisfies(T,L,U,F,S).
