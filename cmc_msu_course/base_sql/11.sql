SELECT manager_first_name, manager_last_name
FROM MANAGER
WHERE manager_id in (
    SELECT t.manager_id FROM (
        SELECT
            manager_id, 
            SUM(sol.product_qty * sol.product_price) manager_sum
        FROM SALES_ORDER so
        INNER JOIN SALES_ORDER_LINE sol ON so.sales_order_id = sol.sales_order_id
        WHERE extract(month from so.order_date) = 1 AND extract(year from so.order_date) = 2016
        GROUP BY manager_id
    ) t
    WHERE t.manager_sum = (SELECT MAX(manager_sum) FROM (
        SELECT SUM(sol.product_qty * sol.product_price) manager_sum
        FROM SALES_ORDER so
        INNER JOIN SALES_ORDER_LINE sol ON so.sales_order_id = sol.sales_order_id
        WHERE extract(month from so.order_date) = 1 AND extract(year from so.order_date) = 2016
        GROUP BY so.manager_id
    ))
)
