SELECT SUM(sol.product_qty) AS "products_count" FROM SALES_ORDER so
INNER JOIN SALES_ORDER_LINE sol ON so.sales_order_id = sol.sales_order_id
WHERE so.order_date >= to_date('01-01-2016', 'DD-MM-YYYY') AND so.order_date <= to_date('30-01-2016', 'DD-MM-YYYY')
