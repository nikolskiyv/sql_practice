-- Менеджер получает оклад в 30 000 + 5% от суммы своих продаж в месяц. Средняя наценка стоимости товара - 10%
-- Посчитайте прибыль предприятия за 2014 год по месяцам (сумма продаж - (исходная стоимость товаров + зарплата))
-- month, sales_amount, salary_amount, profit_amount

with
  sales_per_month_agg as (
	select distinct
        manager_id
      , extract(month from sale_date) month
      , sum(sale_amount) over (
          partition by
          	  manager_id
            , extract(month from sale_date) 
          order by
            extract(month from sale_date)
	  		  rows 
                between 
                      unbounded preceding 
                  and unbounded following
        ) manager_sales
      , sum(sale_amount) over (
          partition by
            extract(month from sale_date)
		  order by
            extract(month from sale_date)
			  rows
                between
          			  unbounded preceding 
                  and unbounded following
        ) product_price
    from
      v_fact_sale
    where
      sale_date
        between 
              to_date('31.12.2013', 'DD.MM.YYYY')
          and to_date('31.12.2014', 'DD.MM.YYYY')
)

select distinct 
    month
  , sum(manager_sales* 0.05 + 30000) over (partition by month) salary_amount
  , product_price sales_amount
  , product_price * 0.1 - sum(manager_sales* 0.05 + 30000) over (partition by month) profit from sales_per_month_agg
order by
  month;
