-- Напишите запрос, который выводит отчет о прибыли компании за 2014 год: помесячно и поквартально.
-- Отчет включает сумму прибыли за период и накопительную сумму прибыли с начала года по текущий период.

with 
  tmp1 as (
	select
        sale_amount
      , sale_date
      , trunc(sale_date, 'mm') month
    from 
      v_fact_sale
    where
      sale_date
        between
              to_date('01.01.2014', 'dd.mm.yyyy')
          and to_date('31.12.2014', 'dd.mm.yyyy')
  ),
  tmp2 as (
    select
        trunc(month, 'q') quarter_sale
      , month
      , sum(sale_amount) sale_amount
    from
      tmp1
    group by
      month
  ),
  tmp3 as (
	select
        trunc(month, 'q') quarter_sale
      , sum(sale_amount) quarter_amount
    from
      tmp2
    group by
      trunc(month, 'q')
)

select 
    tmp2.quarter_sale
  , quarter_amount
  , sum(sale_amount) 
	  over(
        order by
          tmp2.quarter_sale
        range
          between
                unbounded preceding 
            and current row
      ) quarter_sum
  , month
  , sale_amount
  , sum(sale_amount)
      over(
        order by 
          month 
        rows
          between
                unbounded preceding 
            and current row
      ) month_sum 
from 
  tmp2
    right outer join
      tmp3 
        on tmp2.quarter_sale = tmp3.quarter_sale;
