SELECT * FROM SALES_ORDER so
JOIN MANAGER m ON so.manager_id = m.manager_id
WHERE m.manager_first_name LIKE('Henry')
