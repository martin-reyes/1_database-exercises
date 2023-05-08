USE quintela_2238;

/* 1. Using the example from the lesson, create a temporary table called
	employees_with_departments that contains first_name, last_name,
    and dept_name for employees currently with that department.
    Be absolutely sure to create this table on your own database.
    If you see "Access denied for user ...", it means that the query
    was attempting to write a new table to a database that you can only read.
*/

CREATE TEMPORARY TABLE employees_with_departments AS 
	(SELECT first_name, last_name, dept_name
	FROM employees.employees AS e
		JOIN employees.dept_emp AS de USING(emp_no)
		JOIN employees.departments AS d USING(dept_no)
	);
    
SELECT * FROM employees_with_departments;

/* Add a column named full_name to this table. It should be a VARCHAR whose
	length is the sum of the lengths of the first name and last name columns.

*/
ALTER TABLE employees_with_departments
	ADD full_name VARCHAR(30); -- not sure if I'm supposed to hard code 30 in here

SELECT * FROM employees_with_departments;

-- Update the table so that the full_name column contains the correct data.
UPDATE employees_with_departments SET full_name = CONCAT(first_name, ' ', last_name);

SELECT * FROM employees_with_departments;

-- Remove the first_name and last_name columns from the table.
ALTER TABLE employees_with_departments DROP COLUMN first_name,
										DROP COLUMN last_name;
                                        
SELECT * FROM employees_with_departments;

-- What is another way you could have ended up with this same table?
-- I could create this from the start (in the CREATE statement) by creating the full_name column in the subquery

-- --------------------------------------------------------------------------

/* 2. Create a temporary table based on the payment table from the sakila database.

Write the SQL necessary to transform the amount column such that it is stored 
	as an integer representing the number of cents of the payment. 
    For example, 1.99 should become 199.
*/
-- inspect payment table
SELECT * FROM sakila.payment;

CREATE TEMPORARY TABLE payment_with_cents AS 
	(SELECT *
	FROM sakila.payment
	);
    
SELECT * FROM payment_with_cents;

-- Update the table so that the amount column is in number of cents (instead of dollars).
UPDATE payment_with_cents SET amount = amount * 100;

SELECT * FROM payment_with_cents;

-- -----------------------------------------------------------------------------

/* 3. Go back to the employees database. Find out how the current average pay in
	each department compares to the overall current pay for everyone at the company.
    For this comparison, you will calculate the z-score for each salary.
    In terms of salary, what is the best department right now to work for? The worst?
    Best: Sales (.973), Marketing (.465), Finance (.378)
    Worst: HR (-.48), QM (-.38), Customer Service (-.27)
*/
USE employees;

-- avg pay in each dept sub q
SELECT dept_name, AVG(salary) AS avg_salary
FROM (SELECT * FROM salaries AS s WHERE s.to_date > NOW()) AS curr_s
	JOIN (SELECT * FROM dept_emp AS de WHERE de.to_date > NOW()) AS curr_de USING (emp_no)
	JOIN departments AS d USING (dept_no)
GROUP BY dept_name;

-- overall average and std of current pay for everyone
SELECT AVG(salary) AS avg_salary, STDDEV(salary) AS std_salary
FROM (SELECT * FROM salaries AS s WHERE s.to_date > NOW()) AS curr_s;  -- 72012.2359, 17309.95933634675

-- testing to see if scalar subqueries work as I want
SELECT (72012 - (SELECT AVG(salary) AS avg_salary
				FROM (SELECT * FROM salaries AS s WHERE s.to_date > NOW()) AS curr_s)) /
			  (SELECT STDDEV(salary) AS std_salary
				FROM (SELECT * FROM salaries AS s WHERE s.to_date > NOW()) AS curr_s);

-- avg pay in each dept with z_score column
SELECT *,
	-- z-score column
	CASE
		WHEN avg_salary IS NOT NULL THEN 
			(avg_salary - (SELECT AVG(salary) AS avg_salary	
							FROM (SELECT * FROM salaries AS s WHERE s.to_date > NOW()) AS curr_s)) /
						  (SELECT STDDEV(salary) AS std_salary
							FROM (SELECT * FROM salaries AS s WHERE s.to_date > NOW()) AS curr_s)
		ELSE NULL
	END AS z_score
FROM (
		SELECT dept_name, AVG(salary) AS avg_salary
		FROM (SELECT * FROM salaries AS s WHERE s.to_date > NOW()) AS curr_s
			-- must filter with line below or else emp_no on current salaries will match with historic de emp_no's
			JOIN (SELECT * FROM dept_emp AS de WHERE de.to_date > NOW()) AS curr_de USING (emp_no)
			JOIN departments AS d USING (dept_no)
		GROUP BY dept_name
        ) AS avg_pay_each_dept
ORDER BY z_score DESC;

-- -----------------------------------------------------

/* BONUS Determine the overall historic average department average salary, 
	the historic overall average, and the historic z-scores for salary. 
    Do the z-scores for current department average salaries (from exercise 3)
    tell a similar or a different story than the historic department salary z-scores? *Similar*
    Best: Sales (1.01), Marketing (.486), Finance (.401)
    Worst: HR (-.494), QM (-.393), Customer Service (-.30)

	Hint: How should the SQL code used in exercise 3 be
			altered to instead use historic salary values?		*I wrote comments on changes*
*/
 
-- avg pay in each dept with z_score column
SELECT *,
	-- z-score column
	CASE
		WHEN avg_salary IS NOT NULL THEN 								-- *historic Z-score*
			(avg_salary - (SELECT AVG(salary) AS avg_salary				-- *historic AVG*
							FROM (SELECT * FROM salaries AS s WHERE s.to_date < NOW()) AS curr_s)) /
						  (SELECT STDDEV(salary) AS std_salary			-- *historic STD*
							FROM (SELECT * FROM salaries AS s WHERE s.to_date < NOW()) AS curr_s)
		ELSE NULL
	END AS z_score
FROM (	-- historic_avg_pay_each_dept
		SELECT dept_name, AVG(salary) AS avg_salary
													-- *historic salaries*
		FROM (SELECT * FROM salaries AS s WHERE s.to_date < NOW()) AS curr_s
						-- *change to prev and curr employees (curr employees also have historic averages)*							
			JOIN dept_emp AS de USING (emp_no)
			JOIN departments AS d USING (dept_no)
		GROUP BY dept_name
        ) AS avg_pay_each_dept
ORDER BY z_score DESC;

