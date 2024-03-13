-- Создание представления для таблицы dbo.sku, используя функцию dbo.udf_GetSKUPrice
create view  vw_SKUPrice as
select 
	ID
    ,Code
    ,Name
    ,(select udf_GetSKUPrice(ID) ) as AverageValue
from dbo.sku;