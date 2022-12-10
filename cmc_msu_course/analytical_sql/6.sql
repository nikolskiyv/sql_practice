-- Компания хочет премировать трех наиболее продуктивных (по объему продаж, конечно) менеджеров в каждой стране в 2014 году.
-- Выведите country, <список manager_last_name manager_first_name, разделенный запятыми> которым будет выплачена премия

with 
  managers as (
	select
        manager_id
      , manager_first_name
      , manager_last_name
      , country
      , sum(sale_amount) total_sales_amount
from 
  v_fact_sale
where
  sale_date
    between
          to_date('01.01.2014', 'DD.MM.YYYY')
      and to_date('31.12.2014', 'DD.MM.YYYY')
group by
    manager_id
  , manager_first_name
  , manager_last_name
  , country
),
managers_rank as (
  select 
      manager_first_name
    , manager_last_name
    , country
    , rank() 
        over(
          partition by
            country
          order by
            total_sales_amount desc
        ) ranks 
  from
    managers
)

select
    country
  , listagg(
        manager_first_name || ' ' || manager_last_name
      , ', '
    ) within group (order by ranks) as managers 
from
  managers_rank
where
  ranks <= 3
group by
  country;
