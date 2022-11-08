SELECT DISTINCT city_name AS "all_uniques" FROM city
UNION
SELECT DISTINCT region AS "all_uniques" FROM city
UNION
SELECT DISTINCT country AS "all_uniques" FROM city;
