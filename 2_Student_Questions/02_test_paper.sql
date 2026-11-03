-- =====================================================================
-- CLASS TEST : SQL WINDOW FUNCTIONS   (table: ecommerce_orders)
-- Topics : OVER(), PARTITION BY, ROW_NUMBER(), RANK(), DENSE_RANK()
-- 20 questions x 5 marks = 100 marks      Time : 90 minutes
-- Run 01_dataset.sql first. Write your answer below each question.
-- =====================================================================
USE window_fn_course;


/* ==================================================================
   Section A : OVER()
   ================================================================== */

-- Q1. Total number of orders on every row
--
-- The manager wants to see each order together with the total number
-- of orders placed in the year.
--
-- Steps:
--   1. Use ALL orders (Delivered, Cancelled and Returned).
--   2. On every row, show the total number of orders using COUNT(*)
--      OVER ().
--
-- Output table structure:
--   order_id       : Order number
--   customer_name  : Customer
--   total_amount   : Amount of this order
--   total_orders   : Number of orders in the table (same on every row)
--
-- Sort by : order_id
-- Expected rows : 300
--
-- Hint : COUNT(*) OVER ()
-- Note : Unlike GROUP BY, a window function keeps every row. An empty
--        OVER () means 'look at the whole table'.

-- Your answer:



-- Q2. Flag high-value orders
--
-- Marketing calls an order 'High Value' if it is bigger than the
-- company's average order value (AOV).
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. On every row, show the company AOV = average of total_amount
--      over all delivered orders, rounded to 2 decimals.
--   3. Add order_type: 'High Value' if total_amount is greater than
--      the AOV, otherwise 'Normal'.
--
-- Output table structure:
--   order_id       : Order number
--   customer_name  : Customer
--   total_amount   : Amount of this order
--   company_aov    : Average order value (same on every row)
--   order_type     : 'High Value' or 'Normal'
--
-- Sort by : order_id
-- Expected rows : 258
--
-- Hint : ROUND(AVG(total_amount) OVER (), 2) and CASE WHEN
--        total_amount > AVG(total_amount) OVER () THEN ... ELSE ...
--        END
-- Note : You can use a window function inside CASE WHEN, just like a
--        normal column.

-- Your answer:



-- Q3. Units ordered vs the whole year
--
-- The warehouse team wants to compare each order's units with the
-- whole year's volume.
--
-- Steps:
--   1. Use ALL orders (Delivered, Cancelled and Returned).
--   2. On every row, show the total number of orders and the total
--      units (sum of quantity) for the whole year.
--   3. Calculate pct_of_units = quantity x 100 / total_units, rounded
--      to 2 decimals.
--
-- Output table structure:
--   order_id      : Order number
--   product_name  : Product
--   quantity      : Units in this order
--   total_orders  : Number of orders in the year
--   total_units   : Sum of quantity in the year
--   pct_of_units  : This order's % of total_units
--
-- Sort by : order_id
-- Expected rows : 300
--
-- Hint : COUNT(*) OVER (), SUM(quantity) OVER (), and quantity * 100.0
--        / SUM(quantity) OVER ()
-- Note : Multiply by 100.0 (not 100) so MySQL does not lose the
--        decimals.

-- Your answer:




/* ==================================================================
   Section B : PARTITION BY
   ================================================================== */

-- Q4. Highest and lowest order of the year
--
-- Finance wants every order shown next to the year's biggest and
-- smallest order.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. On every row, show MAX(total_amount) and MIN(total_amount) over
--      the whole table.
--
-- Output table structure:
--   order_id       : Order number
--   product_name   : Product
--   total_amount   : Amount of this order
--   highest_order  : Biggest order amount of the year
--   lowest_order   : Smallest order amount of the year
--
-- Sort by : order_id
-- Expected rows : 258
--
-- Hint : MAX(total_amount) OVER () and MIN(total_amount) OVER ()
-- Note : The WHERE clause runs first, so the window only sees
--        Delivered orders.

-- Your answer:



