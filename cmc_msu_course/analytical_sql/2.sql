-- Компания хочет оптимизировать количество офисов, проанализировав относительные объемы продаж по офисам в течение периода с 2013-2014 гг.
-- Выведите год, office_id, city_name, country, относительный объем продаж за текущий год
-- Офисы, которые демонстрируют наименьший относительной объем в течение двух лет скорее всего будут закрыты.

with 
  sales as(  -- продажи
	select 
        office_id
      , city_name
      , country
      , extract(year from sale_date) year_of_sale
      , sale_amount 
    from 
      v_fact_sale
	where 
      sale_date 
      	between 
      		  to_date('01.01.2013', 'DD.MM.YYYY')  -- в течение периода с 2013-2014 гг
          and to_date('31.12.2014', 'DD.MM.YYYY')
  ),
  offices as(  -- офисы 
	select 
        office_id
      , city_name
      , country
      , year_of_sale
      , sum(sale_amount) year_sum
    from
      sales
    group by 
        office_id
      , city_name
      , country
      , year_of_sale
  )

select 
    year_of_sale
  , office_id
  , city_name
  , country
  , year_sum / sum(year_sum) over(partition by year_of_sale) * 100 relative_sales
from 
  offices
order by
    year_of_sale
  , relative_sales desc;
