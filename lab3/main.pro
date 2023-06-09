﻿% Copyright

implement main
    open core, file, stdio

domains
    type = таблетки; раствор; рулон; вата; настойка; мазь.
    ассортимент = ассортимент(string Название_Лекарства, integer Цена).
    данные = данные(string Адрес, string Номер).

class facts - apteka
    аптека : (integer Id_A, string Название, string Адрес, string Номер).
    лекарство : (integer Id_L, string Название_Лекарства, type Тип).
    продает : (integer Id_A, integer Id_L, integer Цена, integer Остаток).

class predicates  %Вспомогательные предикаты
    длина : (A*) -> integer N.
clauses
    длина([]) = 0.
    длина([_ | T]) = длина(T) + 1.

class predicates
    адрес_и_телефон_аптеки : (string Название) -> данные* Адреса. %! сделать вывод!
    доступные_лекарства : (string Название, string Адрес) -> ассортимент* Товары determ. %! сделать вывод!
    наименьшая_цена : (string Название_лекарства) -> string* Адрес determ.
    количество_товара : (string Название, string Адрес) -> integer N determ.
    заданное_количество : (string Название_Лекарства, integer N) -> string* Номер determ.
    аптека_с_определенным_типом_лекарств : (type Тип) -> string* Название.

clauses
    адрес_и_телефон_аптеки(X) = List1 :-
        !,
        List1 = [ данные(Адрес, Номер) || аптека(_, X, Адрес, Номер) ].

    доступные_лекарства(X, Y) =
            [ ассортимент(Название_Лекарства, Цена) ||
                продает(Id_A, Id_L, Цена, _),
                лекарство(Id_L, Название_Лекарства, _)
            ] :-
        аптека(Id_A, X, Y, _),
        !.

    количество_товара(X, Y) = длина(доступные_лекарства(X, Y)).

    наименьшая_цена(X) = List5 :-
        лекарство(NP, X, _),
        List5 =
            [ Y ||
                аптека(N, _, Y, _),
                продает(N, NP, Price1, _),
                not((продает(_, NP, Price2, _) and Price2 < Price1))
            ],
        !.

    заданное_количество(Y, N) = List3 :-
        лекарство(NP, Y, _),
        List3 =
            [ Num ||
                аптека(ID, _, _, Num),
                продает(ID, NP, _, K),
                K >= N
            ],
        !.

    аптека_с_определенным_типом_лекарств(X) = List4 :-
        List4 =
            [ Y ||
                лекарство(Id_L, _, X),
                продает(Id_A, Id_L, _, _),
                аптека(Id_A, _, Y, _)
            ],
        !.

class predicates  %Вывод на экран
    write_ассортимент : (ассортимент* Лекарство_И_Цена).
    write_данные : (данные* Адрес_и_Номер_Аптеки).

clauses
    write_ассортимент(L) :-
        foreach ассортимент(Название_Лекарства, Цена) = list::getMember_nd(L) do
            writef(string::format("%18s %14d \n", Название_Лекарства, Цена)),
            writef("________________________________________________\n")
        end foreach.
    write_данные(L) :-
        foreach данные(Адрес, Номер) = list::getMember_nd(L) do
            writef("\t%\t%\n", Адрес, Номер),
            writef("________________________________________________\n")
        end foreach.

clauses
    run() :-
        console::init(),
        reconsult("..\\apteka.txt", apteka),
        fail.

    run() :-
        write("\nПравило: адрес и телефон аптеки\n"),
        X = "Аптека.ру",
        write("Сеть = ", X, "\n"),
        writef(string::format("%18s %14s \n", "Адрес", " \tТелефон")),
        writef("________________________________________________\n"),
        write_данные(адрес_и_телефон_аптеки(X)),
        write("\n"),
        fail.

    run() :-
        write("\nПравило: ассортимент аптеки\n"),
        X = "Аптека.ру",
        Y = "ул. Профсоюзная",
        write("Название аптеки = ", X, "\n"),
        write("Адрес аптеки = ", Y, "\n"),
        writef(string::format("%18s %14s \n", "Лекарство", " Цена")),
        writef("________________________________________________\n"),
        write_ассортимент(доступные_лекарства(X, Y)),
        write("\nВсего лекарств = ", количество_товара(X, Y), "\n"),
        write("\n"),
        fail.

    run() :-
        X = "Изопропиловый спирт",
        L = наименьшая_цена(X),
        write("Адрес аптеки с наименьшей ценой лекарства: ", L, "\n"),
        write("\n"),
        fail.

    run() :-
        X = "Парацетамол",
        N = 50,
        L = заданное_количество(X, N),
        write("Номер телефона аптеки, где заданное лекарство есть в количестве, не меньше, чем ", N, ": \n", L, "\n"),
        write("\n"),
        fail.

    run() :-
        write("Адреса аптеки с определенным типом лекарств: \n"),
        X = вата,
        L = аптека_с_определенным_типом_лекарств(X),
        write(L, "\n"),
        fail.

    run() :-
        succeed.

end implement main

goal
    console::run(main::run).