-- Q5. Category revenue and share
--
-- Each category manager wants to see every order next to the revenue
-- of their own category.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. On every row, show the total revenue of that order's CATEGORY.
--   3. Calculate pct_of_category = total_amount x 100 /
--      category_revenue, rounded to 2 decimals.
--
-- Output table structure:
--   order_id          : Order number
--   category          : Category
--   product_name      : Product
--   total_amount      : Amount of this order
--   category_revenue  : Revenue of this category
--   pct_of_category   : This order's % of its category
--
-- Sort by : category, order_id
-- Expected rows : 258
--
-- Hint : SUM(total_amount) OVER (PARTITION BY category)
-- Note : PARTITION BY restarts the calculation for each category. The
--        % values inside one category add up to 100.

-- Your answer:



-- Q6. City average next to each order
--
-- City managers want to compare each order with the usual order size
-- in their city.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. On every row, show the average total_amount of that order's
--      CITY, rounded to 2 decimals.
--
-- Output table structure:
--   order_id       : Order number
--   city           : City
--   customer_name  : Customer
--   total_amount   : Amount of this order
--   city_avg       : Average order value of the city
--
-- Sort by : city, order_id
-- Expected rows : 258
--
-- Hint : ROUND(AVG(total_amount) OVER (PARTITION BY city), 2)
-- Note : Every order of the same city shows the same city_avg.

-- Your answer:



-- Q7. Customer lifetime value on every order
--
-- The CRM team wants each order to also show how valuable that
-- customer is overall.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. On every row, show how many delivered orders that CUSTOMER has.
--   3. On every row, show the customer's lifetime value = sum of their
--      total_amount.
--
-- Output table structure:
--   customer_id      : Customer code
--   customer_name    : Customer
--   order_id         : Order number
--   total_amount     : Amount of this order
--   customer_orders  : Customer's number of orders
--   lifetime_value   : Customer's total spend
--
-- Sort by : customer_id, order_id
-- Expected rows : 258
--
-- Hint : COUNT(*) OVER (PARTITION BY customer_id) and
--        SUM(total_amount) OVER (PARTITION BY customer_id)
-- Note : Partition by customer_id, not customer_name: two customers
--        can share the same name.

-- Your answer:



-- Q8. Monthly revenue and share
--
-- Management reviews revenue month by month and wants each order's
-- share of its month.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. Create order_month in 'YYYY-MM' format, e.g. 2024-01 (MySQL:
--      DATE_FORMAT(order_date, '%Y-%m')).
--   3. On every row, show the total revenue of that MONTH.
--   4. Calculate pct_of_month = total_amount x 100 / month_revenue,
--      rounded to 2 decimals.
--
-- Output table structure:
--   order_month    : Month, e.g. 2024-01
--   order_id       : Order number
--   total_amount   : Amount of this order
--   month_revenue  : Revenue of this month
--   pct_of_month   : This order's % of the month
--
-- Sort by : order_month, order_id
-- Expected rows : 258
--
-- Hint : DATE_FORMAT(order_date, '%Y-%m') AS order_month, then
--        PARTITION BY DATE_FORMAT(order_date, '%Y-%m')
-- Note : You cannot use the alias order_month inside OVER (). Repeat
--        the full expression.

-- Your answer:




/* ==================================================================
   Section C : ROW_NUMBER()
   ================================================================== */

-- Q9. Highest order of each category
--
-- Category managers want to see how each order compares with the
-- biggest order in their category.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. On every row, show MAX(total_amount) of that order's CATEGORY.
--
-- Output table structure:
--   order_id      : Order number
--   category      : Category
--   product_name  : Product
--   total_amount  : Amount of this order
--   category_max  : Biggest order amount in the category
--
-- Sort by : category, order_id
-- Expected rows : 258
--
-- Hint : MAX(total_amount) OVER (PARTITION BY category)
-- Note : Orders where total_amount = category_max are the biggest
--        orders of their category.

-- Your answer:



-- Q10. Purchase sequence of each customer
--
-- The CRM team wants to know whether an order was a customer's 1st,
-- 2nd, 3rd ... purchase.
--
-- Steps:
--   1. Use ALL orders (Delivered, Cancelled and Returned).
--   2. Number each CUSTOMER's orders from 1, oldest order first.
--   3. If two orders of a customer have the same date, the lower
--      order_id comes first.
--   4. The numbering must restart at 1 for every customer.
--
-- Output table structure:
--   customer_id    : Customer code
--   customer_name  : Customer
--   order_id       : Order number
--   order_date     : Order date
--   purchase_no    : 1 = first purchase, 2 = second ...
--
-- Sort by : customer_id, purchase_no
-- Expected rows : 300
--
-- Hint : ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY
--        order_date, order_id)
-- Note : ROW_NUMBER needs ORDER BY inside OVER (). PARTITION BY makes
--        the numbering restart for each customer.

