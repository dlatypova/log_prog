% Copyright

implement main
    open core, file, stdio

domains
    type = таблетки; раствор; рулон; вата; настойка; мазь.

class facts - apteka
    аптека : (integer Id_A, string Название, string Адрес, string Номер).
    лекарство : (integer Id_L, string Название_Лекарства, type Тип).
    продает : (integer Id_A, integer Id_L, integer Цена, integer Остаток).

class predicates
    адрес_аптеки : (string Название) nondeterm.
    телефон_аптеки : (string Название) nondeterm.
    доступные_лекарства : (string Название) nondeterm.
    наименьшая_цена : (string Название_Лекарства) nondeterm.
    заданное_количество : (string Название_Лекарства, integer N) nondeterm.
    аптека_с_определенным_типом_лекарств : (type Тип) nondeterm.

clauses
    адрес_аптеки(X) :-
        аптека(_, X, Y, _),
        write("Адрес аптеки: ", Y, "\n"),
        nl,
        fail.
    адрес_аптеки(X) :-
        аптека(_, X, _, _),
        nl.

    телефон_аптеки(X) :-
        аптека(_, X, _, Y),
        write("Телефон аптеки: ", Y, "\n"),
        nl,
        fail.
    телефон_аптеки(X) :-
        аптека(_, X, _, _),
        nl.

    наименьшая_цена(X) :-
        лекарство(NP, X, _),
        аптека(N, _, Y, _),
        продает(N, NP, Price1, _),
        not((продает(_, NP, Price2, _) and Price2 < Price1)),
        write("Адрес аптеки с наименьшей ценой лекарства: ", Y, "\n"),
        nl,
        fail.
    наименьшая_цена(X) :-
        лекарство(_, X, _),
        nl.

    доступные_лекарства(X) :-
        аптека(N, X, _, _),
        продает(N, NP, _, _),
        лекарство(NP, Y, _),
        write(Y),
        nl,
        fail.
    доступные_лекарства(X) :-
        аптека(_, X, _, _),
        write("\nКонец списка\n"),
        nl.

    заданное_количество(Y, N) :-
        аптека(ID, _, _, Num),
        продает(ID, NP, _, K),
        лекарство(NP, Y, _),
        K >= N,
        write("Номер телефона аптеки, где заданное лекарство есть в количестве, не меньше, чем ", N, ": ", Num, "\n"),
        nl,
        fail.
    заданное_количество(Y, _N) :-
        лекарство(_, Y, _),
        nl.

    аптека_с_определенным_типом_лекарств(X) :-
        лекарство(NP, _, X),
        продает(ID, NP, _, _),
        аптека(ID, _, Y, _),
        write("Адрес аптеки:", Y, "\n"),
        nl,
        fail.
    аптека_с_определенным_типом_лекарств(X) :-
        write("Конец списка\n"),
        лекарство(_, _, X),
        nl.

clauses
    run() :-
        console::init(),
        reconsult("..\\apteka.txt", apteka),
        адрес_аптеки("Горздрав"),
        fail.

    run() :-
        console::init(),
        reconsult("..\\apteka.txt", apteka),
        телефон_аптеки("Горздрав"),
        fail.

    run() :-
        console::init(),
        reconsult("..\\apteka.txt", apteka),
        write("Доступные лекарства в аптеке: \n"),
        доступные_лекарства("Аптеки Столички"),
        fail.

    run() :-
        console::init(),
        reconsult("..\\apteka.txt", apteka),
        наименьшая_цена("Изопропиловый спирт"),
        fail.

    run() :-
        console::init(),
        reconsult("..\\apteka.txt", apteka),
        заданное_количество("Аспирин", 50),
        fail.

    run() :-
        console::init(),
        reconsult("..\\apteka.txt", apteka),
        write("Адреса аптеки с определенным типом лекарств: \n"),
        аптека_с_определенным_типом_лекарств(вата),
        fail.

    run() :-
        succeed.

end implement main

goal
    console::run(main::run).
