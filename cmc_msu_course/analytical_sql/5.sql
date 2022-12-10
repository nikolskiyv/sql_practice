-- Найдите вклад в общую прибыль за 2014 год 10% наиболее дорогих товаров и 10% наиболее дешевых товаров.
-- Выведите product_id, product_name, total_sale_amount, percent

with 
  prices as (
	select
        product_id
      , product_name
      , avg(sale_price) avg
    from 
      v_fact_sale
    where
      sale_date
        between
              to_date('31.12.2013', 'DD.MM.YYYY')
          and to_date('31.12.2014', 'DD.MM.YYYY')
    group by
        product_id
      , product_name
  ),
  filter as (
	select
        product_id
      , product_name
      , avg
      , cume_dist() over (order by avg) cume_dist
    from
      prices
),
mimax as (
	select
        case
          when cume_dist <= 0.10
            then 1
          when cume_dist >= 0.90
            then 2
            else 0 
        end as prod_class
      , product_id
      , product_name
      , avg
	from filter
),
total as (
  select
      sum(sale_amount) as total_sale_amount
    , product_id
    , product_name 
  from
    v_fact_sale
  where
    sale_date
      between
            to_date('31.12.2013', 'DD.MM.YYYY')
        and to_date('31.12.2014', 'DD.MM.YYYY') 
  group by
      product_id
    , product_name
),
ratio as (
  select
      product_id
    , product_name
    , total_sale_amount
    , ratio_to_report(total_sale_amount) over () * 100 percent
  from
    total
)
            
select 
    f.product_id
  , f.product_name
  , f.total_sale_amount
  , f.percent
from
  ratio f
    join mimax s 
      on f.product_id = s.product_id 
where 
  prod_class in (1,2);