-- Your answer:



-- Q11. Serial number for every order
--
-- The operations team wants a running serial number for all orders of
-- the year.
--
-- Steps:
--   1. Use ALL orders (Delivered, Cancelled and Returned).
--   2. Number all orders from 1, oldest order first, using
--      ROW_NUMBER().
--   3. If two orders have the same date, the lower order_id comes
--      first.
--
-- Output table structure:
--   order_id       : Order number
--   order_date     : Order date
--   customer_name  : Customer
--   serial_no      : 1 = oldest order of the year
--
-- Sort by : serial_no
-- Expected rows : 300
--
-- Hint : ROW_NUMBER() OVER (ORDER BY order_date, order_id)
-- Note : Without order_id as a tie-breaker, orders on the same date
--        could get different numbers each time you run the query.

-- Your answer:



-- Q12. Newest orders first in each city
--
-- Each city's delivery team wants its orders numbered from the most
-- recent one.
--
-- Steps:
--   1. Use ALL orders (Delivered, Cancelled and Returned).
--   2. Number the orders inside each CITY, newest date = 1, using
--      ROW_NUMBER().
--   3. If two orders have the same date, the higher order_id comes
--      first.
--
-- Output table structure:
--   city           : City
--   order_id       : Order number
--   order_date     : Order date
--   city_order_no  : 1 = newest order of the city
--
-- Sort by : city, city_order_no
-- Expected rows : 300
--
-- Hint : ROW_NUMBER() OVER (PARTITION BY city ORDER BY order_date
--        DESC, order_id DESC)
-- Note : DESC puts the newest order first, so it gets number 1.

-- Your answer:



-- Q13. Number orders by amount in each category
--
-- Category managers want their orders listed with a position number
-- from the biggest to the smallest.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. Number the orders inside each CATEGORY, biggest total_amount =
--      1, using ROW_NUMBER().
--   3. If two orders have the same amount, the lower order_id comes
--      first.
--
-- Output table structure:
--   category              : Category
--   order_id              : Order number
--   total_amount          : Amount of this order
--   position_in_category  : 1 = biggest order of the category
--
-- Sort by : category, position_in_category
-- Expected rows : 258
--
-- Hint : ROW_NUMBER() OVER (PARTITION BY category ORDER BY
--        total_amount DESC, order_id)
-- Note : Tied amounts still get different numbers with ROW_NUMBER.
--        That is the difference from RANK.

-- Your answer:




/* ==================================================================
   Section D : RANK()
   ================================================================== */

-- Q14. Product leaderboard inside each category
--
-- Category managers want to know which of their products earns the
-- most.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. Calculate the total revenue of each PRODUCT (one row per
--      product).
--   3. Rank the products inside their CATEGORY, highest revenue = 1,
--      using RANK().
--
-- Output table structure:
--   category          : Category
--   product_name      : Product
--   product_revenue   : Total revenue of the product
--   rank_in_category  : 1 = best product of the category
--
-- Sort by : category, rank_in_category
-- Expected rows : 30
--
-- Hint : GROUP BY category, product_name, then RANK() OVER (PARTITION
--        BY category ORDER BY SUM(total_amount) DESC)
-- Note : A window function can use an aggregate like
--        SUM(total_amount). GROUP BY runs first, then the window.

-- Your answer:



-- Q15. Rank all orders by amount
--
-- Finance wants a ranking of every delivered order by its amount.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. Rank the orders by total_amount, highest = 1, using RANK().
--      Tied amounts share a rank.
--
-- Output table structure:
--   order_id       : Order number
--   customer_name  : Customer
--   total_amount   : Amount of this order
--   amount_rank    : 1 = biggest order
--
-- Sort by : amount_rank, order_id
-- Expected rows : 258
--
-- Hint : RANK() OVER (ORDER BY total_amount DESC)
-- Note : Tied amounts share a rank and the next rank is skipped: 1, 2,
--        2, 4.

