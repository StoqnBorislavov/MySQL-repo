# 1.	Employee Address
SELECT e.employee_id, e.job_title, e.address_id, a.address_text
FROM employees e
JOIN addresses a
ON e.address_id = a.address_id
ORDER BY e.address_id
LIMIT 5;

# 2.	Addresses with Towns
SELECT 	e.first_name,
		e.last_name,
        t.name AS town,
        a.address_text
FROM employees e
JOIN addresses a
ON e.address_id = a.address_id
JOIN towns t
ON t.town_id = a.town_id
ORDER BY e.first_name, e.last_name
LIMIT 5;

# 3. Sales Employee
SELECT 	e.employee_id,
		e.first_name,
		e.last_name,
        d.name AS department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;

# 4.	Employee Departments
SELECT 	e.employee_id,
		e.first_name,
		e.salary,
        d.name AS department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY e.department_id DESC, e.salary DESC
LIMIT 5;

# 5.	Employees Without Project
SELECT 	e.`employee_id`,
		e.`first_name`
FROM employees e
LEFT JOIN employees_projects em
ON em.`employee_id` = e.`employee_id`
WHERE em.`project_id` IS NULL
ORDER BY e.`employee_id` DESC
LIMIT 3;

# 6.	Employees Hired After
SELECT 	e.`first_name`,
		e.`last_name`,
        e.`hire_date`,
        d.`name` AS dept_name
FROM employees e
JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE e.`hire_date` > '1999-01-01' AND (d.`name` = 'Sales' OR d.`name` = 'Finance')
ORDER BY e.`hire_date`;

# 7.	Employees with Project
SELECT 	e.employee_id,
		e.first_name,
        p.name
FROM employees e
JOIN employees_projects em
ON em.employee_id = e.employee_id
JOIN projects p
ON em.project_id = p.project_id
WHERE p.start_date > '2002-08-13' AND p.end_date is NULL
ORDER BY e.first_name, p.name
LIMIT 5;

# 8.	Employee 24
SELECT e.employee_id,
		e.first_name,
		CASE  WHEN p.start_date > '2004-12-31' THEN NULL
        ELSE p.name
        END AS project_name
FROM employees e
JOIN employees_projects em
ON e.employee_id = em.employee_id
JOIN projects p
ON em.project_id = p.project_id
WHERE e.employee_id = 24
ORDER BY p.name;

# 9.	Employee Manager
SELECT  e.employee_id,
		e.first_name,
        e.manager_id,
        em.first_name
FROM employees e
JOIN employees em
ON e.manager_id = em.employee_id
WHERE e.manager_id = 3 OR e.manager_id = 7
ORDER BY e.first_name;

# 10.	Employee Summary
SELECT  e.employee_id,
		CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
        CONCAT(em.first_name, ' ', em.last_name) AS manager_name,
        d.name AS department_name
FROM employees e
JOIN employees em
ON e.manager_id = em.employee_id
JOIN departments d
ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 5;

# 11.	Min Average Salary
SELECT 
    *
FROM
    (SELECT 
        AVG(e.salary) AS min_avarege_salary
    FROM
        employees e
    GROUP BY e.department_id) as avg_salary
ORDER BY min_avarege_salary ASC
LIMIT 1;

# 12.	Highest Peaks in Bulgaria
SELECT c.country_code,
		m.mountain_range,
        p.peak_name,
        p.elevation
FROM countries c
JOIN mountains_countries mc 
ON c.country_code = mc.country_code
JOIN mountains m
ON mc.mountain_id = m.id
JOIN peaks p
ON m.id = p.mountain_id
WHERE c.country_name = 'Bulgaria' AND p.elevation > 2835
ORDER BY p.elevation DESC;

# 13.	Count Mountain Ranges
SELECT c.country_code,
		COUNT(m.mountain_range) AS mountain_range
FROM countries c
JOIN mountains_countries mc 
ON c.country_code = mc.country_code
JOIN mountains m
ON mc.mountain_id = m.id
WHERE c.country_name = 'Bulgaria' OR c.country_name = 'Russia' OR c.country_name = 'United States'
GROUP BY c.country_name
ORDER BY mountain_range DESC;

# 16.	Countries without any Mountains
SELECT COUNT(*)
FROM countries c
LEFT JOIN mountains_countries mc
ON c.country_code = mc.country_code
WHERE mc.mountain_id IS NULL;

# 17.	Highest Peak and Longest River by Country
SELECT c.country_name, 
		MAX(p.elevation) AS highest_peak_elevation,
        MAX(r.length) AS longest_river_length
FROM countries c
JOIN countries_rivers AS cr
ON c.country_code = cr.country_code
JOIN rivers AS r
ON cr.river_id = r.id
JOIN mountains_countries AS mc
ON mc.country_code = c.country_code
JOIN mountains AS m
ON mc.mountain_id = m.id
JOIN peaks p
ON p.mountain_id = m.id
GROUP BY c.country_name
ORDER BY highest_peak_elevation DESC,
longest_river_length DESC,
c.country_name
LIMIT 5;
