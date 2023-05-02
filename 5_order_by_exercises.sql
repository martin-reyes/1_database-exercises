USE employees;
SELECT * FROM employees.employees;
DESCRIBE employees.employees;
-- 1. Create a new file named order_by_exercises.sql and copy in the contents of your exercise from the previous lesson.
		-- Pasted on the bottom
/* 2. Find all employees with first names 'Irena', 'Vidya', or 'Maya', and order your results returned by first name. 
		What was the first and last name in the first row of the results? 
		What was the first and last name of the last person in the table?

*/
SELECT emp_no, first_name,last_name FROM employees.employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
ORDER BY ;
/* 3. Find all employees with first names 'Irena', 'Vidya', or 'Maya', and order your results returned by first name and then last name.
		What was the first and last name in the first row of the results?
		What was the first and last name of the last person in the table?

*/
SELECT emp_no, first_name,last_name FROM employees.employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
ORDER BY ;
/* 4. Find all employees with first names 'Irena', 'Vidya', or 'Maya', and order your results returned by last name and then first name.
		What was the first and last name in the first row of the results?
		What was the first and last name of the last person in the table?

*/
SELECT emp_no, first_name,last_name FROM employees.employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
ORDER BY ;
/* 5. Write a query to to find all employees whose last name starts and ends with 'E'. Sort the results by their employee number. 
			Number of employees returned:
			The first employee number and their first and last name:
			the last employee number with their first and last name:

*/
SELECT DISTINCT last_name FROM employees.employees
WHERE last_name LIKE 'E%E'
ORDER BY ;
/* 6. Write a query to to find all employees whose last name starts and ends with 'E'. Sort the results by their hire date, so that the newest employees are listed first.
			Number of employees returned:
            The name of the newest employee:
            The name of the oldest employee:

*/
SELECT DISTINCT last_name FROM employees.employees
WHERE last_name LIKE 'E%E'
ORDER BY;
/* 7. Find all employees hired in the 90s and born on Christmas. Sort the results so that the oldest employee who was hired last is the first result.
			Number of employees returned:
            The name of the oldest employee who was hired last: 
            The name of the youngest employee who was hired first:

*/
SELECT * FROM employees.employees 
WHERE hire_date LIKE '199%'
		AND hire_date LIKE '%12-25'
ORDER BY ;




/* Exercise 4_where_advanced_exercises
-- 1. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya' using IN. What is the employee number of the top three results?
SELECT emp_no, first_name,last_name FROM employees.employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya');
	-- 10200, 10397, 10610
-- 2. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', as in Q2, but use OR instead of IN. What is the employee number of the top three results? Does it match the previous question?
SELECT emp_no, first_name,last_name FROM employees.employees
WHERE first_name = 'Irena' OR first_name = 'Vidya' OR first_name = 'Maya';
	-- 10200, 10397, 10610. Yes
-- 3. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', using OR, and who is male. What is the employee number of the top three results.
SELECT emp_no, first_name,last_name, gender
FROM employees.employees
WHERE (first_name = 'Irena' OR first_name = 'Vidya' 
		OR first_name = 'Maya') AND gender = 'M';
	-- 10200, 10397, 10821
-- 4. Find all unique last names that start with 'E'.
SELECT DISTINCT last_name FROM employees.employees
WHERE last_name LIKE 'E%';
-- 5. Find all unique last names that start or end with 'E'.
SELECT DISTINCT last_name FROM employees.employees
WHERE last_name LIKE 'E%' OR last_name LIKE '%E';
-- 6. Find all unique last names that end with E, but does not start with E?
SELECT DISTINCT last_name FROM employees.employees
WHERE last_name NOT LIKE 'E%' AND last_name LIKE '%E';
-- 7. Find all unique last names that start and end with 'E'.
SELECT DISTINCT last_name FROM employees.employees
WHERE last_name LIKE 'E%E';
-- 8. Find all current or previous employees hired in the 90s. Enter a comment with top three employee numbers.
SELECT * FROM employees.employees 
WHERE hire_date LIKE '199%';
-- 10008, 10011, 10012
-- 9. Find all current or previous employees born on Christmas. Enter a comment with top three employee numbers.
SELECT * FROM employees.employees 
WHERE hire_date LIKE '%12-25';
-- 10050, 10456, 10463
-- 10. Find all current or previous employees hired in the 90s and born on Christmas. Enter a comment with top three employee numbers.
SELECT * FROM employees.employees 
WHERE hire_date LIKE '199%'
		AND hire_date LIKE '%12-25';
-- 11. Find all unique last names that have a 'q' in their last name.
SELECT DISTINCT last_name FROM employees.employees
WHERE last_name LIKE '%q%';
-- 12. Find all unique last names that have a 'q' in their last name but not 'qu'.
SELECT DISTINCT last_name FROM employees.employees
WHERE last_name LIKE '%q%'
		AND last_name NOT LIKE '%qu%';
*/