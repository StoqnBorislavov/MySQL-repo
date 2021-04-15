# 21.	 All Mountain Peaks
SELECT peak_name FROM peaks
ORDER BY peak_name ASC;
# 22.	 Biggest Countries by Population
SELECT country_name, population FROM countries
WHERE continent_code = 'EU'
ORDER BY population DESC, country_name ASC
LIMIT 30;
# 23.    Countries and Currency (Euro / Not Euro)
SELECT country_name, country_code,
CASE WHEN currency_code = 'EUR' THEN 'Euro'
ELSE 'Not euro'
END AS currancy
FROM countries
ORDER BY country_name ASC;
# 24.	 All Diablo Characters
SELECT name FROM characters
ORDER BY name ASC;
