-- 1. Create a new file named group_by_exercises.sql
USE employees;

/* 2. In your script, use DISTINCT to find the unique titles in the titles table.
		How many unique titles have there ever been?
		7, query below. Could run COUNT(DISTINCT title) to get 7 explicitly
*/
SELECT DISTINCT title FROM titles;

/* 3. Write a query to to find a list of all unique last names of all employees
		that start and end with 'E' using GROUP BY.
*/
SELECT last_name as last_names_w_e
	FROM employees.employees
	WHERE last_name LIKE 'E%E'
	GROUP BY last_name; -- 5 names
    
/* 4. Write a query to to find all unique combinations of first and last names
		of all employees whose last names start and end with 'E'.
*/
SELECT first_name, last_name
	FROM employees.employees
	WHERE last_name LIKE 'E%E'
	GROUP BY first_name, last_name; -- 846 unique combinations of 899 total names
    
-- 5. Write a query to find the unique last names with a 'q' but not 'qu'.
-- Chleq, Lindqvist, Qiwen
SELECT last_name 
	FROM employees.employees
	WHERE last_name LIKE '%q%' AND last_name NOT LIKE '%qu%'
	GROUP BY last_name; -- Chleq, Lindqvist, Qiwen
    
-- 6. Add a COUNT() to your results (the query above) to find the number of employees with the same last name.
SELECT last_name, COUNT(last_name) as n_employes 
	FROM employees.employees
	WHERE last_name LIKE '%q%' AND last_name NOT LIKE '%qu%'
	GROUP BY last_name; -- 189, 190, 168

/* 7. Find all employees with first names 'Irena', 'Vidya', or 'Maya'.
	Use COUNT(*) and GROUP BY to find the number of employees for each gender with those names.
*/
SELECT first_name, gender, COUNT(*) as n_emp_each_gender
	FROM employees.employees
	WHERE first_name IN ('Irena', 'Vidya', 'Maya')
	GROUP BY first_name, gender;

/* 8. Using your query that generates a username for all of the employees, 
		generate a count employees for each unique username.
*/
SELECT LOWER(CONCAT((LEFT(first_name, 1)), LEFT(last_name, 4), '_',
                    SUBSTR(birth_date, 6, 2), SUBSTR(birth_date, 3, 2))) AS username,
					COUNT(*) AS num_users
	FROM employees.employees
	GROUP BY username
--     HAVING num_users > 1
    ORDER BY num_users DESC;

/* 9. From your previous query, are there any duplicate usernames? -- Yes
	What is the higest number of times a username shows up? -- 6, could use ORDER BY to find this quickly
	Bonus: How many duplicate usernames are there from your previous query? query below 13251
*/
SELECT COUNT(username)
FROM(SELECT LOWER(CONCAT((LEFT(first_name, 1)), LEFT(last_name, 4), '_',
                    SUBSTR(birth_date, 6, 2), SUBSTR(birth_date, 3, 2))) AS username,
					COUNT(*) as num_users
	FROM employees.employees
	GROUP BY username
	HAVING num_users > 1) AS username_counts;

-- total employees
SELECT COUNT(*) as num_emplyees FROM employees.employees; -- 300024 total employees

/* Bonus: More practice with aggregate functions:
   Determine the historic average salary for each employee. When you hear, read, or think "for each" with regard to SQL,
   you'll probably be grouping by that exact column.
*/
SELECT emp_no, COUNT(salary), SUM(salary), AVG(salary)
	FROM salaries
    GROUP BY emp_no;

/* Using the dept_emp table, count how many current employees work in each department.
   The query result should show 9 rows, one for each department and the employee count.
*/
SELECT dept_no, COUNT(emp_no)
	FROM dept_emp
	GROUP BY dept_no;

-- Determine how many different salaries each employee has had. This includes both historic and current.
SELECT emp_no, COUNT(salary), SUM(salary), AVG(salary)
	FROM salaries
    GROUP BY emp_no;

-- Find the maximum salary for each employee.
SELECT emp_no, MAX(salary)
	FROM salaries
    GROUP BY emp_no;

-- Find the minimum salary for each employee.
SELECT emp_no, MIN(salary)
	FROM salaries
    GROUP BY emp_no;

-- Find the standard deviation of salaries for each employee.
SELECT emp_no, STDDEV(salary)
	FROM salaries
    GROUP BY emp_no;

-- Now find the max salary for each employee where that max salary is greater than $150,000.
SELECT emp_no, MAX(salary)
	FROM salaries
    WHERE salary > 150000
    GROUP BY emp_no;
    
SELECT emp_no, MAX(salary)				-- I think this one is better because
	FROM salaries						-- the prompt says to filter the aggregated row
    GROUP BY emp_no
    HAVING MAX(salary) > 150000;
    
-- Find the average salary for each employee where that average salary is between $80k and $90k.
SELECT emp_no, MAX(salary)
	FROM salaries
    GROUP BY emp_no
    HAVING MAX(salary) BETWEEN 80000 AND 90000;
