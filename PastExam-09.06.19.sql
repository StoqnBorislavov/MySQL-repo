# 1.	Section 1: Data Definition Language (DDL) – 40 pts
# 01.	Table Design
CREATE TABLE branches(
		id INT PRIMARY KEY AUTO_INCREMENT,
		name VARCHAR(30) UNIQUE NOT NULL
);