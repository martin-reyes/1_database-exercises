/* 1. Write a query that returns all employees, their department number,
	their start date, their end date, and a new column 'is_current_employee' 
    that is a 1 if the employee is still with the company and 0 if not.
    DO NOT WORRY ABOUT DUPLICATE EMPLOYEES.
*/
SELECT *,
	IF(de.to_date > NOW(), 1, 0)
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
SELECT
	COUNT(CAS)
	FROM employees.employees AS e;
    
    
/* 4. What is the current average salary for each of the following department
    groups: R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?
*/    


-- BONUS Remove duplicate employees from exercise 1.