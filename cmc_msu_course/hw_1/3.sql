SELECT * FROM SALES_ORDER
WHERE to_date('01-01-2016', 'DD-MM-YYYY') < order_date AND order_date < to_date('15-07-2016', 'DD-MM-YYYY')
