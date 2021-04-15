CREATE DATABASE minions;
USE minions;

CREATE TABLE minions(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20),
    age INT(11)
);

CREATE TABLE towns(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(20)
);

ALTER TABLE minions
ADD COLUMN town_id INT(11);

ALTER TABLE minions
ADD CONSTRAINT fk_minions_towns FOREIGN KEY(town_id) REFERENCES towns(id);

INSERT INTO towns(name) VALUES('Berlin');

INSERT INTO minions(name, age, town_id) VALUES('Stamat', 102, 3);

SELECT * FROM minions;

CREATE DATABASE pesho_db;
USE pesho_db;

CREATE TABLE people(
	id INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
    name VARCHAR(200) NOT NULL,
    picture BLOB(2048),
    height DOUBLE(5,2),
    weight DOUBLE(5,2),
    gender CHAR(1) NOT NULL,
    birthdate DATE NOT NULL,
    biography TEXT
);
INSERT INTO people(name, picture, height, weight, gender, birthdate, biography) 
VALUES('pesho', NULL, 1.80, 45.0, 'm', '1899-01-28', 'az sum pesh0'),
	  ('gosho', NULL, 1.65, 67.0, 'm', '1899-01-28', 'az sum gosho'),
	  ('pesho', NULL, 1.80, 45.0, 'm', '1899-01-28', 'az sum pesh0'),
      ('gosho1', NULL, 1.65, 67.0, 'm', '1899-01-28', 'az sum gosho'),
	  ('pesho2', NULL, 1.80, 45.0, 'm', '1899-01-28', 'az sum pesh0');
      
SELECT * FROM people;

CREATE TABLE users(
	id INT(11) PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL unique,
    password VARCHAR(26) NOT NULL,
    profile_picture BLOB(900),
    last_login_time DATETIME,
    is_deleted BIT
);
INSERT INTO users(username, password, profile_picture, last_login_time, is_deleted) 
VALUES('pesho', '123', NULL, DATE(now()), 1),
	  ('gosho1', '123', NULL, DATE(now()), 0),
	  ('pesho2', '123', NULL, DATE(now()), 1),
      ('gosho3', '123', NULL, DATE(now()), 0),
	  ('pesho4', '123', NULL, DATE(now()), 1);
      
SELECT * FROM users;

ALTER TABLE users
MODIFY COLUMN id INT(11);

ALTER TABLE users
DROP PRIMARY KEY;

ALTER TABLE users
ADD PRIMARY KEY(id, username);

ALTER TABLE users
MODIFY COLUMN last_login_time DATETIME DEFAULT CURRENT_TIMESTAMP;

INSERT INTO users(username, password, profile_picture, last_login_time, is_deleted) 
VALUES('pesho5', '1232', NULL, DEFAULT, 1);

SELECT * FROM users;

DROP DATABASE pesho_db;

CREATE DATABASE movies;
USE movies;

CREATE TABLE directors(
	 id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
     director_name VARCHAR(30) NOT NULL,
     notes VARCHAR(50)
);
CREATE TABLE genres(
	 id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	 genre_name VARCHAR(30) NOT NULL,
     notes VARCHAR(50)
);
CREATE TABLE categories(
	 id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
     category_name VARCHAR(30) NOT NULL,
     notes VARCHAR(50)
);
CREATE TABLE movies(
	 id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
     title VARCHAR(30) NOT NULL,
     director_name VARCHAR(20) NOT NULL,
     copyright_year INT(11) NOT NULL,
     length TIME NOT NULL,
     genre_id VARCHAR(30) NOT NULL,
     category_id VARCHAR(30) NOT NULL,
     rating INT(11),
     notes VARCHAR(50)
);

INSERT INTO directors(director_name, notes) 
VALUES('pesho', 'az sum pesho'),
	  ('gosho1', 'az ne sum pesho'),
	  ('pesho2', 'az sum pesho2'),
      ('gosho3', 'az sum gosho3'),
	  ('pesho4', NULL);
      
INSERT INTO genres(genre_name, notes) 
VALUES('pesho', 'az sum pesho'),
	  ('gosho1', 'az ne sum pesho'),
	  ('pesho2', 'az sum pesho2'),
      ('gosho3', 'az sum gosho3'),
	  ('pesho4', NULL);
      
INSERT INTO categories(category_name, notes) 
VALUES('pesho', 'az sum pesho'),
	  ('gosho1', 'az ne sum pesho'),
	  ('pesho2', 'az sum pesho2'),
      ('gosho3', 'az sum gosho3'),
	  ('pesho4', NULL);
      
INSERT INTO movies(title, director_name, copyright_year, length, genre_id, category_id, rating, notes) 
VALUES('123', 'az sum pesho', '2020', '2:20', 'az sum pesho', 'az sum pesho', 3, NULL),
	  ('gosho1', 'az sum gosho1', '2021', '2:30', 'az sum gosho1', 'az sum pesho', 2, NULL),
	  ('3455', 'az sum gosho1', '2021', '2:30', 'az sum gosho1', 'az sum pesho', 2, NULL),
      ('56375', 'az sum gosho1', '2021', '2:30', 'az sum gosho1', 'az sum pesho', 2, NULL),
	  ('g345345', 'az sum gosho1', '2021', '2:30', 'az sum gosho1', 'az sum pesho', 2, 'best movie');
      
SELECT * FROM movies;
