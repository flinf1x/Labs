:- use_module(library(readutil)).

:- dynamic edge/3.

% Рёбра шаблонного графа

template_edge(a, b, 2).
template_edge(a, c, 5).
template_edge(b, c, 1).
template_edge(b, d, 4).
template_edge(c, d, 2).
template_edge(c, e, 3).
template_edge(d, e, 1).

% Список рёбер для ручного ввода

custom_edge(a, b).
custom_edge(a, c).
custom_edge(b, c).
custom_edge(b, d).
custom_edge(c, d).
custom_edge(c, e).
custom_edge(d, e).


% Работа с графом

clear_graph :-
    retractall(edge(_, _, _)).

load_template_graph :-
    clear_graph,
    forall(template_edge(X, Y, W), assertz(edge(X, Y, W))).

input_custom_graph :-
    clear_graph,
    nl,
    writeln('Введите стоимость перемещения для каждого ребра.'),
    writeln('Если ребра нет, введите 0.'),
    nl,
    forall(custom_edge(X, Y), input_edge_cost(X, Y)).

input_edge_cost(X, Y) :-
    format(atom(Prompt), 'Стоимость перемещения от ~w к ~w: ', [X, Y]),
    read_non_negative_number(Prompt, W),
    (
        W > 0 ->
            assertz(edge(X, Y, W))
    ;
        true
    ).

show_graph :-
    nl,
    writeln('Текущий граф:'),
    (
        edge(_, _, _) ->
            forall(edge(X, Y, W), format('edge(~w, ~w, ~w).~n', [X, Y, W]))
    ;
        writeln('Граф пуст.')
    ),
    nl.


% Граф считается неориентированным

path_edge(X, Y, W) :-
    edge(X, Y, W).

path_edge(X, Y, W) :-
    edge(Y, X, W).


% Поиск пути

path(Start, Finish, Path, Length) :-
    travel(Start, Finish, [Start], RevPath, 0, Length),
    reverse(RevPath, Path).

travel(Finish, Finish, Visited, Visited, Length, Length).

travel(Current, Finish, Visited, Path, AccLen, Length) :-
    path_edge(Current, Next, W),
    \+ member(Next, Visited),
    NewLen is AccLen + W,
    travel(Next, Finish, [Next | Visited], Path, NewLen, Length).

shortest_path(Start, Finish, Path, Length) :-
    setof(L-P, path(Start, Finish, P, L), [Length-Path | _]).


% Интерфейс

start :-
    nl,
    writeln('Поиск кратчайшего пути в графе'),
    nl,
    writeln('Выберите режим:'),
    writeln('1. Граф по шаблону'),
    writeln('2. Задать граф самому'),
    read_choice(1, 2, Choice),

    (
        Choice =:= 1 ->
            load_template_graph
    ;
        input_custom_graph
    ),

    show_graph,
    find_path_interface,
    ask_restart.

find_path_interface :-
    read_atom('Начальная вершина: ', Start),
    read_atom('Конечная вершина: ', Finish),

    (
        shortest_path(Start, Finish, Path, Length) ->
            nl,
            writeln('Кратчайший путь найден:'),
            write('Путь: '),
            print_path(Path),
            nl,
            format('Длина пути: ~w~n', [Length])
    ;
            nl,
            writeln('Путь между указанными вершинами не найден.')
    ).

print_path([]).

print_path([X]) :-
    write(X).

print_path([X, Y | Rest]) :-
    write(X),
    write(' -> '),
    print_path([Y | Rest]).

ask_restart :-
    nl,
    write('Начать заново? (да/нет): '),
    read_line_to_string(user_input, Input0),
    normalize_space(string(Input), Input0),
    string_lower(Input, Lower),
    (
        member(Lower, ["да", "д", "yes", "y"]) ->
            start
    ;
        writeln('Работа завершена.')
    ).


% Ввод данных

read_choice(Min, Max, Choice) :-
    format('Ваш выбор (~w-~w): ', [Min, Max]),
    read_line_to_string(user_input, Input0),
    normalize_space(string(Input), Input0),
    (
        catch(number_string(Choice, Input), _, fail),
        integer(Choice),
        Choice >= Min,
        Choice =< Max
    ->
        true
    ;
        writeln('Неверный ввод. Введите номер варианта.'),
        read_choice(Min, Max, Choice)
    ).

read_atom(Prompt, Atom) :-
    write(Prompt),
    read_line_to_string(user_input, Input0),
    normalize_space(string(Input), Input0),
    (
        Input \= "" ->
            atom_string(Atom, Input)
    ;
        writeln('Значение не должно быть пустым.'),
        read_atom(Prompt, Atom)
    ).

read_non_negative_number(Prompt, Number) :-
    write(Prompt),
    read_line_to_string(user_input, Input0),
    normalize_space(string(Input), Input0),
    (
        catch(number_string(Number, Input), _, fail),
        number(Number),
        Number >= 0
    ->
        true
    ;
        writeln('Введите число 0 или больше.'),
        read_non_negative_number(Prompt, Number)
    ).


% Автозапуск

:- initialization(start, main).
