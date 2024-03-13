-- Создание триггера, рассчитывающего DiscountValue для dbo.Basket
delimiter //
create trigger TR_Basket_insert_update before insert on dbo.Basket 
for each row 
begin
    declare insert_count int;
    
    -- Выбираем количество записей с таким же ID_SKU, ID_Family и датой покупки как у новой строки
    select count(*) into insert_count
    from dbo.Basket
    where (select ID_SKU from basket order by ID desc limit 1) = new.ID_SKU
    AND PurchaseDate = new.PurchaseDate and ID_Family=new.ID_Family;

    /*
    Если количество одна и та же семья в один день покупает 2 и более одинаковых продукта,
    то устанавливаем DiscountValue как 5% от Value новой строки
    */
    if insert_count >= 1 then
        set new.DiscountValue = new.Value * 0.05;
    else
        set new.DiscountValue = 0;
    end if;
end//
delimiter ;