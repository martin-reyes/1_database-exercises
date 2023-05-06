/* 1. Write a query that returns all employees, their department number,
	their start date, their end date, and a new column 'is_current_employee' 
    that is a 1 if the employee is still with the company and 0 if not.
    DO NOT WORRY ABOUT DUPLICATE EMPLOYEES.
*/
SELECT *,
	IF(de.to_date > NOW(), 1, 0) AS 'is_current_employee'
FROM dept_emp AS de;

/* 2. Write a query that returns all employee names (previous and current), 
	and a new column 'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z' 
	depending on the first letter of their last name.
*/
SELECT CONCAT(e.first_name, ' ', e.last_name) AS name, 
		CASE
			WHEN LEFT(e.last_name, 1) BETWEEN 'A' AND 'H' THEN 'A-H'
            WHEN LEFT(e.last_name, 1) BETWEEN 'I' AND 'Q' THEN 'I-Q'
            WHEN LEFT(e.last_name, 1) BETWEEN 'R' AND 'Z' THEN 'R-Z'
            ELSE NULL
		END AS alpha_group
	FROM employees.employees AS e;
    
    
-- 3. How many employees (current or previous) were born in each decade?
	
-- Checking min and max birth dates
SELECT *
FROM employees
ORDER BY birth_date DESC;

-- creating decade column, sub query
SELECT *,
CASE 
	WHEN birth_date IS NOT NULL THEN CONCAT(SUBSTR(birth_date, 3, 1), 0)
	ELSE NULL
END AS decade
FROM employees AS e;

-- group by decades and count employees
SELECT COUNT(emp_no) AS num_employees, decade
FROM (
		SELECT *,
		CASE 
			WHEN birth_date IS NOT NULL THEN CONCAT(SUBSTR(birth_date, 3, 1), 0)
			ELSE NULL
		END AS decade
		FROM employees AS e) AS emp_w_decade
GROUP BY decade;
    
    
/* 4. What is the current average salary for each of the following department
    groups: R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?
*/ 

-- -- table of current employees (ids) with their salaries, dept, and dept_group
-- SELECT *,
-- 	CASE
-- 		WHEN dept_name LIKE 'Re%' OR dept_name LIKE 'De%' THEN 'R&D'
--         WHEN dept_name LIKE 'Sa%' OR dept_name LIKE 'Ma%' THEN 'Sales & Marketing'
--         WHEN dept_name LIKE 'Pr%' OR dept_name LIKE 'Qu%' THEN 'Prod & QM'
--         WHEN dept_name LIKE 'Fi%' OR dept_name LIKE 'Hu%' THEN 'Finance & HR'
--         WHEN dept_name LIKE 'Cu%' THEN 'Customer Service'
--         ELSE NULL
--     END AS department_group
-- FROM departments AS d
-- JOIN dept_emp AS de USING (dept_no)
-- JOIN salaries AS s ON s.emp_no = de.emp_no 
-- 					AND s.to_date > NOW();


SELECT department_group, AVG(salary)
FROM (
		SELECT salary,
			CASE
				WHEN dept_name LIKE 'Re%' OR dept_name LIKE 'De%' THEN 'R&D'
				WHEN dept_name LIKE 'Sa%' OR dept_name LIKE 'Ma%' THEN 'Sales & Marketing'
				WHEN dept_name LIKE 'Pr%' OR dept_name LIKE 'Qu%' THEN 'Prod & QM'
				WHEN dept_name LIKE 'Fi%' OR dept_name LIKE 'Hu%' THEN 'Finance & HR'
				WHEN dept_name LIKE 'Cu%' THEN 'Customer Service'
				ELSE NULL
			END AS department_group
		FROM departments AS d
		JOIN dept_emp AS de USING (dept_no)
		JOIN salaries AS s ON s.emp_no = de.emp_no 
							AND s.to_date > NOW()) AS dept_groups_and_salaries
GROUP BY department_group;

-- BONUS Remove duplicate employees from exercise 1.

-- -- original query but duplicate employees removed and their latest to_dates are taken
-- 	SELECT emp_no, MAX(to_date) as max_date
-- 		FROM (SELECT *,
-- 				IF(de.to_date > NOW(), 1, 0) AS 'is_current_employee'
-- 				FROM dept_emp AS de) AS de_mod
-- 		GROUP BY emp_no; 

SELECT *,
	IF(max_date > NOW(), 1, 0) AS 'is_current_employee'
FROM (SELECT emp_no, MAX(to_date) AS max_date
		FROM (SELECT *,
				IF(de.to_date > NOW(), 1, 0) AS 'is_current_employee'
				FROM dept_emp AS de) AS de_w_curr_status
		GROUP BY emp_no) AS de_w_curr_status_dupl_gone;



