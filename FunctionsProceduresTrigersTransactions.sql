# 1.	Employees with Salary Above 35000
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000() 
BEGIN
	SELECT e.first_name, e.last_name 
	FROM employees e
	WHERE salary > 35000
	ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
CALL usp_get_employees_salary_above_35000();

# 2.	Employees with Salary Above Number 
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(min_salary DECIMAL(19,4)) 
BEGIN
	SELECT e.first_name, e.last_name 
	FROM employees e
	WHERE salary >= min_salary
	ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
CALL usp_get_employees_salary_above(100000);

# 3.	Town Names Starting With
DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(starts_with_string VARCHAR(20))
BEGIN
	SELECT t.name 
    FROM towns t
    WHERE t.name LIKE concat(starts_with_string, '%')
    ORDER BY t.name;
END $$ 
CALL usp_get_towns_starting_with('b');

# 4.	Employees from Town
DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(20))
BEGIN 
	SELECT e.first_name, e.last_name
    FROM employees e
    JOIN addresses a
    ON e.address_id = a.address_id
    JOIN towns t
    ON a.town_id = t.town_id
    WHERE t.name = town_name
    ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
CALL usp_get_employees_from_town('Sofia');

# 5.	Salary Level Function
DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(e_salary DECIMAL(19,4))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
	RETURN( CASE 
				WHEN e_salary < 30000 THEN 'Low'
				WHEN e_salary >= 30000 AND e_salary <= 50000 THEN 'Average'
				WHEN e_salary > 50000 THEN 'High'
			END
			);
END $$
DELIMITER ;
SELECT ufn_get_salary_level(500001);



