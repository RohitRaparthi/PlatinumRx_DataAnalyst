/* Q1: Revenue by channel */
SELECT sales_channel,
       SUM(amount) total_revenue
FROM clinic_sales
WHERE strftime('%Y', datetime) = '2021'
GROUP BY sales_channel;

/* Q2: Top 10 customers */
SELECT uid,
       SUM(amount) total_spent
FROM clinic_sales
WHERE strftime('%Y', datetime) = '2021'
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

/* Q3: Month-wise profit */
WITH revenue AS (
    SELECT strftime('%Y-%m', datetime) month,
           SUM(amount) revenue
    FROM clinic_sales
    WHERE strftime('%Y', datetime) = '2021'
    GROUP BY month
),
expense_data AS (
    SELECT strftime('%Y-%m', datetime) month,
           SUM(amount) expense
    FROM expenses
    WHERE strftime('%Y', datetime) = '2021'
    GROUP BY month
)
SELECT r.month,
       r.revenue,
       e.expense,
       (r.revenue - e.expense) profit,
       CASE 
           WHEN (r.revenue - e.expense) > 0 THEN 'PROFITABLE'
           ELSE 'NOT PROFITABLE'
       END status
FROM revenue r
JOIN expense_data e ON r.month = e.month;

/* Q4: Most profitable clinic per city */
WITH profit_data AS (
    SELECT c.city, cs.cid,
           SUM(cs.amount) - IFNULL(SUM(e.amount),0) profit
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    LEFT JOIN expenses e ON cs.cid = e.cid
    WHERE strftime('%Y-%m', cs.datetime) = '2021-09'
    GROUP BY c.city, cs.cid
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY city ORDER BY profit DESC) rnk
    FROM profit_data
)
SELECT * FROM ranked WHERE rnk = 1;

/* Q5: Second least profitable clinic per state */
WITH profit_data AS (
    SELECT c.state, cs.cid,
           SUM(cs.amount) - IFNULL(SUM(e.amount),0) profit
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    LEFT JOIN expenses e ON cs.cid = e.cid
    WHERE strftime('%Y-%m', cs.datetime) = '2021-09'
    GROUP BY c.state, cs.cid
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) rnk
    FROM profit_data
)
SELECT * FROM ranked WHERE rnk = 2;