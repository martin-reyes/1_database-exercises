-- 1. Find all the current employees with the same hire date as employee 101010 using a subquery.
SELECT CONCAT(e.first_name, ' ', e.last_name) AS employee_name, e.hire_date
FROM employees.employees AS e
WHERE e.hire_date = (SELECT e.hire_date
						FROM employees.employees AS e
						WHERE e.emp_no = 101010); -- 69 rows



-- 2. Find all the titles ever held by all current employees with the first name Aamod.

/* All titles *currently* held by all current employees name Aamod, NOT the question
SELECT t.title
FROM titles AS t
WHERE t.emp_no IN (SELECT e.emp_no
					FROM employees.employees AS e
					WHERE e.first_name = 'Aamod')
		AND t.to_date > NOW(); -- 168 rows
*/

-- Find all titles, use DISTINCT to find distinct titles
SELECT t.title
FROM titles AS t
-- of current Aamod's
WHERE t.emp_no IN (SELECT e.emp_no
					FROM employees.employees AS e
						JOIN dept_emp AS de USING (emp_no)
                        -- first name Aamod
					WHERE e.first_name = 'Aamod'
						-- current
						AND de.to_date > NOW()); -- 251 rows

/* 3. How many people in the employees table are no longer working for the company?
		Give the answer in a comment in your code. -- 85108
*/
-- Find count
SELECT COUNT(*) AS num_employees
FROM employees.employees e
WHERE e.emp_no NOT IN (SELECT de.emp_no
					FROM dept_emp AS de
                    -- not current employees
                    WHERE de.to_date > NOW());
                    

-- 4. Find all the current department managers that are female. List their names in a comment in your code.
-- Isamu Legleitner, Karsten Sigstam, Leon DasSarma, Hilary Kambil
-- Find all department managers
SELECT CONCAT(e.first_name, " ", e.last_name) AS full_name, e.gender
FROM employees.employees AS e
-- that are female
WHERE e.gender = 'F'
	-- that are current
	AND e.emp_no IN (SELECT dm.emp_no
						FROM dept_manager AS dm
                        WHERE dm.to_date > NOW());


/* 5. Find all the employees who currently have a higher salary than the companies overall,
	historical average salary.
*/
-- Find all employee (names)
SELECT CONCAT(e.first_name, " ", e.last_name) AS full_name, s.salary
FROM employees.employees AS e
	JOIN salaries AS s USING (emp_no)
-- salary higher than avg historical salary
WHERE s.salary > (SELECT AVG(salary) AS avg_salary
					FROM salaries
                    WHERE to_date < NOW())
	-- current employees
	AND s.to_date > NOW();
    -- ORDER BY s.salary; chacked no salary < avg

-- double check, GOOD
-- did ORDER BY ASC on salary to make sure MIN of my table was higher than avg
-- SELECT AVG(salary) AS avg_salary
-- 					FROM salaries
--                     WHERE to_date < NOW(); -- 63054.4341


/* 6. How many current salaries are within 1 standard deviation of the current highest salary?
	(Hint: you can use a built in function to calculate the standard deviation.)
    What percentage of all salaries is this?
	Hint You will likely use multiple subqueries in a variety of ways
	Hint It's a good practice to write out all of the small queries that you can. 
    Add a comment above the query showing the number of rows returned. 
    You will use this number (or the query that produced it) in other, larger queries.
    
    -- 83
*/
-- Count salaries
SELECT COUNT(*) -- * to check salaries
FROM salaries AS s
-- that are current
WHERE s.to_date > NOW() 
-- and that are between MAX and (MAX - STD). Can uses > instead of BETWEEN bc none will be above max
	AND s.salary > (SELECT MAX(salary) 
							FROM salaries AS s
							WHERE s.to_date > NOW())
					- (SELECT STDDEV(salary) 
							FROM salaries AS s
							WHERE s.to_date > NOW());


-- BONUS
-- 1. Find all the department names that currently have female managers.
SELECT d.dept_name
FROM departments AS d
WHERE d.dept_no IN (SELECT dm.dept_no
					FROM dept_manager as dm
                    WHERE dm.to_date > NOW()
						AND dm.emp_no IN (SELECT e.emp_no
											FROM employees.employees AS e
											WHERE e.gender = 'F')); 
-- double checked with join exercises


-- 2. Find the first and last name of the employee with the highest salary.
SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name
	FROM employees.employees AS e
    WHERE e.emp_no = (SELECT s.emp_no
						FROM salaries AS s
                        WHERE s.salary = (SELECT MAX(s.salary)
											FROM salaries AS s));

-- double check
SELECT MAX(s.salary) FROM salaries AS s; -- 158220
SELECT s.emp_no FROM salaries AS s
	WHERE s.salary = 158220; -- 43624
SELECT * FROM employees AS e
	WHERE e.emp_no = 43624;

-- 3. Find the department name that the employee with the highest salary works in.
-- Find dept_name
SELECT d.dept_name
FROM departments AS d
    JOIN dept_emp AS de USING (dept_no)
    WHERE de.emp_no = (SELECT s.emp_no
						FROM salaries AS s
                        WHERE s.salary = (SELECT MAX(s.salary)
											FROM salaries AS s));
-- double check where emp_no 43624 works
SELECT * 
FROM departments AS d
	JOIN dept_emp AS de USING (dept_no)
WHERE de.emp_no = 43624;

-- 4. Who is the highest paid employee within each department.
-- assuming current
-- current employee salaries subquery
SELECT *
FROM departments AS d
	JOIN dept_emp AS de ON d.dept_no = de.dept_no AND de.to_date > NOW()
	JOIN employees AS e USING (emp_no)
    JOIN salaries AS s ON s.emp_no = e.emp_no AND s.to_date > NOW();

-- highest salary in each department
SELECT dept_no, MAX(salary)
FROM dept_emp AS de
    JOIN salaries AS s ON s.emp_no = de.emp_no AND s.to_date > NOW()
GROUP BY dept_no;

-- JOINING highest salaries with curr_empl_salaries
SELECT dept_name, first_name, last_name, salary
FROM (
		SELECT d.dept_no, d.dept_name, e.*, s.salary
		FROM departments AS d
			JOIN dept_emp AS de ON d.dept_no = de.dept_no AND de.to_date > NOW()
			JOIN employees AS e USING (emp_no)
			JOIN salaries AS s ON s.emp_no = e.emp_no AND s.to_date > NOW()
		) AS c -- curr_empl_salaries
	JOIN (
		SELECT dept_no, MAX(salary) AS max_salary
		FROM dept_emp AS de
			JOIN salaries AS s ON s.emp_no = de.emp_no AND s.to_date > NOW()
		GROUP BY dept_no
		) AS m -- max_salaries_by_dept 
			USING (dept_no)
WHERE c.salary = m.max_salary;

-- instructor answer below
SELECT d.dept_name, e.first_name, e.last_name, s.salary
FROM departments d
    JOIN dept_emp de USING(dept_no)
    JOIN employees e USING(emp_no)
    JOIN salaries s USING(emp_no)
WHERE s.salary IN (
  SELECT MAX(salary)
  FROM salaries
  GROUP BY d.dept_no
)
ORDER BY d.dept_name, s.salary DESC;

SELECT *
FROM departments AS d
	JOIN dept_emp AS de ON d.dept_no = de.dept_no AND de.to_date > NOW()
	JOIN employees AS e USING (emp_no)
    JOIN salaries AS s ON s.emp_no = e.emp_no AND s.to_date > NOW()
WHERE salary IN (SELECT MAX(salary)
					FROM salaries
                    GROUP BY d.dept_no);
