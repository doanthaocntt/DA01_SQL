--1. https://datalemur.com/questions/duplicate-job-listings
With company_information as (
SELECT company_id, title, description, count(*)
FROM job_listings
GROUP BY company_id, title, description
HAVING count(*) > 1
)
SELECT count(*)
FROM company_information 

--2. https://datalemur.com/questions/sql-highest-grossing


--3. https://datalemur.com/questions/frequent-callers
WITH CTE as (
SELECT policy_holder_id, count(call_duration_secs)
FROM callers 
GROUP BY policy_holder_id
HAVING count(call_duration_secs) >=3 
)
SELECT COUNT(*) as member_count
FROM CTE 

--4. https://datalemur.com/questions/sql-page-with-no-likes
WITH CTE as (
SELECT a.page_id
FROM pages as a
LEFT JOIN page_likes as b 
ON a.page_id = b.page_id
WHERE b.page_id is null 
ORDER BY a.page_id 
)
SELECT page_id 
FROM CTE 
--5. https://datalemur.com/questions/user-retention

--6. https://leetcode.com/problems/monthly-transactions-i/?envType=study-plan-v2&envId=top-sql-50

--7. https://leetcode.com/problems/product-sales-analysis-iii/?envType=study-plan-v2&envId=top-sql-50

--8. https://leetcode.com/problems/customers-who-bought-all-products/?envType=study-plan-v2&envId=top-sql-50

--9. https://leetcode.com/problems/employees-whose-manager-left-the-company/?envType=study-plan-v2&envId=top-sql-50
SELECT employee_id 
FROM Employees 
WHERE manager_id not in
(
  SELECT employee_id 
  FROM Employees 
)
AND salary < 30000
ORDER BY employee_id 
  
--10. https://leetcode.com/problems/primary-department-for-each-employee/
WITH CTE AS (
SELECT Employee_id, count(department_id) as a
FROM Employee
GROUP BY employee_id
)
SELECT employee_id, department_id
FROM Employee
WHERE employee_id IN (SELECT Employee_id FROM CTE WHERE a = 1)
UNION
SELECT employee_id, department_id
FROM Employee
WHERE primary_flag = "Y"
--11. https://leetcode.com/problems/movie-rating/?envType=study-plan-v2&envId=top-sql-50

--12. https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/?envType=study-plan-v2&envId=top-sql-50
