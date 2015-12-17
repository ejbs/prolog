% States are s0 (Avstängt), s1 (Spelet startat), %     s2 (Åskåda pågående match), s3 (Lobby), s4 (Spelar)
% Adjacency lists of LTS
[
   [s0, [s1]],
   [s1, [s0, s2, s3]],
   [s2, [s0, s1]],   [s3, [s0, s1, s4]],   [s4, [s0, s3]]].
% Labeling of LTS (På as p, Inloggad as q, I spelet as r)
[
   [s0, []],
   [s1, [p]],
   [s2, [p,r]],
   [s3, [p,q]],
   [s4, [p,q,r]]
].
%Antingen är man inloggad och det finns ett sätt att logga ut eller så finns det ett sätt att logga in.
check([[s0, [s1]],
       [s1, [s0, s2, s3]],
       [s2, [s0, s1]],   [s3, [s0, s1, s4]],   [s4, [s0, s3]]]
      % Labeling of LTS (På as p, Inloggad as q, I spelet as r)
      ,[[s0, []],
	[s1, [p]],
	[s2, [p,r]],
	[s3, [p,q]],
	[s4, [p,q,r]]], s0, [], or(and(l,ef(neg(q)),ef(q))).

%Alla vägar för att komma in i spelet kräver att man loggat in, annars är spelet avstängt
check([[s0, [s1]],
       [s1, [s0, s2, s3]],
       [s2, [s0, s1]],   [s3, [s0, s1, s4]],   [s4, [s0, s3]]]
      % Labeling of LTS (På as p, Inloggad as q, I spelet as r)
      ,[[s0, []],
	[s1, [p]],
	[s2, [p,r]],
	[s3, [p,q]],
	[s4, [p,q,r]]], s1, [], or(af(and(r,q)), neg(p))).
