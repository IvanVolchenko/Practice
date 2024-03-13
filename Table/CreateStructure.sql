-- Создание структуры (таблиц) для уже существующей схемы dbo
create table if not exists dbo.SKU (
    ID int auto_increment primary key,
    Code varchar(255) unique,
    Name varchar(255)
);

create table if not exists dbo.Family (
    ID int auto_increment primary key,
    SurName varchar(255) unique,
    BudgetValue decimal(10, 2)
);

create table if not exists dbo.Basket (
    ID int auto_increment primary key,
    ID_SKU int,
    ID_Family int,
    Quantity int check (Quantity >= 0),
    Value decimal(10, 2) check (Value >= 0),
    PurchaseDate date default null,
    DiscountValue decimal(10, 2),
    foreign key (ID_SKU) references dbo.SKU(ID),
    foreign key (ID_Family) references dbo.Family(ID)
);

-- Создание триггера для вычисления поля Code
delimiter //
create trigger tr_sku_calculate_code before insert on dbo.SKU
for each row
begin
    declare next_id int;
    select max(ID) + 1 into next_id from dbo.SKU;
    if next_id is null then
        set next_id = 1;
    end if;
    set new.Code = concat('s', next_id);
end//
delimiter;

-- Создание триггера для вставки текущей даты для каждой операции в dbo.Basket
delimiter //
create trigger tr_basket_set
before insert on dbo.Basket
for each row
begin
    set new.PurchaseDate = current_date();
end//
delimiter ;