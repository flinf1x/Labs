tr(i, je).
tr(you, tu).
tr(he, il).
tr(she, elle).
tr(we, nous).
tr(they, ils).

tr(love, aime).
tr(see, vois).
tr(eat, mange).
tr(like, aime).

tr(apples, pommes).
tr(pears, poires).
tr(bread, pain).
tr(corn, mais).

translate([], []).

translate([X | T], [Y | T1]) :-
    tr(X, Y),
    translate(T, T1).
