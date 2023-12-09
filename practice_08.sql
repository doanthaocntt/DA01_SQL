--1. https://leetcode.com/problems/immediate-food-delivery-ii/?envType=study-plan-v2&envId=top-sql-50
WITH cte AS (
SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rowNumber,     
(case when order_date = customer_pref_delivery_date then 1.0 else 0 end) AS immediate
FROM Delivery)

SELECT ROUND(100*sum(immediate)/COUNT(immediate),2) AS immediate_percentage 
FROM cte
WHERE rowNumber=1  

--2. https://leetcode.com/problems/game-play-analysis-iv/?envType=study-plan-v2&envId=top-sql-50



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
