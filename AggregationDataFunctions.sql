# 1. Records’ Count
SELECT COUNT(w.id) AS count
FROM wizzard_deposits w;

# 2.	 Longest Magic Wand
SELECT MAX(w.magic_wand_size) AS longest_magic_wand
FROM wizzard_deposits w;

# 3. Longest Magic Wand per Deposit Groups
SELECT w.deposit_group, MAX(w.magic_wand_size) AS longest_magic_wand
FROM wizzard_deposits w
GROUP BY w.deposit_group
ORDER BY longest_magic_wand, w.deposit_group;

# 4.	 Smallest Deposit Group per Magic Wand Size*
SELECT w.deposit_group
FROM wizzard_deposits w
GROUP BY w.deposit_group
ORDER BY AVG(w.magic_wand_size)
LIMIT 1;

# 5.	 Deposits Sum
SELECT w.deposit_group, SUM(w.deposit_amount) AS total_sum
FROM wizzard_deposits w
GROUP BY w.deposit_group
ORDER BY total_sum;

# 6.	 Deposits Sum for Ollivander family
SELECT w.deposit_group, SUM(w.deposit_amount) AS total_sum
FROM wizzard_deposits w
WHERE w.magic_wand_creator = 'Ollivander family'
GROUP BY w.deposit_group
ORDER BY w.deposit_group;

# 7.	Deposits Filter
SELECT w.deposit_group, SUM(w.deposit_amount) AS total_sum
FROM wizzard_deposits w
WHERE w.magic_wand_creator = 'Ollivander family'
GROUP BY w.deposit_group
HAVING total_sum < 150000
ORDER BY total_sum DESC;

# 8.	 Deposit charge
SELECT w.deposit_group, w.magic_wand_creator, MIN(w.deposit_charge) AS min_deposit_charge
FROM wizzard_deposits w
GROUP BY w.deposit_group, w.magic_wand_creator
ORDER BY w.magic_wand_creator, w.deposit_group;

# 9. Age Groups
SELECT 
CASE
WHEN w.age BETWEEN 0 AND 10 THEN '[0-10]'
WHEN w.age BETWEEN 11 AND 20 THEN '[11-20]'
WHEN w.age BETWEEN 21 AND 30 THEN '[21-30]'
WHEN w.age BETWEEN 31 AND 40 THEN '[31-40]'
WHEN w.age BETWEEN 41 AND 50 THEN '[41-50]'
WHEN w.age BETWEEN 51 AND 60 THEN '[51-60]'
ELSE '[61+]'
END AS 'age_group',
count(w.id) AS 'wizzard_count'
FROM wizzard_deposits w 
GROUP BY age_group
ORDER BY COUNT(w.id);

# 10. First Letter
SELECT LEFT(w.first_name, 1) AS first_letter
FROM wizzard_deposits w
WHERE deposit_group = 'Troll Chest'
GROUP BY LEFT(w.first_name, 1)
ORDER BY LEFT(w.first_name, 1);  

# 11.	Average Interest 

SELECT deposit_group, is_deposit_expired, AVG(deposit_interest) AS average_interest
FROM wizzard_deposits
WHERE deposit_start_date > '1985-01-01'
GROUP BY deposit_group, is_deposit_expired
ORDER BY deposit_group DESC, is_deposit_expired ASC;

# 12.	Rich Wizard, Poor Wizard*
SELECT SUM(diff_between_current_next) AS sum_difference
FROM (SELECT w1.deposit_amount - 
(SELECT w2.deposit_amount 
FROM wizzard_deposits w2
WHERE w2.id = w1.id +1)
AS diff_between_current_next
FROM wizzard_deposits w1) AS cq;

# 13.	 Employees Minimum Salaries
SELECT 
CASE WHEN e.department_id = 2 THEN '2'
	 WHEN e.department_id = 5 THEN '5'
     WHEN e.department_id = 7 THEN '7'
END AS 'department_id',
MIN(e.salary) AS minimum_salary
FROM employees e
WHERE e.hire_date > '2000-01-01' AND department_id IN (2,5,7)
GROUP BY e.department_id
ORDER BY e.department_id;

# 14.	Employees Average Salaries
CREATE TABLE highest_paid_employees AS
SELECT * FROM employees e
WHERE e.salary > 30000;

DELETE FROM highest_paid_employees
WHERE manager_id = 42;

UPDATE highest_paid_employees
SET salary = salary + 5000
WHERE department_id = 1;

SELECT h.department_id, AVG(h.salary) AS avg_salary
FROM highest_paid_employees h
GROUP BY h.department_id
ORDER BY h.department_id;

# 15. Employees Maximum Salaries
SELECT e.department_id, MAX(e.salary) AS max_salary
FROM employees e
GROUP BY e.department_id
HAVING max_salary < 30000 OR max_salary > 70000
ORDER BY e.department_id;

# 16.	Employees Count Salaries
SELECT  COUNT(e.employee_id) - COUNT(e.manager_id) AS count
FROM employees e;

# 17.	3rd Highest Salary*
# First Max salary
SELECT e.department_id, MAX(e.salary)
FROM employees e 
GROUP BY e.department_id;
# Second Max salary
SELECT e.department_id, MAX(e.salary)
FROM employees e
JOIN (
	SELECT e.department_id, MAX(e.salary) AS first_salary
	FROM employees e 
	GROUP BY e.department_id
) AS `first_max_salary`
ON e.department_id = first_max_salary.department_id
WHERE e.salary < first_salary
GROUP BY e.department_id;
# Third Max salary
SELECT e.department_id, MAX(e.salary) AS third_max_salary
FROM employees e
JOIN(
	SELECT e.department_id, MAX(e.salary) AS second_salary
	FROM employees e
	JOIN (
		SELECT e.department_id, MAX(e.salary) AS first_salary
		FROM employees e 
		GROUP BY e.department_id
		) AS `first_max_salary`
	ON e.department_id = first_max_salary.department_id
	WHERE e.salary < first_salary
	GROUP BY e.department_id
) AS `second_max_salary`
ON  e.department_id = second_max_salary.department_id
WHERE e.salary < second_max_salary.second_salary
GROUP BY e.department_id
ORDER BY e.department_id;

# 18.	 Salary Challenge**
SELECT e.`first_name`, 
	   e.`last_name`,
       e.`department_id`
FROM employees AS e
WHERE e.`salary` > 
(SELECT AVG(em.`salary`) FROM employees AS em
WHERE e.`department_id` = em.`department_id`)
ORDER BY e.`department_id`
LIMIT 10;


# 19.	Departments Total Salaries
SELECT e.department_id, SUM(e.salary) AS total_salary
FROM employees e
GROUP BY e.department_id
ORDER BY e.department_id;