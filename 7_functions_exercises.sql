USE employees;
SELECT * FROM employees.employees;
DESCRIBE employees.employees;

-- 1. Copy the order by exercise and save it as functions_exercises.sql.
	-- saved below
/* 2. Write a query to to find all employees whose last name starts and ends with 'E'.
	Use concat() to combine their first and last name together as a single column named full_name.
*/
SELECT CONCAT(first_name, " ", last_name) as full_name FROM employees.employees
WHERE last_name LIKE 'E%E';
-- 3. Convert the names produced in your last query to all uppercase.
SELECT UPPER(CONCAT(first_name, " ", last_name)) as full_name FROM employees.employees
WHERE last_name LIKE 'E%E';
-- 4. Use a function to determine how many results were returned from your previous query.
SELECT COUNT(last_name) FROM employees.employees
WHERE last_name LIKE 'E%E';
/* 5. Find all employees hired in the 90s and born on Christmas.
		Use datediff() function to find how many days they have been working at the company
        (Hint: You will also need to use NOW() or CURDATE()),
*/
SELECT first_name, last_name, hire_date, birth_date, DATEDIFF(NOW(), hire_date) AS days_worked
FROM employees.employees 
WHERE hire_date LIKE '199%'
		AND hire_date LIKE '%12-25';
-- 6. Find the smallest and largest current salary from the salaries table.
SELECT MIN(salary), MAX(salary) FROM salaries;

/* 7.  Use your knowledge of built in SQL functions to generate a username for all of the employees.
		A username should be all lowercase, and consist of the first character of the employees first name,
        the first 4 characters of the employees last name, an underscore, the month the employee was born,
        and the last two digits of the year that they were born.
        Below is an example of what the first 5 rows will look like:

		+------------+------------+-----------+------------+
		| username   | first_name | last_name | birth_date |
		+------------+------------+-----------+------------+
		| gface_0953 | Georgi     | Facello   | 1953-09-02 |
		| bsimm_0664 | Bezalel    | Simmel    | 1964-06-02 |
		| pbamf_1259 | Parto      | Bamford   | 1959-12-03 |
		| ckobl_0554 | Chirstian  | Koblick   | 1954-05-01 |
		| kmali_0155 | Kyoichi    | Maliniak  | 1955-01-21 |
		+------------+------------+-----------+------------+
		5 rows in set (0.05 sec)
*/
SELECT CONCAT(LOWER(LEFT(first_name, 1)), LOWER(RIGHT(last_name, 4)),
		"_", SUBSTR( birth_date, 6, 2), SUBSTR(birth_date, 3, 2)) AS username,
		first_name, last_name, birth_date
FROM employees;


-- ------------------------------------

-- -- 1. Create a new file named order_by_exercises.sql and copy in the contents of your exercise from the previous lesson.
-- 		-- Pasted on the bottom
-- /* 2. Find all employees with first names 'Irena', 'Vidya', or 'Maya', and order your results returned by first name. 
-- 		What was the first and last name in the first row of the results? Irena Reutenauer
-- 		What was the first and last name of the last person in the table? Vidya Simmen
-- 		query below
-- */
-- SELECT emp_no, first_name,last_name FROM employees.employees
-- WHERE first_name IN ('Irena', 'Vidya', 'Maya')
-- ORDER BY first_name ASC;
-- /* 3. Find all employees with first names 'Irena', 'Vidya', or 'Maya', and order your results returned by first name and then last name.
-- 		What was the first and last name in the first row of the results? Irena Acton
-- 		What was the first and last name of the last person in the table? Vidya Zweizig
-- 		query below
-- */
-- SELECT emp_no, first_name,last_name FROM employees.employees
-- WHERE first_name IN ('Irena', 'Vidya', 'Maya')
-- ORDER BY first_name ASC, last_name ASC;
-- /* 4. Find all employees with first names 'Irena', 'Vidya', or 'Maya', and order your results returned by last name and then first name.
-- 		What was the first and last name in the first row of the results? Irena Acton
-- 		What was the first and last name of the last person in the table? Maya Zyda
-- 		query below
-- */
-- SELECT emp_no, first_name,last_name FROM employees.employees
-- WHERE first_name IN ('Irena', 'Vidya', 'Maya')
-- ORDER BY last_name ASC, first_name ASC;
-- /* 5. Write a query to to find all employees whose last name starts and ends with 'E'. Sort the results by their employee number. 
-- 		Number of employees returned:
-- 		The first employee number and their first and last name: 10021 Ramzi Erde
-- 		the last employee number with their first and last name: 499648 Tadahiro Erde
-- 		query below
-- */
-- SELECT DISTINCT emp_no, first_name, last_name FROM employees.employees
-- WHERE last_name LIKE 'E%E'
-- ORDER BY emp_no ASC;
-- /* 6. Write a query to to find all employees whose last name starts and ends with 'E'. Sort the results by their hire date, so that the newest employees are listed first.
-- 		Number of employees returned:
-- 		The name of the newest employee: Teiji Eldridge
-- 		The name of the oldest employee: Sergi Erde
-- 		query below
-- */
-- SELECT hire_date, first_name, last_name
-- FROM employees.employees
-- WHERE last_name LIKE 'E%E'
-- ORDER BY hire_date ASC;
-- /* 7. Find all employees hired in the 90s and born on Christmas. Sort the results so that the oldest employee who was hired last is the first result.
-- 		Number of employees returned: 346
-- 		The name of the oldest employee who was hired last: Vidya VanScheik
-- 		The name of the youngest employee who was hired first: Lena Lenart
-- 		query below
-- */
-- SELECT hire_date, birth_date, first_name, last_name 
-- FROM employees.employees 
-- WHERE hire_date LIKE '199%'
-- 		AND hire_date LIKE '%12-25'
-- ORDER BY hire_date DESC, birth_date ASC;