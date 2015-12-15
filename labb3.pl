% check(T,L,S,U,F)
% satisfies(T,L,U,F,S)
children(T,S,R):-
    memberchk([S,R],T).

properties(L,S,R):-
    memberchk([S,R],L).

every(_,_,_,_,[]).
every(T,L,U,F,[S|Ss]):-
    satisfies(T,L,U,F,S),
    every(T,L,U,F,Ss).

%some(_,_,_,_,[]).
some(T,L,U,F,[S|Ss]):-
    satisfies(T,L,U,F,S);
    some(T,L,U,F,Ss).

satisfies(T,L,U,ax(F),S):-
    children(T,S,R),
    every(T,L,[],F,R).
satisfies(T,L,U,ex(F),S):-
    children(T,S,R),
    some(T,L,[],F,R).

satisfies(T,L,U,eg(F),S):-
    eg1(T,L,U,F,S);
    eg2(T,L,U,F,S).

satisfies(T,L,U,ag(F),S):-
    ag1(T,L,U,F,S);
    ag2(T,L,U,F,S).

satisfies(T,L,U,af(F),S):-
    af1(T,L,U,F,S);
    af2(T,L,U,F,S).

satisfies(T,L,U,ef(F),S):-
    ef1(T,L,U,F,S);
    ef2(T,L,U,F,S).

satisfies(T,L,U,neg(Atom),S):-
    properties(L,S,R),
    \+ memberchk(Atom,R).
satisfies(T,L,U,or(X,Y),S):-
    or1(T,L,U,X,S);
    or2(T,L,U,Y,S).
satisfies(T,L,U,and(X,Y),S):-
    satisfies(T,L,[],X,S),
    satisfies(T,L,[],Y,S).
satisfies(T,L,U,Atom,S):-
    properties(L,S,R),
    memberchk(Atom,R).

or1(T,L,U,F,S):-
    satisfies(T,L,[],F,S).
or2(T,L,U,F,S):-
    satisfies(T,L,[],F,S).
ef1(T,L,U,F,S):-
    \+ memberchk(S,U),
    satisfies(T,L,[],F,S).
ef2(T,L,U,F,S):-
    \+ memberchk(S,U),
    children(T,S,R),
    some(T,L,[S|U],ef(F),R).
af1(T,L,U,F,S):-
    \+ memberchk(S,U),
    satisfies(T,L,[],F,S).
af2(T,L,U,F,S):-
    \+ memberchk(S,U),
    children(T,S,R),
    every(T,L,[S|U],af(F),R).

ag1(T,L,U,F,S):-
    memberchk(S,U).
ag2(T,L,U,F,S):-
    \+ memberchk(S,U),
    satisfies(T,L,[],F,S),
    children(T,S,R),
    every(T,L,[S|U],ag(F),R).

eg1(T,L,U,F,S):-
    memberchk(S,U).
eg2(T,L,U,F,S):-
    \+ memberchk(S,U),
    satisfies(T,L,[],F,S),
    children(T,S,R),
    some(T,L,[S|U],eg(F),R).
    
	
verify(Input) :-
    see(Input), read(T), read(L), read(S), read(F), seen,
    check(T, L, S, [], F).

check(T,L,S,U,F):-
    satisfies(T,L,U,F,S).
