/* Q1: Last booked room per user */

SELECT user_id, room_no
FROM (
    SELECT user_id, room_no,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) rn
    FROM bookings
)
WHERE rn = 1;

/* Q2: Billing in Nov 2021 */
SELECT bc.booking_id,
       SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
JOIN bookings b ON bc.booking_id = b.booking_id
WHERE strftime('%Y-%m', b.booking_date) = '2021-11'
GROUP BY bc.booking_id;

/* Q3: Bills > 1000 (Oct 2021) */
SELECT bill_id,
       SUM(item_quantity * i.item_rate) AS total_bill
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE strftime('%Y-%m', bill_date) = '2021-10'
GROUP BY bill_id
HAVING total_bill > 1000;

/* Q4: Most & least ordered items */
WITH item_orders AS (
    SELECT strftime('%Y-%m', bill_date) AS month,
           item_id,
           SUM(item_quantity) qty
    FROM booking_commercials
    WHERE strftime('%Y', bill_date) = '2021'
    GROUP BY month, item_id
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY month ORDER BY qty DESC) max_rank,
           RANK() OVER (PARTITION BY month ORDER BY qty ASC) min_rank
    FROM item_orders
)
SELECT * FROM ranked WHERE max_rank = 1
UNION ALL
SELECT * FROM ranked WHERE min_rank = 1;

/* Q5: Second highest bill per month */
WITH bill_data AS (
    SELECT bill_id,
           strftime('%Y-%m', bill_date) month,
           SUM(item_quantity * i.item_rate) total
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE strftime('%Y', bill_date) = '2021'
    GROUP BY bill_id, month
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY month ORDER BY total DESC) rnk
    FROM bill_data
)
SELECT * FROM ranked WHERE rnk = 2;