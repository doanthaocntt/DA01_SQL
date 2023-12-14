--1. https://leetcode.com/problems/immediate-food-delivery-ii/?envType=study-plan-v2&envId=top-sql-50
WITH cte AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rowNumber,     
(case when order_date = customer_pref_delivery_date then 1.0 else 0 end) AS immediate
FROM Delivery)

SELECT ROUND(100*sum(immediate)/COUNT(immediate),2) AS immediate_percentage 
FROM cte
WHERE rowNumber=1  

--2. https://leetcode.com/problems/game-play-analysis-iv/?envType=study-plan-v2&envId=top-sql-50
--Em làm run thì pass mà submit có 1 case không pass được ạ 
SELECT ROUND(SUM(CASE
                     WHEN a.event_date = b.first_event+1 THEN 1
                     ELSE 0
                 END)/count(DISTINCT a.player_id), 2) AS fraction
FROM Activity AS a
INNER JOIN
  (SELECT player_id, min(event_date) AS first_event
   FROM Activity
   GROUP BY player_id) AS b 
   ON a.player_id = b.player_id
--3. https://leetcode.com/problems/exchange-seats/?envType=study-plan-v2&envId=top-sql-50
WITH cte AS (
    SELECT id, student, LAG(student,1) OVER (ORDER BY id) AS previous_student, 
    LEAD(student,1) OVER (ORDER BY id) AS later 
    FROM Seat)
SELECT id,
    CASE
    WHEN id%2 != 0 AND later IS NULL THEN student
    WHEN id%2 != 0 THEN later
    ELSE previous_student
    END AS 'student'
FROM cte;

--4. https://leetcode.com/problems/restaurant-growth/?envType=study-plan-v2&envId=top-sql-50
WITH cte AS
(select visited_on,sum(amount) as sum_amount
from customer
group by visited_on
order by visited_on), a as (
select *,
avg(sum_amount) over(order by visited_on rows between 6 preceding and current row) average_amount,
sum(sum_amount) over(order by visited_on rows between 6 preceding and current row) amount,
row_number() over(order by visited_on)  as row_num
from cte)

select visited_on, amount, round(average_amount,2) as average_amount
from a
where row_num > 8 

--5. https://leetcode.com/problems/investments-in-2016/?envType=study-plan-v2&envId=top-sql-50
WITH cte AS (
SELECT tiv_2016,
        COUNT(*) OVER (PARTITION BY tiv_2015) AS count1,
        COUNT(*) OVER (PARTITION BY lat, lon) AS count2
FROM Insurance)
SELECT ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM cte
WHERE count1 > 1 AND count2 = 1;

--6. https://leetcode.com/problems/department-top-three-salaries/?envType=study-plan-v2&envId=top-sql-50
SELECT a.Name as Department, b.Name as Employee, b.Salary as Salary
FROM Department as a, Employee as b
WHERE
    (SELECT COUNT(DISTINCT Salary)
    FROM Employee
    WHERE Salary > b.Salary AND DepartmentId = a.Id) < 3 AND b.DepartmentId = a.Id
ORDER BY a.Id, b.Salary desc;

--7. https://leetcode.com/problems/last-person-to-fit-in-the-bus/?envType=study-plan-v2&envId=top-sql-50
WITH cte AS 
(select 
person_name, 
sum(weight) over( order by turn asc) as sum_weight
from queue 
order by sum_weight)
select person_name 
from cte 
where sum_weight <=1000 
order by sum_weight desc 
limit 1 

--8. https://leetcode.com/problems/product-price-at-a-given-date/?envType=study-plan-v2&envId=top-sql-50
SELECT * 
FROM 
(SELECT product_id, new_price AS price
 FROM Products
 WHERE (product_id, change_date) IN (
                                     SELECT product_id, MAX(change_date)
                                     FROM Products
                                     WHERE change_date <= "2019-08-16"
                                     GROUP BY product_id)
 UNION
 SELECT DISTINCT product_id, 10 as price
 FROM Products
 WHERE product_id NOT IN (  SELECT product_id 
                            FROM Products
                            WHERE change_date <= "2019-08-16")) as a
ORDER BY price DESC
