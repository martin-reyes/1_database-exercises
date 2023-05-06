USE employees;
-- Indexes exercises: Describe tables andn inspect each key
-- Can use SHOW CREATE TABLE table to see if keys are foreign
DESCRIBE departments;
DESCRIBE dept_emp;
DESCRIBE dept_manager;
DESCRIBE employees;
DESCRIBE salaries;
DESCRIBE titles;
-- ----------------------------------------------------------
-- Joins Exercise, Join Exaample DB
USE join_example_db;
DESCRIBE roles; -- inspect columns, PK id, 5 rows/roles
DESCRIBE users; -- PK id, FK role_id pointing to id in role, 7 rows/users
SHOW CREATE TABLE roles;
SHOW CREATE TABLE users; 
SELECT * FROM roles;
SELECT * FROM users;
/*
CREATE TABLE `roles` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1
*/


/*
2. Use join, left join, and right join to combine results from the users and roles tables
	as we did in the lesson. Before you run each query, guess the expected number of results.
*/
SELECT * FROM roles AS r INNER JOIN users AS u ON r.id = u.role_id; -- guessing 3 rows returned.. no 4 returned. I see why, 4 users with 3 distinct roles
SELECT * FROM roles AS r LEFT JOIN users AS u ON r.id = u.role_id; -- guessing 5 rows returned.. correct
SELECT * FROM roles AS r RIGHT JOIN users AS u ON r.id = u.role_id; -- guessing 7 rows returned.. wrong, 7 row with nulls dropped
/*
3. Although not explicitly covered in the lesson, aggregate functions like count can be used with 
	join queries. Use count and the appropriate join type to get a list of roles along with the number
	of users that has the role. Hint: You will also need to use group by in the query.
*/
SELECT r.name, COUNT(u.name) as num_employees
	FROM users as u
		RIGHT JOIN roles as r ON u.role_id = r.id
	GROUP BY r.name;
		

-- ----------------------------------------------------------
-- Employees DB
-- 1 Use the employees database.
USE employees;

/* 2. Using the example in the Associative Table Joins section as a guide, 
		write a query that shows each department along with the name of the current manager for that department.

  Department Name    | Department Manager
 --------------------+--------------------
  Customer Service   | Yuchang Weedman
  Development        | Leon DasSarma
  Finance            | Isamu Legleitner
  Human Resources    | Karsten Sigstam
  Marketing          | Vishwani Minakawa
  Production         | Oscar Ghazalie
  Quality Management | Dung Pesch
  Research           | Hilary Kambil
  Sales              | Hauke Zhang
*/
SELECT d.dept_name AS department_name,
		CONCAT(e.first_name, " ", e.last_name) AS department_manager, t.to_date -- to see if they're current
FROM departments AS d
	JOIN dept_manager AS dm ON d.dept_no = dm.dept_no
    JOIN employees.employees AS e ON dm.emp_no = e.emp_no
    JOIN titles AS t ON t.emp_no = dm.emp_no
WHERE t.to_date LIKE '9999%' AND dm.to_date LIKE '9999%';

/* 3. Find the name of all departments currently managed by women.

Department Name | Manager Name
----------------+-----------------
Development     | Leon DasSarma
Finance         | Isamu Legleitner
Human Resources | Karsetn Sigstam
Research        | Hilary Kambil
*/
SELECT d.dept_name AS department_name,
		CONCAT(e.first_name, " ", e.last_name) AS manager_name -- , t.to_date to see if they're current
FROM departments AS d
	JOIN dept_manager AS dm ON d.dept_no = dm.dept_no
    JOIN employees.employees AS e ON dm.emp_no = e.emp_no
    JOIN titles AS t ON t.emp_no = dm.emp_no
WHERE dm.to_date LIKE '9999%'
	AND t.to_date LIKE '9999%'
    AND e.gender = 'F';

/* 4. Find the current titles of employees currently working in the Customer Service department.

Title              | Count
-------------------+------
Assistant Engineer |    68
Engineer           |   627
Manager            |     1
Senior Engineer    |  1790
Senior Staff       | 11268
Staff              |  3574
Technique Leader   |   241
*/
SELECT t.title AS title, COUNT(t.emp_no) AS count
FROM titles AS t
	JOIN dept_emp AS de ON t.emp_no = de.emp_no
 	JOIN departments AS d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Customer Service' 
	AND  t.to_date LIKE '9999%' 
    AND de.to_date LIKE '9999%'
GROUP BY t.title
ORDER BY t.title;

