-- Выведите самый дешевый и самый дорогой товар, проданный за каждый месяц в течение 2014 года.
-- cheapest_product_id, cheapest_product_name, expensive_product_id, expensive_product_name, month, cheapest_price, expensive_price

with 
  tmp as(
    select
        extract(month from sale_date) sale_month
      , product_id, product_name
      , sale_price 
    from 
      v_fact_sale
    where 
      sale_date
        between 
              to_date('31.12.2013', 'DD.MM.YYYY')
          and to_date('31.12.2014', 'DD.MM.YYYY')
  ),
  mini as(
	select
        sale_month
      , min(sale_price) cheapest_price
    from
      tmp
    group by
      sale_month
	order by
      sale_month
  ),
  maxi as(
	select
        sale_month
      , max(sale_price) expensive_price 
    from
      tmp
	group by
      sale_month
	order by
      sale_month
  ),
  mini_full as(
	select
        f.sale_month
      , f.cheapest_price
      , s.product_id cheapest_id
      , s.product_name cheapest_name
    from
      mini f
	    join
          tmp s
            on f.cheapest_price = s.sale_price 
           and f.sale_month = s.sale_month
  ),
  maxi_full as(
	select
        f.sale_month
      , f.expensive_price
      , s.product_id expensive_id
      , s.product_name expensive_name
    from
      maxi f
        join
          tmp s 
            on f.expensive_price = s.sale_price
           and f.sale_month = s.sale_month
  )

select
    f.sale_month
  , f.cheapest_id
  , f.cheapest_name
  , s.expensive_id
  , s.expensive_name
  , f.cheapest_price
  , s.expensive_price
from
  mini_full f
    join
      maxi_full s
        on f.sale_month = s.sale_month
order by
  f.sale_month;
