-- Для планирования закупок, компанию оценивает динамику роста продаж по товарам.
-- Динамика оценивается как отношение объема продаж в текущем месяце к предыдущему.
-- Выведите товары, которые демонстрировали наиболее высокие темпы роста продаж в течение первого полугодия 2014 года.

with 
  tmp as (
	select
        product_id
      , product_name
      , extract(month from sale_date) as sale_month
      , sum(sale_amount) as month_amount
    from 
      v_fact_sale
    where
      sale_date 
        between 
              to_date('01.01.2014', 'dd.mm.yyyy')
          and to_date('30.06.2014', 'dd.mm.yyyy')
	group by
        product_id
      , product_name
      , extract(month from sale_date)
  )

select 
    f.product_id
  , f.product_name
  , f.sale_month
  , f.month_amount / s.month_amount dynamic
from 
  tmp f
    join tmp s 
	  on f.product_id = s.product_id 
     and f.sale_month = s.sale_month + 1 
order by 
  dynamic desc;