-- Your answer:



-- Q16. Rank orders inside each city
--
-- Each city manager wants their own ranking of orders by amount.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. Rank the orders inside each CITY by total_amount, highest = 1,
--      using RANK().
--
-- Output table structure:
--   city          : City
--   order_id      : Order number
--   total_amount  : Amount of this order
--   city_rank     : 1 = biggest order of the city
--
-- Sort by : city, city_rank, order_id
-- Expected rows : 258
--
-- Hint : RANK() OVER (PARTITION BY city ORDER BY total_amount DESC)
-- Note : The rank starts again at 1 for every city.

-- Your answer:




/* ==================================================================
   Section E : DENSE_RANK()
   ================================================================== */

-- Q17. Rank customers by total spend
--
-- The company wants a leaderboard of customers by how much they spent
-- in the year.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. Calculate each customer's total spend with GROUP BY (one row
--      per customer).
--   3. Rank the customers by total spend, highest = 1, using RANK().
--
-- Output table structure:
--   customer_id    : Customer code
--   customer_name  : Customer
--   total_spent    : Total spend in the year
--   spend_rank     : 1 = biggest spender
--
-- Sort by : spend_rank, customer_id
-- Expected rows : 52
--
-- Hint : GROUP BY customer_id, customer_name, then RANK() OVER (ORDER
--        BY SUM(total_amount) DESC)
-- Note : One row per customer. Customers with the same total share a
--        rank.

-- Your answer:



-- Q18. Dense rank of orders inside each category
--
-- Category managers want order levels without gaps in the rank
-- numbers.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. Rank the orders inside each CATEGORY by total_amount, highest =
--      1, using DENSE_RANK().
--
-- Output table structure:
--   category      : Category
--   order_id      : Order number
--   total_amount  : Amount of this order
--   amount_level  : 1 = highest amount level of the category
--
-- Sort by : category, amount_level, order_id
-- Expected rows : 258
--
-- Hint : DENSE_RANK() OVER (PARTITION BY category ORDER BY
--        total_amount DESC)
-- Note : DENSE_RANK has no gaps: 1, 2, 2, 3. Level 2 is the second
--        highest different amount.

-- Your answer:



-- Q19. City ranking inside each state
--
-- State managers want to know which of their cities brings in the most
-- revenue.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. Calculate the revenue of each CITY (one row per city).
--   3. On every row, also show the revenue of the city's STATE.
--   4. Rank the cities inside their state by revenue, highest = 1,
--      using DENSE_RANK().
--
-- Output table structure:
--   state               : State
--   city                : City
--   city_revenue        : Revenue of the city
--   state_revenue       : Revenue of the whole state
--   city_rank_in_state  : 1 = top city of the state
--
-- Sort by : state, city_rank_in_state
-- Expected rows : 12
--
-- Hint : GROUP BY state, city, then SUM(SUM(total_amount)) OVER
--        (PARTITION BY state) and DENSE_RANK() OVER (PARTITION BY
--        state ORDER BY SUM(total_amount) DESC)
-- Note : SUM(SUM(...)) means: add up the city totals inside each
--        state.

-- Your answer:



-- Q20. ROW_NUMBER vs RANK vs DENSE_RANK
--
-- Compare the three ranking functions on the same data to see how they
-- treat tied amounts.
--
-- Steps:
--   1. Use only orders where order_status = 'Delivered'.
--   2. Order by total_amount, highest first, in all three functions.
--   3. For ROW_NUMBER, add order_id as a tie-breaker so the numbering
--      is always the same.
--
-- Output table structure:
--   order_id      : Order number
--   total_amount  : Amount of this order
--   row_num       : ROW_NUMBER: always unique
--   rnk           : RANK: ties share, then skips
--   dense_rnk     : DENSE_RANK: ties share, no gaps
--
-- Sort by : row_num
-- Expected rows : 258
--
-- Hint : Three window functions in one SELECT, all with ORDER BY
--        total_amount DESC
-- Note : Look at tied amounts: ROW_NUMBER 1, 2, 3 | RANK 1, 1, 3 |
--        DENSE_RANK 1, 1, 2.

-- Your answer:


