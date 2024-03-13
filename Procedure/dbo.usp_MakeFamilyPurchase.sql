-- Создание процедуры для изменения бюджета BudgetValue с учетом сделанных покупок
delimiter //
create procedure dbo.usp_MakeFamilyPurchase(in FamilySurName varchar(255))
begin
    declare familyID int;
    declare totalValue decimal(10, 2);

    -- Найти ID семьи по фамилии
    select ID into familyID from dbo.Family where SurName = FamilySurName;

    -- Проверить, существует ли семья с указанной фамилией
    if familyID is null then
        signal sqlstate '45000' set message_text = 'Такой семьи не существует';
    end if;

    -- Подсчитать общую сумму покупок для данной семьи
    select sum(Value) into totalValue from dbo.Basket where ID_Family = familyID;

    -- Обновить бюджет семьи
    update dbo.Family set BudgetValue = BudgetValue - totalValue where ID = familyID;
end//
delimiter ;