/* 5. Find the current salary of all current managers.

Department Name    | Name              | Salary
-------------------+-------------------+-------
Customer Service   | Yuchang Weedman   |  58745
Development        | Leon DasSarma     |  74510
Finance            | Isamu Legleitner  |  83457
Human Resources    | Karsten Sigstam   |  65400
Marketing          | Vishwani Minakawa | 106491
Production         | Oscar Ghazalie    |  56654
Quality Management | Dung Pesch        |  72876
Research           | Hilary Kambil     |  79393
Sales              | Hauke Zhang       | 101987
*/ 
SELECT d.dept_name AS department_name,
			CONCAT(e.first_name, " ", e.last_name) AS name,
            salary
FROM employees.employees AS e
	JOIN dept_manager AS dm ON e.emp_no = dm.emp_no AND dm.to_date > NOW()
	JOIN salaries AS s ON s.emp_no = dm.emp_no AND s.to_date > NOW()
	JOIN departments AS d ON dm.dept_no = d.dept_no
ORDER BY dept_name;

/* 6. Find the number of current employees in each department.

+---------+--------------------+---------------+
| dept_no | dept_name          | num_employees |
+---------+--------------------+---------------+
| d001    | Marketing          | 14842         |
| d002    | Finance            | 12437         |
| d003    | Human Resources    | 12898         |
| d004    | Production         | 53304         |
| d005    | Development        | 61386         |
| d006    | Quality Management | 14546         |
| d007    | Sales              | 37701         |
| d008    | Research           | 15441         |
| d009    | Customer Service   | 17569         |
+---------+--------------------+---------------+
*/
SELECT d.dept_no, dept_name, COUNT(de.emp_no) AS num_employees
FROM departments AS d
	JOIN dept_emp AS de ON d.dept_no = de.dept_no AND de.to_date > NOW()
GROUP BY dept_no
ORDER BY dept_no;


/* 7. Which department has the highest average salary? Hint: Use current not historic information.

+-----------+----------------+
| dept_name | average_salary |
+-----------+----------------+
| Sales     | 88852.9695     |
+-----------+----------------+
*/

SELECT dept_name, AVG(salary) AS average_salary
FROM departments AS d
	JOIN dept_emp AS de ON d.dept_no = de.dept_no AND de.to_date > NOW()
	JOIN salaries AS s ON de.emp_no = s.emp_no AND s.to_date > NOW()
GROUP BY dept_name
ORDER BY AVG(salary) DESC
LIMIT 1;

/* Who is the highest paid employee in the Marketing department?

+------------+-----------+
| first_name | last_name |
+------------+-----------+
| Akemi      | Warwick   |
+------------+-----------+
*/

SELECT first_name, last_name
FROM employees AS e
	JOIN salaries AS s USING (emp_no)
    JOIN dept_emp AS de USING (emp_no)
    JOIN departments AS d ON de.dept_no = d.dept_no
							AND d.dept_name = 'Marketing'
ORDER BY salary DESC
LIMIT 1;


/* 9. Which current department manager has the highest salary?

+------------+-----------+--------+-----------+
| first_name | last_name | salary | dept_name |
+------------+-----------+--------+-----------+
| Vishwani   | Minakawa  | 106491 | Marketing |
+------------+-----------+--------+-----------+
*/

SELECT first_name, last_name, salary, dept_name
FROM employees AS e
	JOIN dept_manager AS dm ON e.emp_no = dm.emp_no AND dm.to_date > NOW()
	JOIN salaries AS s ON s.emp_no = dm.emp_no AND s.to_date > NOW()
    JOIN departments AS d USING (dept_no)
    ORDER BY salary DESC
    LIMIT 1;


/*	10. Determine the average salary for each department. 
	Use all salary information and round your results.

+--------------------+----------------+
| dept_name          | average_salary | 
+--------------------+----------------+
| Sales              | 80668          | 
+--------------------+----------------+
| Marketing          | 71913          |
+--------------------+----------------+
| Finance            | 70489          |
+--------------------+----------------+
| Research           | 59665          |
+--------------------+----------------+
| Production         | 59605          |
+--------------------+----------------+
| Development        | 59479          |
+--------------------+----------------+
| Customer Service   | 58770          |
+--------------------+----------------+
| Quality Management | 57251          |
+--------------------+----------------+
| Human Resources    | 55575          |
+--------------------+----------------+
*/

SELECT dept_name, ROUND(AVG(salary)) AS average_salary
FROM departments AS d
	JOIN dept_emp USING(dept_no)
    JOIN salaries USING(emp_no)
GROUP BY dept_name
ORDER BY average_salary DESC;

/* Bonus Find the names of all current employees,
	their department name, and their current manager's name.

240,124 Rows

Employee Name | Department Name  |  Manager Name
--------------|------------------|-----------------
 Huan Lortz   | Customer Service | Yuchang Weedman
 .....
 */


