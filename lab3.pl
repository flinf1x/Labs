% Ребра графа: edge(Откуда, Куда, Вес).
edge(a, b, 2).
edge(a, c, 5).
edge(b, c, 1).
edge(b, d, 4).
edge(c, d, 2).
edge(c, e, 3).
edge(d, e, 1).

% Если граф неориентированный, добавим обратные ребра:
path_edge(X, Y, W) :- edge(X, Y, W).
path_edge(X, Y, W) :- edge(Y, X, W).

% Поиск пути с учетом посещенных вершин
path(Start, Finish, Path, Length) :-
    travel(Start, Finish, [Start], RevPath, 0, Length),
    reverse(RevPath, Path).

% База: пришли в конечную вершину
travel(Finish, Finish, Visited, Visited, Length, Length).

% Рекурсивный шаг
travel(Current, Finish, Visited, Path, AccLen, Length) :-
    path_edge(Current, Next, W),
    \+ member(Next, Visited),
    NewLen is AccLen + W,
    travel(Next, Finish, [Next|Visited], Path, NewLen, Length).

% Кратчайший путь
shortest_path(Start, Finish, Path, Length) :-
    setof(L-P, path(Start, Finish, P, L), [Length-Path | _]).
