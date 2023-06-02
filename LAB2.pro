% Домен "shop"
domain shop.
consult('facts.pl').
% Правила
% возвращает true, если клиент является постоянным (количество купленных товаров 2 или более)
shop::постоянный_клиент(Name) :-
    shop::клиент(Name, _),
    shop::количество_покупок(Name, N),
    N >= 2.

% возвращает количество покупок конкретного клиента
shop::количество_покупок(Name, N) :-
    findall(ItemId, shop::покупка(Name, ItemId, _, _), Ids),
    length(Ids, N).

% возвращает имена всех клиентов, купивших определенный товар
shop::имена_клиентов_товар(ItemId, Names) :-
    findall(Name, (shop::покупка(Name, ItemId, _, _), shop::клиент(Name, _)), Names).

% возвращает название всех товаров, проданных в определенный день
shop::названия_товаров_день(Date, Titles) :-
    findall(ItemName, (shop::покупка(_, ItemId, _, Date), shop::товар(ItemId, ItemName, _, _)), Titles).

% возвращает сумму покупок за определенный день
shop::сумма_покупок_за_день(Date, Sum) :-
    findall(Total,
        (shop::покупка(_, Id, Quantity, Date),
        shop::товар(Id, _, _, Price),
        Total is Quantity * Price),
    Totals),
    sum_list(Totals, Sum).

implement main

clauses
    run() :-
        постоянный_клиент('Иванов'),
        количество_покупок('Иванов', N),
        имена_клиентов_товар(1, Names),
        названия_товаров_день(date(2023, 05, 08), Titles),
        сумма_покупок_за_день(date(2023, 05, 08), Sum).

end implement main

goal
    mainExe::run(main::run).
