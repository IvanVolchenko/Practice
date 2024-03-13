-- Создание функции для расчета стоимости продукта по его ID_SKU
delimiter //
create function udf_GetSKUPrice(ID_SKU int) returns decimal(18, 2)
deterministic
begin
    declare total_value decimal(18, 2);
    declare total_quantity int;
    declare price decimal(18, 2);
    
    -- Рассчитываем общую сумму и количество для переданного ID_SKU
    select sum(Value), sum(Quantity) into total_value, total_quantity
    from dbo.Basket
    where dbo.basket.ID_SKU = ID_SKU;
    
    -- Проверяем деление на ноль и возвращаем стоимость продукта
    if total_quantity <> 0 then
        set price = total_value / total_quantity;
    else
        set price = 0;
    end if;
    
    return price;
end //
delimiter ;