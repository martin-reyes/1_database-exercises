USE employees;
-- 1. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya' using IN. What is the employee number of the top three results?
SELECT FROM
WHERE IN;
-- 2. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', as in Q2, but use OR instead of IN. What is the employee number of the top three results? Does it match the previous question?
-- SELECT FROM WHERE OR;
-- 3. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', using OR, and who is male. What is the employee number of the top three results.
-- SELECT FROM WHERE OR;
-- 4. Find all unique last names that start with 'E'.
-- SELECT FROM WHERE LIKE;
-- 5. Find all unique last names that start or end with 'E'.
-- SELECT FROM WHERE LIKE;
-- 6. Find all unique last names that end with E, but does not start with E?
-- SELECT FROM WHERE LIKE;
-- 7. Find all unique last names that start and end with 'E'.
-- SELECT FROM WHERE LIKE;
-- 8. Find all current or previous employees hired in the 90s. Enter a comment with top three employee numbers.
-- SELECT FROM WHERE BETWEEN;
-- 9. Find all current or previous employees born on Christmas. Enter a comment with top three employee numbers.
-- SELECT FROM WHERE = ;
-- 10. Find all current or previous employees hired in the 90s and born on Christmas. Enter a comment with top three employee numbers.
-- SELECT FROM WHERE IN AND =;
-- 11. Find all unique last names that have a 'q' in their last name.
-- SELECT FROM WHERE LIKE;
-- 12. Find all unique last names that have a 'q' in their last name but not 'qu'.
-- SELECT FROM WHERE LIKE AND NOT LIKE;