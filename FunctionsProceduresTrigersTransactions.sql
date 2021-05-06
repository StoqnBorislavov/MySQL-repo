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


# 6.	Employees by Salary Level
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(level_of_salary VARCHAR(10))
BEGIN
	SELECT e.first_name, e.last_name, ufn_get_salary_level(e.salary)
	FROM employees e
    WHERE ufn_get_salary_level(e.salary) = level_of_salary
	ORDER BY e.first_name DESC, e.last_name DESC;
END $$
DELIMITER ;
CALL usp_get_employees_by_salary_level('High');	

# 7.	Define Function
DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS BIT
DETERMINISTIC
BEGIN
	DECLARE result BIT;
	DECLARE word_length INT;
    DECLARE current_index INT;
    
    SET result := 1;
    SET word_length := char_length(word);
    SET current_index := 1;
    WHILE (current_index <= word_length) DO
		IF set_of_letters NOT LIKE (concat('%', substr(word, current_index, 1), '%')) THEN
			SET result := 0;
        END IF;
        SET current_index := current_index + 1;
    END WHILE;
    RETURN result;
END $$
DELIMITER ;
SELECT ufn_is_word_comprised('oistmiahf', 'halves');

# 8.	Find Full Name
DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
	SELECT concat(ah.first_name, ' ', ah.last_name) AS full_name
    FROM account_holders ah
	ORDER BY full_name ASC;
END $$
DELIMITER ;
CALL usp_get_holders_full_name();

# 9.	People with Balance Higher Than

DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(sum_of_balance INT) 
BEGIN
		SELECT ah.first_name, ah.last_name
		FROM account_holders ah
		JOIN accounts a
		ON ah.id = a.account_holder_id
		GROUP BY a.account_holder_id
		HAVING SUM(a.balance) > sum_of_balance
		ORDER BY ah.first_name, ah.last_name, a.id;
END $$
DELIMITER ;
CALL usp_get_holders_with_balance_higher_than(7000);

# 10.	Future Value Function
DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(sum DECIMAL(19,4), interest DOUBLE, years INT)
RETURNS DECIMAL(19,4)
DETERMINISTIC
BEGIN
	RETURN sum * POW(1 + interest, years);
END $$
DELIMITER ;
SELECT ufn_calculate_future_value(1000, 0.1, 5);

# 11.	Calculating Interest
DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account(account_id INT, interest_rate DECIMAL(19,4))
BEGIN
	SELECT a.id AS account_id, ah.first_name, ah.last_name,
			a.balance AS current_balance,
            ufn_calculate_future_value(a.balance, interest_rate, 5) AS balance_in_5_years
	FROM account_holders ah
    JOIN accounts a
    ON a.account_holder_id = ah.id
    WHERE a.id = account_id;
END $$
DELIMITER ;
CALL usp_calculate_future_value_for_account(1, 0.1);

# 12.	Deposit Money
DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
	IF(SELECT COUNT(*) FROM accounts WHERE id = account_id) = 0
		OR (money_amount <= 0)
		THEN ROLLBACK;
    ELSE 
		UPDATE accounts
        SET balance = balance + money_amount
        WHERE id = account_id;
	END IF;
END $$

# 13.	Withdraw Money
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
		IF(SELECT COUNT(*) FROM accounts WHERE id = from_account_id) = 0
		OR (money_amount <= 0)
        OR ((SELECT a.balance FROM accounts a WHERE a.id = account_id) <= money_amount) 
		THEN ROLLBACK;
    ELSE 
		UPDATE accounts
        SET balance = balance - money_amount
        WHERE id = account_id;
	END IF;
END $$
DELIMITER ;
CALL usp_withdraw_money(1, 10);
SELECT * FROM accounts
WHERE id = 1;
# 14.	Money Transfer
DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
    IF(SELECT COUNT(*) FROM accounts WHERE id = from_account_id) = 0
		OR (SELECT COUNT(*) FROM accounts WHERE id = to_account_id) = 0
		OR (amount <= 0)
        OR ((SELECT a.balance FROM accounts a WHERE a.id = from_account_id) <= amount) 
        OR (from_account_id = to_account_id)
		THEN ROLLBACK;
    ELSE 
		UPDATE accounts AS a
        SET a.balance = a.balance - amount
        WHERE a.id = from_account_id;
        UPDATE accounts AS a
        SET a.balance = a.balance + amount
        WHERE a.id = to_account_id;
	END IF;
END $$
DELIMITER ;
CALL usp_transfer_money(1, 2, 10);
SELECT * FROM accounts 
WHERE id IN (1,2)
ORDER BY id;

# 15.	Log Accounts Trigger
CREATE TABLE logs(
				log_id INT PRIMARY KEY AUTO_INCREMENT,
				account_id INT,
				old_sum DECIMAL(19,2),
				new_sum DECIMAL(19,2)
				);
DELIMITER $$
CREATE TRIGGER tr_update_accounts
AFTER UPDATE
ON accounts
FOR EACH ROW
BEGIN
	INSERT INTO logs(account_id, old_sum, new_sum)
    VALUES(OLD.id, OLD.balance, NEW.balance);
END $$