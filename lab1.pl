likes(mary, peaches).
likes(mary, corn).
likes(mary, apples).

fruit(peaches).
fruit(apples).

color(peaches, yellow).
color(oranges, orange).
color(apples, red).
color(apples, yellow).

likes(beth, X) :-
    likes(mary, X),
    fruit(X),
    color(X, red).

likes(beth, corn) :-
    likes(mary, corn).
