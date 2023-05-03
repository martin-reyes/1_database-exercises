SELECT * FROM salaries;


SELECT emp_no, SUM(salary) FROM salaries
GROUP BY emp_no;

SELECT DISTINCT emp_no, SUM(salary) FROM salaries;


