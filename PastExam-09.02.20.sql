# Past Exam - 9 February 2020
# 1. Table Design

CREATE TABLE `countries`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL
);

CREATE TABLE `towns`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
`country_id` INT NOT NULL,
CONSTRAINT fk_towns_countries
FOREIGN KEY (`country_id`)
REFERENCES `countries`(`id`)
);

CREATE TABLE `stadiums`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(45) NOT NULL,
	`capacity` INT NOT NULL,
    `town_id` INT NOT NULL,
    CONSTRAINT fk_stadiums_towns
    FOREIGN KEY (`town_id`)
    REFERENCES `towns`(`id`)
);
CREATE TABLE `teams`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(45) NOT NULL,
    `established` DATE NOT NULL,
    `fan_base` BIGINT(20) DEFAULT 0 NOT NULL,
    `stadium_id` INT NOT NULL,
    CONSTRAINT fk_teams_stadiums
    FOREIGN KEY (`stadium_id`)
    REFERENCES `stadiums`(`id`)
);
CREATE TABLE `skills_data`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `dribbling` INT DEFAULT 0,
    `pace` INT DEFAULT 0,
    `passing` INT DEFAULT 0,
    `shooting` INT DEFAULT 0,
    `speed` INT DEFAULT 0,
    `strength` INT DEFAULT 0
);
CREATE TABLE `players`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(10) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `age` INT DEFAULT 0 NOT NULL,
    `position` CHAR(1) NOT NULL,
    `salary` DECIMAL(10,2) DEFAULT 0 NOT NULL,
    `hire_date` DATETIME,
    `skills_data_id` INT NOT NULL,
    `team_id` INT,
    CONSTRAINT fk_players_skills_data
    FOREIGN KEY (`skills_data_id`)
    REFERENCES `skills_data`(`id`),
    CONSTRAINT fk_players_teams
    FOREIGN KEY (`team_id`)
    REFERENCES `teams`(`id`)
);
CREATE TABLE `coaches`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(10) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `salary` DECIMAL(10,2) DEFAULT 0 NOT NULL,
    `coach_level` INT DEFAULT 0 NOT NULL
);
CREATE TABLE `players_coaches`(
	`player_id` INT,
    `coach_id` INT,
    CONSTRAINT pk_players_coaches
    PRIMARY KEY (`player_id`, `coach_id`),
    
    CONSTRAINT fk_players_coaches_players
    FOREIGN KEY (`player_id`)
    REFERENCES `players`(`id`),
    
    CONSTRAINT fk_players_coaches_coaches
    FOREIGN KEY (`coach_id`)
    REFERENCES `coaches`(`id`)
);

# 2. Insert
INSERT INTO `coaches`(`first_name`,`last_name`,`salary`,`coach_level`)
SELECT `first_name`, `last_name`, `salary` * 2, 
char_length(`first_name`)
FROM `players`
WHERE `age` >= 45; 

# 3. Update
UPDATE `coaches`
SET `coach_level` = `coach_level` + 1
WHERE LEFT(`first_name`, 1) = 'A'
AND `id` IN (SELECT `coach_id` FROM `players_coaches`);

# 4. DELETE 
DELETE FROM `players`
WHERE `age` >= 45;

# 5. Players 
SELECT first_name, age, salary FROM players
ORDER BY salary DESC;

# 6.	Young offense players without contract
SELECT p.id, 
		concat(p.first_name, ' ', p.last_name) AS full_name,
        p.age,
        p.position,
        p.hire_date
FROM players p
JOIN skills_data sd
ON p.skills_data_id = sd.id
WHERE position = 'A' 
AND hire_date IS NULL 
AND sd.strength > 50 
AND p.age < 23
ORDER BY salary, age;

# 7.	Detail info for all teams
SELECT 
    t.name AS team_name,
    t.established,
    t.fan_base,
    COUNT(p.id) AS players_count
FROM teams t
LEFT JOIN players p 
ON p.team_id = t.id
GROUP BY t.id
ORDER BY players_count DESC , t.fan_base DESC;

# 8.	The fastest player by towns
SELECT MAX(sd.speed) AS max_speed, t.name AS town_name
FROM towns t
LEFT JOIN stadiums s
ON t.id = s.town_id
LEFT JOIN teams te
ON s.id = te.stadium_id
LEFT JOIN players p
ON te.id = p.team_id
LEFT JOIN skills_data sd
ON sd.id = p.skills_data_id
WHERE te.name != 'Devify'
GROUP BY t.id
ORDER BY max_speed DESC, town_name;

# 9. Total salaries and players by country

SELECT c.name, 
	COUNT(p.id) AS total_count_of_players,
	SUM(p.salary) AS total_sum_of_salaries	
FROM players p
JOIN teams ts
ON ts.id = p.team_id
JOIN stadiums s
ON ts.stadium_id = s.id
JOIN towns t
ON s.town_id = t.id
RIGHT JOIN countries c
ON  t.country_id = c.id
GROUP BY c.id
ORDER BY total_count_of_players DESC, c.name;

# 10.	Find all players that play on stadium

