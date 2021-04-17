#BuildInFunctions
#Part I – Queries for SoftUni Database
# 1.	Find Names of All Employees by First Name
SELECT first_name, last_name FROM employees
WHERE first_name LIKE 'Sa%' OR 'SA%' OR 'sA%' OR 'sa%'
ORDER BY employee_id ASC;

# 2.	Find Names of All employees by Last Name 
SELECT first_name, last_name FROM employees
WHERE last_name LIKE '%ei%' OR '%eI%' OR '%Ei%' OR '%EI%'
ORDER BY employee_id ASC;

# 3.	Find First Names of All Employees
SELECT first_name FROM employees
WHERE department_id IN (3, 10) AND
(hire_date BETWEEN '1995-01-01 00:00:00' AND '2005-12-31 23:59:59')
ORDER BY employee_id ASC;

# 4.	Find All Employees Except Engineers
SELECT first_name, last_name, job_title FROM employees
WHERE job_title NOT LIKE '%engineer%' OR '%Engineer%'
ORDER BY employee_id ASC;

# 5.	Find Towns with Name Length
SELECT name FROM towns
WHERE char_length(name) >= 5 AND char_length(name) <= 6
ORDER BY name ASC;

# 6. Find Towns Starting With
use soft_uni;
SELECT * FROM towns
WHERE lower(left(name, 1)) IN ('m','k','b','e')
ORDER BY name;

# 7.	 Find Towns Not Starting With
use soft_uni;
SELECT * FROM towns
WHERE lower(left(name, 1)) NOT IN ('r','b','d')
ORDER BY name;

# 8.	Create View Employees Hired After 2000 Year
CREATE VIEW v_employees_hired_after_2000 AS
SELECT first_name, last_name FROM employees
WHERE hire_date >= '2001-01-01 00:00:00';
SELECT * FROM v_employees_hired_after_2000;

# 9.	Length of Last Name
SELECT first_name, last_name FROM employees
WHERE char_length(last_name) = 5;

#Part II – Queries for Geography Database 
# 10.	Countries Holding ‘A’ 3 or More Times
SELECT c.country_name, c.iso_code FROM countries c
WHERE (length(lower(c.country_name)) - length(replace(lower(c.country_name), 'a', ''))) >= 3
ORDER BY c.iso_code;

# 11.	 Mix of Peak and River Names
USE geography;
SELECT peak_name, river_name, lower(concat(peak_name, substring(river_name, 2))) AS `mix`
FROM peaks, rivers
WHERE right(peak_name, 1) = left(river_name, 1)
ORDER BY mix;

#Part III – Queries for Diablo Database
#12.	Games from 2011 and 2012 year
SELECT g.name, DATE_FORMAT(g.start, '%Y-%m-%d') AS `start` FROM games g
WHERE (g.start BETWEEN '2011-01-01 00:00:00' AND '2012-12-31 23:59:59')
ORDER BY g.start, g.name;

# 13.	 User Email Providers
use diablo;
SELECT user_name, substring(email, position('@' IN email) + 1)
 AS `Email Provider`
FROM users
ORDER BY `Email Provider`, user_name;

# 14.	 Get Users with IP Address Like Pattern
SELECT u.user_name, u.ip_address FROM users u
WHERE u.ip_address REGEXP '^[0-9]{3}\.1[0-9]*\.[0-9]*\.[0-9]{3}$'
ORDER BY u.user_name;

# 15.	 Show All Games with Duration and Part of the Day
#Find all games with their corresponding part of the day and duration.
#parts of the day should be Morning (start time is >= 0 and < 12),
#Afternoon (start time is >= 12 and < 18), Evening (start time is >= 18 and < 24). 
#Duration should be Extra Short (smaller or equal to 3), Short (between 3 and 6 including),
#Long (between 6 and 10 including) and Extra Long in any other cases or without duration.

SELECT name, 
CASE WHEN EXTRACT(hour FROM start) >= 0 AND EXTRACT(hour FROM start) < 12 THEN 'Morning'
	 WHEN EXTRACT(hour FROM start) >= 12 AND EXTRACT(hour FROM start) < 18 THEN 'Afternoon'
     WHEN EXTRACT(hour FROM start) >= 18 AND EXTRACT(hour FROM start) < 24 THEN 'Evening'
END AS start,
CASE WHEN duration <= 3 THEN 'Extra Short'
     WHEN duration > 3 AND  duration <= 6 THEN 'Short'
     WHEN duration > 6 AND duration <= 10 THEN 'Long'
     ELSE 'Extra Long'
END AS Duration 
FROM games;

#Part IV – Date Functions Queries
# 16.	 Orders Table
SELECT o.product_name, o.order_date,
date_add(o.order_date, INTERVAL 3 DAY) AS `pay_due`,
date_add(o.order_date, INTERVAL 1 MONTH) AS `deliver_due`
FROM orders o;