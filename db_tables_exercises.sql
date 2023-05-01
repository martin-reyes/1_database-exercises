-- 1. open mysql workbench and log in to db server
-- 2. save work in this sql file
SHOW DATABASES; -- 3. List dbs
USE albums_db; -- 4. Use albums_db
SELECT database(); -- 5. show current db
SHOW TABLES; -- 6. list tables-- 

USE employees; -- 7. switch to employees_db
SELECT database(); -- 8. show current db
SHOW TABLES; -- 9. list tables
SELECT * FROM employees.employees; -- 10a. explore employees table
SHOW CREATE TABLE employees.employees; -- result below
DESCRIBE employees.employees;
/*
CREATE TABLE `employees` (
  `emp_no` int NOT NULL,
  `birth_date` date NOT NULL,
  `first_name` varchar(14) NOT NULL,
  `last_name` varchar(16) NOT NULL,
  `gender` enum('M','F') NOT NULL,
  `hire_date` date NOT NULL,
  PRIMARY KEY (`emp_no`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1

10b. What different data types are present on this table?
	int, date, varchar(14), varchar(16), enum('M','F'), date
*/

/*
For the answer's below I'm assuming they aren't talking about primary/foreign keys, which are int's and char's
11. Which table(s) do you think contain a numeric type column?
	salary because this data is numeric

12. Which table(s) do you think contain a string type column?
	department, employees, and titles because there are columns with names.

13. Which table(s) do you think contain a date type column? 
	All tables but the 'departments' one have dates

14. What is the relationship between the employees and the departments tables?
	These tables don't share identical columns, but there are columns in these table and others that may be able to relate/join these tables
*/
SHOW CREATE TABLE dept_manager; -- 15. Show the SQL that created the dept_manager table
/*
Write the SQL it takes to show this as your exercise solution.
CREATE TABLE `dept_manager` (
  `emp_no` int NOT NULL,
  `dept_no` char(4) NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  PRIMARY KEY (`emp_no`,`dept_no`),
  KEY `dept_no` (`dept_no`),
  CONSTRAINT `dept_manager_ibfk_1` FOREIGN KEY (`emp_no`) REFERENCES `employees` (`emp_no`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `dept_manager_ibfk_2` FOREIGN KEY (`dept_no`) REFERENCES `departments` (`dept_no`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=latin1
*/
