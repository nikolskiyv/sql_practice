--- Каждый месяц компания выдает премию в размере 5% от суммы продаж менеджеру, 
-- который за предыдущие 3 месяца продал товаров на самую большую сумму
-- Выведите месяц, manager_id, manager_first_name, manager_last_name, премию 
-- за период с января по декабрь 2014 года

with MONTHS as (
select level-3 MONTH_ID from dual
 connect by level < 15
),
MANAGERS as (
 select distinct MANAGER_ID from V_FACT_SALE
),
MANAGER_MONTHS as (
  select MONTH_ID, MANAGER_ID from MANAGERS cross join MONTHS
),
step1 as (
  select MM.manager_id, MM.MONTH_ID SALE_MONTH, sum(sale_amount) SALE_AMOUNT
  from MANAGER_MONTHS MM left outer join V_FACT_SALE S on (
      MM.MANAGER_ID = S.MANAGER_ID and 
      MM.MONTH_ID = TRUNC(MONTHS_BETWEEN(sale_date, TO_DATE('01-01-2014', 'DD-MM-YYYY'))) and 
      SALE_DATE BETWEEN TO_DATE('01-10-2013', 'DD-MM-YYYY') and TO_DATE('31-12-2014', 'DD-MM-YYYY')
      )
  group by MM.manager_id, MM.MONTH_ID
),
step2 as (
select 
  MANAGER_ID,
  SALE_MONTH,
  SUM(SALE_AMOUNT) over (partition by MANAGER_ID order by SALE_MONTH RANGE BETWEEN 3 PRECEDING AND 1 PRECEDING) SALE_AMOUNT_3M
from step1
),
step3 as (select 
  MANAGER_ID, 
  SALE_MONTH,
  SALE_AMOUNT_3M,
  MAX(SALE_AMOUNT_3M) over (partition by SALE_MONTH) MAX_SALE_AMOUNT_3M
from step2
)
select 
  MANAGER_ID,
  SALE_MONTH,
  SALE_AMOUNT_3M,
  SALE_AMOUNT_3M * 0.05 BONUS
from step3
where SALE_AMOUNT_3M = MAX_SALE_AMOUNT_3M and SALE_MONTH >=0


-- 969
-- 140929.22
-- 362 / 278841.92


-- 61855.81
select sum(SALE_AMOUNT) from V_FACT_SALE where MANAGER_ID=362
  and sale_date between TO_DATE('01-11-2013', 'DD-MM-YYYY') and TO_DATE('31-01-2014', 'DD-MM-YYYY');
  
select * from V_FACT_SALE where MANAGER_ID=362
  and sale_date between TO_DATE('01-11-2013', 'DD-MM-YYYY') and TO_DATE('28-02-2014', 'DD-MM-YYYY')
order by sale_date
  
select manager_id, sum(SALE_AMOUNT) 
  from V_FACT_SALE
  where sale_date between TO_DATE('01-11-2013', 'DD-MM-YYYY') and TO_DATE('31-01-2014', 'DD-MM-YYYY')
  group by manager_id
  order by SUM(SALE_AMOUNT) desc;
