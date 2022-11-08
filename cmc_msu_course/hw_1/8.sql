SELECT DISTINCT country, COUNT(city_name) AS "cities_count" FROM CITY
GROUP BY country
