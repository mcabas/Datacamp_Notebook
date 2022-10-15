/*
DataCamp.Course_031_Analyzing_Business_Data_in_SQL

######################################################################
######################################################################
######################################################################

# COURSE Analyzing Business Data in SQL_031

Course overview
Chapter 1: Revenue, cost, and pro,t
Chapter 2: User-centric metrics
Chapter 3: Unit economics and distributions
Chapter 4: Generating an executive report

DELIVR
***Food delivery startup, similar to to Uber
***Eats
***Stocks meals from eateries in bulk
***Offers users these meals through its app
***Users can order meals from several eateries
in one order

######################################################################
######################################################################
######################################################################

######## Revenue, cost, and profit (Module 01-031)
######################################################################

Revenue, cost, and profit

    Profit: The money a company makes minus the money it spends
    Revenue: The money a company makes
    Cost: The money a company spends
    Profit = Revenue - Cost

Tables you'll need
meals
meal_id eatery meal_price meal_cost
------- ------------------------ ---------- ---------
0 'Leaning Tower of Pizza' 4 2
1 'Leaning Tower of Pizza' 3.5 1.25
2 'Leaning Tower of Pizza' 4.5 1.75
... ... ... ...
orders
order_date user_id order_id meal_id order_quantity
---------- ------- -------- ------- --------------
2018-06-01 0 0 4 3
2018-06-01 0 0 14 2
2018-06-01 0 0 15 1
... ... ... ... ...


Calculating revenue
Example order
Three (3) burgers at $5 each
Two (2) sandwiches at $3 each
Total price: 3 × $5 + 2 × $3 = $21
Revenue: Multiply each meal's price times its ordered quantity, then sum the results
Query
SELECT
order_id,
SUM(meal_price * order_quantity) AS revenue
FROM meals
JOIN orders ON meals.meal_id = orders.meal_id
GROUP BY order_id;

Working with dates
DATE_TRUNC(date_part, date)
Examples
DATE_TRUNC('week', '2018-06-12') :: DATE → '2018-06-11'
DATE_TRUNC('month', '2018-06-12') :: DATE → '2018-06-01'
DATE_TRUNC('quarter', '2018-06-12') :: DATE → '2018-04-01'
DATE_TRUNC('year', '2018-06-12') :: DATE → '2018-01-01'

#---------------------------------------------------------------------

Revenue per customer

You've been hired at Delivr as a data analyst! A customer just called Delivr's Customer Support team; she wants to double-check whether her receipts add up. Going by her receipts, she calculated that her total bill on Delivr is $271, and she wants to make sure of that. Her user ID is 15.

Help the Customer Support team by calculating her total bill! Sum up everything she's spent on Delivr orders; in other words, calculate the total revenue that Delivr has generated from her.

-- Calculate revenue
SELECT SUM(meal_price * order_quantity) AS revenue
  FROM meals
  JOIN orders ON meals.meal_id = orders.meal_id
-- Keep only the records of customer ID 15
WHERE user_id = 15;

#---------------------------------------------------------------------

Revenue per week

Delivr's first full month of operations was June 2018. At launch, the Marketing team ran an ad campaign on popular food channels on TV, with the number of ads increasing each week through the end of the month. The Head of Marketing asks you to help her assess that campaign's success.

Get the revenue per week for each week in June and check whether there's any consistent growth in revenue.

Note: Don't be surprised if you get a date in May in the result. DATE_TRUNC('week', '2018-06-02') returns '2018-05-28', since '2018-06-02' is a Saturday and the preceding Monday is on '2018-05-28'.

SELECT DATE_TRUNC('week', order_date) :: DATE AS delivr_week,
       -- Calculate revenue
       SUM(meal_price * order_quantity) AS revenue
  FROM meals
  JOIN orders ON meals.meal_id = orders.meal_id
-- Keep only the records in June 2018
WHERE order_date BETWEEN '2018-05-28' and '2018-06-30'
GROUP BY delivr_week
ORDER BY delivr_week ASC;

#---------------------------------------------------------------------

Cost and Common
Table Expressions
(CTEs)

Cost
The money that a company spends
Examples
Employee salaries
Delivery .eet acquisition and maintenance
Meal costs

Tables you'll need
meals
meal_id eatery meal_price meal_cost
-------- ------------------------ ---------- ---------
0 'Leaning Tower of Pizza' 4 2
1 'Leaning Tower of Pizza' 3.5 1.25
2 'Leaning Tower of Pizza' 4.5 1.75
... ... ... ...
stock
stocking_date meal_id stocked_quantity
------------- -------- ----------------
2018-06-01 0 76
2018-06-01 1 42
2018-06-01 2 56
... ... ...

Calculating cost
Query
SELECT
meals.meal_id,
SUM(meal_cost * stocked_quantity) AS cost
FROM meals
JOIN stock ON meals.meal_id = stock.meal_id
GROUP BY meals.meal_id
ORDER BY meals.cost DESC
LIMIT 3;

How do you combine revenue and cost?
Pro,t = Revenue - Cost
The individual queries for revenue and cost have been wri

Common Table Expressions (CTEs)
Store a query's results in a temporary table
Reference the temporary table in a following query
Query
WITH table_1 AS
(SELECT ...
FROM ...),
table_2 AS
(SELECT ...
FROM ...)
SELECT ...
FROM table_1
JOIN table_2 ON ...
...

CTEs in action
Query
WITH costs_and_quantities AS (
SELECT
meals.meal_id,
SUM(stocked_quantity) AS quantity,
SUM(meal_cost * stocked_quantity) AS cost
FROM meals
JOIN stock ON meals.meal_id = stock.meal_id
GROUP BY meals.meal_id)
SELECT
meal_id,
quantity,
cost
FROM costs_and_quantities
ORDER BY cost DESC
LIMIT 3;


#---------------------------------------------------------------------
Total cost

What is Delivr's total cost since it began operating?

RRR

WITH costs_and_quantities AS (
SELECT
meals.meal_id,
SUM(stocked_quantity) AS quantity,
SUM(meal_cost * stocked_quantity) AS cost
FROM meals
JOIN stock ON meals.meal_id = stock.meal_id
GROUP BY meals.meal_id)
SELECT
SUM(cost)
FROM costs_and_quantities;

#---------------------------------------------------------------------

Top meals by cost

Alice from Finance wants to know what Delivr's top 5 meals are by overall cost; in other words, Alice wants to know the 5 meals that Delivr has spent the most on for stocking.

You're provided with an aggregate query; you'll need to fill in the blanks to get the output Alice needs.

Note: Recall that in the meals table, meal_price is what the user pays Delivr for the meal, while meal_cost is what Delivr pays its eateries to stock this meal.

RRR

SELECT
  -- Calculate cost per meal ID
  meals.meal_id,
  SUM(meal_cost * stocked_quantity) AS cost
FROM meals
JOIN stock ON meals.meal_id = stock.meal_id
GROUP BY meals.meal_id
ORDER BY cost DESC
-- Only the top 5 meal IDs by purchase cost
LIMIT 5;

#---------------------------------------------------------------------Ç

Using CTEs

Alice wants to know how much Delivr spent per month on average during its early months (before September 2018). You'll need to write two queries to solve this problem:

    A query to calculate cost per month, wrapped in a CTE,
    A query that averages monthly cost before September 2018 by referencing the CTE.

RRR

STEP 01

SELECT
  -- Calculate cost
  DATE_TRUNC('month', stocking_date)::DATE AS delivr_month,
  SUM(meal_cost * stocked_quantity) AS cost
FROM meals
JOIN stock ON meals.meal_id = stock.meal_id
GROUP BY delivr_month
ORDER BY delivr_month ASC;

STEP 02

-- Declare a CTE named monthly_cost
WITH monthly_cost AS (
  SELECT
    DATE_TRUNC('month', stocking_date)::DATE AS delivr_month,
    SUM(meal_cost * stocked_quantity) AS cost
  FROM meals
  JOIN stock ON meals.meal_id = stock.meal_id
  GROUP BY delivr_month)

SELECT *
FROM monthly_cost;

STEP 03

-- Declare a CTE named monthly_cost
WITH monthly_cost AS (
  SELECT
    DATE_TRUNC('month', stocking_date)::DATE AS delivr_month,
    SUM(meal_cost * stocked_quantity) AS cost
  FROM meals
  JOIN stock ON meals.meal_id = stock.meal_id
  GROUP BY delivr_month)

SELECT
  -- Calculate the average monthly cost before September
  AVG(cost)
FROM monthly_cost
WHERE delivr_month < '2018-09-01';


#---------------------------------------------------------------------
Profit

Recap
Revenue: The money a company makes
Multiply each meal's price times its ordered quantity, then sum the results
Cost: The money a company spends
Multiply each meal's cost times its stocked quantity, then sum the results
Pro,t = Revenue - Cost

Why is profit important?
Key Performance Indicator (KPI): A metric with some value that a company use to measure
its performance
Pro,t per user: Identify the "best" users
Pro,t per meal: Identify the most pro,table meals
Pro,t per month: Tracks pro,t over time

Revenue vs profit
meal_id meal_price order_quantity revenue cost profit
------- ---------- -------------- ------- ---- ------
21 8 100 800 500 300
22 5 80 400 80 320
Meal ID 21 has a higher price (8), ordered quantity (100), and revenue (800)
However, meal ID 22 brings in more pro,t (320) for Delivr

Bringing revenue and cost together
Query
WITH revenue AS (
SELECT
meals.meal_id,
SUM(meal_price * meal_quantity) AS revenue
FROM meals
JOIN orders ON meals.meal_id = orders.meal_id
GROUP BY meals.meal_id),
cost AS (
SELECT
meals.meal_id,
SUM(meal_cost * stocked_quantity) AS cost
FROM meals
JOIN stock ON meals.meal_id = stock.meal_id
GROUP BY meals.meal_id)

Calculating profit
Query
WITH revenue AS (...),
cost AS (...)
SELECT
revenue.meal_id,
revenue,
cost,
revenue - cost AS profit
FROM revenue
JOIN cost ON revenue.meal_id = cost.meal_id
ORDER BY profit DESC
LIMIT 3;

#---------------------------------------------------------------------

Profit per eatery

Delivr is renegotiating its contracts with its eateries. The higher the profit that an eatery generates, the higher the rate that Delivr is willing to pay this eatery for the bulk purchase of meals.

The Business Development team asks you to find out how much profit each eatery is generating to strengthen their negotiating positions.

Note: You don't need to GROUP BY eatery in the final query. You've already grouped by eatery in the revenue and cost CTEs; all that's required is joining them to each other to get each eatery's revenue and cost in one row. Since revenue and cost take up one row each per eatery, there are no additional groupings to be made.

RRR

WITH revenue AS (
  -- Calculate revenue per eatery
  SELECT meals.eatery,
         SUM(meal_price * order_quantity) AS revenue
    FROM meals
    JOIN orders ON meals.meal_id = orders.meal_id
   GROUP BY eatery),

  cost AS (
  -- Calculate cost per eatery
  SELECT meals.eatery,
         SUM(meal_cost * stocked_quantity) AS cost
    FROM meals
    JOIN stock ON meals.meal_id = stock.meal_id
   GROUP BY eatery)

   -- Calculate profit per eatery
   SELECT revenue.eatery,
          revenue - cost AS profit
     FROM revenue
     JOIN cost ON revenue.eatery = cost.eatery
    ORDER BY profit DESC;

#---------------------------------------------------------------------

Profit per month

After prioritizing and making deals with eateries by their overall profits, Alice wants to track Delivr profits per month to see how well it's doing. You're here to help.

You're provided with two CTEs. The first stores revenue and the second stores cost. To access revenue and cost in one query, the two CTEs are joined in the last query. From there, you can apply the formula for profit Profit = Revenue - Cost to calculate profit per month.

Remember that revenue is the sum of each meal's price times its order quantity, and that cost is the sum of each meal's cost times its stocked quantity.

RRR

-- Set up the revenue CTE
WITH revenue AS ( 
	SELECT
		DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
		SUM(meal_price * order_quantity) AS revenue
	FROM meals
	JOIN orders ON meals.meal_id = orders.meal_id
	GROUP BY delivr_month),
-- Set up the cost CTE
  cost AS (
 	SELECT
		DATE_TRUNC('month', stocking_date) :: DATE AS delivr_month,
		SUM(meal_cost * stocked_quantity) AS cost
	FROM meals
    JOIN stock ON meals.meal_id = stock.meal_id
	GROUP BY delivr_month)
-- Calculate profit by joining the CTEs
SELECT
	revenue.delivr_month,
	revenue - cost AS profit
FROM revenue
JOIN cost ON revenue.delivr_month = cost.delivr_month
ORDER BY revenue.delivr_month ASC;

#---------------------------------------------------------------------
#---------------------------------------------------------------------
#---------------------------------------------------------------------

######################################################################
######################################################################
######################################################################

######## User-centric KPIs  (Module 02-031)
######################################################################

Registrations and
active users

User-centric KPIs
KPIs
  Registrations
  Active users
  Growth
  Retention
Benefits
  Measure performance well in B2Cs
  Used by investors to assess pre-revenue and -pro,t startups

Registrations - overview
  Registration: When a user ,rst signs up for an account on Delivr through its app
  Registrations KPI: Counts registrations over time, usually per month
Good at measuring a company's success in a

Registrations - setup
Query
SELECT
user_id,
MIN(order_date) AS reg_date
FROM orders
GROUP BY user_id
ORDER BY user_id
LIMIT 3;

Registrations - query
WITH reg_dates AS (
SELECT
user_id,
MIN(order_date) AS reg_date
FROM orders
GROUP BY user_id)
SELECT
DATE_TRUNC('month', reg_date) :: DATE AS delivr_month,
COUNT(DISTINCT user_id) AS regs
FROM reg_dates
GROUP BY delivr_month
ORDER BY delivr_month ASC
LIMIT 3;

Active users - overview
  Active users KPI: Counts the active users of a company's app over a time period
    by day (daily active users, or DAU)
    by month (monthly active users, or MAU)
  Stickiness (DAU / MAU), measures how o/en users engage with an app on average
    Example: If Delivr's stickiness is DAU / MAU = 0.3 (30%), users use Delivr for $30% x 30$
    days = 9 days each month on average

Active users - query
SELECT
DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
COUNT(DISTINCT user_id) AS mau
FROM orders
GROUP BY delivr_month
ORDER BY delivr_month ASC
LIMIT 3;

#---------------------------------------------------------------------
Registrations by month

Usually, registration dates are stored in a table containing users' metadata. However, Delivr only considers a user registered if that user has ordered at least once. A Delivr user's registration date is the date of that user's first order.

Bob, the Investment Relations Manager at Delivr, is preparing a pitch deck for a meeting with potential investors. He wants to add a line chart of registrations by month to highlight Delivr's success in gaining new users.

Send Bob a table of registrations by month.

RRR

STEP 01

SELECT
  -- Get the earliest (minimum) order date by user ID
  user_id,
  MIN(order_date) AS reg_date
FROM orders
GROUP BY user_id
-- Order by user ID
ORDER BY user_id ASC;

STEP 02

-- Wrap the query you wrote in a CTE named reg_dates
WITH reg_dates AS (
  SELECT
    user_id,
    MIN(order_date) AS reg_date
  FROM orders
  GROUP BY user_id)

SELECT
  -- Count the unique user IDs by registration month
  DATE_TRUNC('month', reg_date) :: DATE AS delivr_month,
  Count(reg_date) AS regs
FROM reg_dates
GROUP BY delivr_month
ORDER BY delivr_month ASC; 


#---------------------------------------------------------------------

Monthly active users (MAU)

Bob predicts that the investors won't be satisfied with only registrations by month. They will want to know how many users actually used Delivr as well. He's decided to include another line chart of Delivr's monthly active users (MAU); he's asked you to send him a table of monthly active users.

SELECT
  -- Truncate the order date to the nearest month
  DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
  -- Count the unique user IDs
  COUNT(DISTINCT user_id) AS mau
FROM orders
GROUP BY delivr_month
-- Order by month
ORDER BY delivr_month ASC;

#---------------------------------------------------------------------

Window functions

Window functions - overview
Window functions: Perform an operation across a set of rows related to the current row
Examples
Calculate a running total
Fetch the value of a previous or following row

Running total
Running total: A cumulative sum of a variable's previous values
Example
x x_rt
--- ----
1 1
2 3
3 6
4 11
5 16

running total - query
WITH reg_dates AS (
SELECT
user_id,
MIN(order_date) AS reg_date
FROM orders
GROUP BY user_id),
registrations AS (
SELECT
DATE_TRUNC('month', reg_date) :: DATE AS delivr_month,
COUNT(DISTINCT user_id) AS regs
FROM reg_dates
GROUP BY delivr_month)
SELECT
delivr_month,
regs,
SUM(regs) OVER (ORDER BY delivr_month ASC) AS regs_rt
FROM registrations
ORDER BY delivr_month ASC LIMIT 3;

Registrations running total - result
delivr_month regs regs_rt
------------ ---- -------
2018-06-01 123 123
2018-07-01 140 263
2018-08-01 157 420

Lagged MAU - query
WITH maus AS (
SELECT
DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
COUNT(DISTINCT user_id) AS mau
FROM orders
GROUP BY delivr_month)
SELECT
delivr_month,
mau,
COALESCE(
LAG(mau) OVER (ORDER BY delivr_month ASC),
1) AS last_mau
FROM maus
ORDER BY delivr_month ASC
LIMIT 3;

Lagged MAU - result
delivr_month mau last_mau
------------ --- --------
2018-06-01 123 1
2018-07-01 226 123
2018-08-01 337 226

#---------------------------------------------------------------------

Registrations running total

You have a suggestion for Bob's pitch deck: Instead of showing registrations by month in the line chart, he can show the registrations running total by month. The numbers are bigger that way, and investors always love bigger numbers! He agrees, and you begin to work on a query
 that returns a table of the registrations running total by month.

STEP 01

WITH reg_dates AS (
  SELECT
    user_id,
    MIN(order_date) AS reg_date
  FROM orders
  GROUP BY user_id)

SELECT
  -- Select the month and the registrations
  DATE_TRUNC('month', reg_date) :: DATE AS delivr_month,
  COUNT(DISTINCT user_id) AS regs
FROM reg_dates
GROUP BY delivr_month
-- Order by month in ascending order
ORDER BY delivr_month ASC; 

STEP 02

WITH reg_dates AS (
  SELECT
    user_id,
    MIN(order_date) AS reg_date
  FROM orders
  GROUP BY user_id),

  regs AS (
  SELECT
    DATE_TRUNC('month', reg_date) :: DATE AS delivr_month,
    COUNT(DISTINCT user_id) AS regs
  FROM reg_dates
  GROUP BY delivr_month)

SELECT
  -- Calculate the registrations running total by month
  delivr_month,
  SUM(regs) OVER (ORDER BY delivr_month ASC) AS regs_rt
FROM regs
-- Order by month in ascending order
ORDER BY delivr_month ASC; 

#---------------------------------------------------------------------

MAU monitor (I)

Carol from the Product team noticed that you're working with a lot of user-centric KPIs for Bob's pitch deck. While you're at it, she says, you can help build an idea of hers involving a user-centric KPI. She wants to build a monitor that compares the MAUs of the previous and current month, raising a red flag to the Product team if the current month's active users are less than those of the previous month.

To start, write a query that returns a table of MAUs and the previous month's MAU for every month.

WITH mau AS (
  SELECT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    COUNT(DISTINCT user_id) AS mau
  FROM orders
  GROUP BY delivr_month)

SELECT
  -- Select the month and the MAU
  delivr_month,
  mau,
  COALESCE(
    LAG(mau) OVER (ORDER BY delivr_month ASC),
  0) AS last_mau
FROM mau
-- Order by month in ascending order
ORDER BY delivr_month ASC;

#---------------------------------------------------------------------

Growth rate

Deltas - query
WITH maus AS (
SELECT
DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
COUNT(DISTINCT user_id) AS mau
FROM orders
GROUP BY delivr_month),
maus_lag AS (
SELECT
delivr_month,
mau,
COALESCE(
LAG(mau) OVER (ORDER BY delivr_month ASC),
1) AS last_mau
FROM maus)

...

Deltas - result
Query
WITH maus AS (...),
maus_lag AS (...)
SELECT
delivr_month,
mau,
mau - last_mau AS mau_delta
FROM maus_lag
ORDER BY delivr_month
LIMIT 3;

Result
delivr_month mau mau_delta
------------ --- ---------
2018-06-01 123 1
2018-07-01 226 103
2018-08-01 337 111

...

Deltas - pitfalls
Raw, absolute number
Only shows one of three things about a variable
Decreasing if δ < 0
Stable if δ = 0
Increasing if δ > 0

Growth rate - overview
Growth rate: A percentage that show the change in a variable over time relative to that
variable's initial value
Formula: CURRENT VALUE - PREVIUS VALUE / PREVIUS VALUE
Example: 67-50/50 = 0.34 = 34%

Growth rate - query
Query
WITH maus AS (...),
maus_lag AS (...)
SELECT
delivr_month,
mau,
ROUND(
(mau - last_mau) :: NUMERIC / last_mau,
2) AS growth
FROM maus_lag
ORDER BY delivr_month
LIMIT 3;

delivr_month mau growth
------------ --- ------
2018-06-01 123 122.00
2018-07-01 226 0.84
2018-08-01 337 0.49

#---------------------------------------------------------------------

MAU monitor (II)

Now that you've built the basis for Carol's MAU monitor, write a query that returns a table of months and the deltas of each month's current and previous MAUs.

If the delta is negative, less users were active in the current month than in the previous month, which triggers the monitor to raise a red flag so the Product team can investigate.

WITH mau AS (
  SELECT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    COUNT(DISTINCT user_id) AS mau
  FROM orders
  GROUP BY delivr_month),

  mau_with_lag AS (
  SELECT
    delivr_month,
    mau,
    -- Fetch the previous month's MAU
    COALESCE(
      LAG(mau) OVER (ORDER BY delivr_month ASC),
    0) AS last_mau
  FROM mau)

SELECT
  -- Calculate each month's delta of MAUs
  delivr_month,
  mau - last_mau AS mau_delta
FROM mau_with_lag
-- Order by month in ascending order
ORDER BY delivr_month;

#---------------------------------------------------------------------

MAU monitor (III)

Carol is very pleased with your last query, but she's requested one change: She prefers to have the month-on-month (MoM) MAU growth rate over a raw delta of MAUs. That way, the MAU monitor can have more complex triggers, like raising a yellow flag if the growth rate is -2% and a red flag if the growth rate is -5%.

Write a query that returns a table of months and each month's MoM MAU growth rate to finalize the MAU monitor.

WITH mau AS (
  SELECT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    COUNT(DISTINCT user_id) AS mau
  FROM orders
  GROUP BY delivr_month),

  mau_with_lag AS (
  SELECT
    delivr_month,
    mau,
    GREATEST(
      LAG(mau) OVER (ORDER BY delivr_month ASC),
    1) AS last_mau
  FROM mau)

SELECT
  -- Calculate the MoM MAU growth rates
  delivr_month,
  ROUND(
    (mau - last_mau) :: NUMERIC / last_mau,
  2) AS growth
FROM mau_with_lag
-- Order by month in ascending order
ORDER BY delivr_month;

#---------------------------------------------------------------------

Order growth rate

Bob needs one more chart to wrap up his pitch deck. He's covered Delivr's gain of new users, its growing MAUs, and its high retention rates. Something is missing, though. Throughout the pitch deck, there's not a single mention of the best indicator of user activity: the users' orders! The more orders users make, the more active they are on Delivr, and the more money Delivr generates.

Send Bob a table of MoM order growth rates.

(Recap: MoM means month-on-month.)

rrr

WITH orders AS (
  SELECT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    --  Count the unique order IDs
    COUNT(DISTINCT order_id) AS orders
  FROM orders
  GROUP BY delivr_month),

  orders_with_lag AS (
  SELECT
    delivr_month,
    -- Fetch each month's current and previous orders
    orders,
    COALESCE(
      LAG(orders) OVER (ORDER BY delivr_month ASC),
    1) AS last_orders
  FROM orders)

SELECT
  delivr_month,
  -- Calculate the MoM order growth rate
  ROUND(
    (orders - last_orders) :: NUMERIC / last_orders,
  2) AS growth
FROM orders_with_lag
ORDER BY delivr_month ASC;

#---------------------------------------------------------------------

Retention

MAU - pitfalls
Doesn't show the breakdown of active users by tenure
Doesn't distinguish between di(erent pa

MAU - breakdown
Breakdown
New users joined this month
Retained users were active in the previous
month, and stayed active this month
Resurrected users weren't active in the
previous month, but returned to activity this
month

Retention rate - overview
Retention rate: A percentage measuring how many users who were active in a previous
month are still active in the current month
Formula: Uc/Up, where U c is the count of distinct users who were active in both the current
and previous months, and U p is the count of distinct users who were active in the previous
period
Example: 80/100 = 0.8 = 80%

Retention rate - query
WITH user_activity AS (
SELECT DISTINCT
DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
user_id
FROM orders)
SELECT
previous.delivr_month,
ROUND(
COUNT(DISTINCT current.user_id) :: NUMERIC /
GREATEST(COUNT(DISTINCT previous.user_id), 1),
2) AS retention
FROM user_activity AS previous
LEFT JOIN user_activity AS current
ON previous.user_id = current.user_id
AND previous.delivr_month = (current.delivr_month - INTERVAL '1 month')
GROUP BY previous.delivr_month
ORDER BY previous.delivr_month ASC
LIMIT 3;



#---------------------------------------------------------------------
Retention rate

Bob's requested your help again now that you're done with Carol's MAU monitor. His meeting with potential investors is fast approaching, and he wants to wrap up his pitch deck. You've already helped him with the registrations running total by month and MAU line charts; the investors, Bob says, would be convinced that Delivr is growing both in new users and in MAUs.

However, Bob wants to show that Delivr not only attracts new users but also retains existing users. Send him a table of MoM retention rates so that he can highlight Delivr's high user loyalty.

WITH user_monthly_activity AS (
  SELECT DISTINCT
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    user_id
  FROM orders)

SELECT
  -- Calculate the MoM retention rates
  previous.delivr_month,
  ROUND(
    COUNT(DISTINCT current.user_id) :: NUMERIC /
    GREATEST(COUNT(DISTINCT previous.user_id), 1),
  2) AS retention_rate
FROM user_monthly_activity AS previous
LEFT JOIN user_monthly_activity AS current
-- Fill in the user and month join conditions
ON previous.user_id = current.user_id
AND previous.delivr_month = (current.delivr_month - INTERVAL '1 month')
GROUP BY previous.delivr_month
ORDER BY previous.delivr_month ASC;

#---------------------------------------------------------------------

######################################################################
######################################################################
######################################################################

######## ARPU, histograms, and percentiles (Module 03-031)
######################################################################

Unit economics

Unit economics
Unit economics: Measures performance per unit, as opposed to overall performance
Example: Average Revenue Per User (ARPU)
Formula: revenue / Count of users
Use: Measures a company's success in scaling its business model

ARPU - query (I)

WITH kpis AS (
SELECT
SUM(meal_price * order_quantity) AS revenue,
COUNT(DISTINCT user_id) AS users
FROM meals
JOIN orders ON meals.meal_id = orders.meal_id)
SELECT
ROUND(
revenue :: NUMERIC / GREATEST(users, 1),
2) AS arpu
FROM kpis;

ARPU - query (I) by month

WITH kpis AS (
SELECT
DATE_TRUNC('month', order_date) AS delivr_month,
SUM(meal_price * order_quantity) AS revenue,
COUNT(DISTINCT user_id) AS users
FROM meals
JOIN orders ON m.meal_id = o.meal_id
GROUP BY delivr_month)
SELECT
delivr_month,
ROUND(
revenue :: NUMERIC / GREATEST(users, 1),
2) AS arpu
FROM kpis
ORDER BY delivr_month ASC;

ARPU - query (II)

WITH user_revenues AS (
SELECT
user_id,
SUM(meal_price * order_quantity) AS revenue
FROM meals
JOIN orders ON meals.meal_id = orders.meal_id
GROUP BY user_id)
SELECT
ROUND(AVG(revenue) :: NUMERIC, 2) AS arpu
FROM user_revenues;

#---------------------------------------------------------------------

Average revenue per user

Dave from Finance wants to study Delivr's performance in revenue and orders per each of its user base. In other words, he wants to understand its unit economics.

Help Dave kick off his study by calculating the overall average revenue per user (ARPU) using the first way discussed in Lesson 3.1.

-- Create a CTE named kpi
WITH kpi AS  (
  SELECT
    -- Select the user ID and calculate revenue
    user_id,
    SUM(m.meal_price * o.order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)
-- Calculate ARPU
SELECT ROUND(AVG(revenue) :: NUMERIC, 2) AS arpu
FROM kpi;

#---------------------------------------------------------------------

ARPU per week

Next, Dave wants to see whether ARPU has increased over time. Even if Delivr's revenue is increasing, it's not scaling well if its ARPU is decreasing—it's generating less revenue from each of its customers.

Send Dave a table of ARPU by week using the second way discussed in Lesson 3.1.

WITH kpi AS (
  SELECT
    -- Select the week, revenue, and count of users
    DATE_TRUNC('week', order_date) :: DATE AS delivr_week,
    SUM(meal_price * order_quantity) AS revenue,
    COUNT(DISTINCT user_id) AS users
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY delivr_week)

SELECT
  delivr_week,
  -- Calculate ARPU
  ROUND(
    revenue :: NUMERIC / GREATEST(users, 1),
  2) AS arpu
FROM kpi
-- Order by week in ascending order
ORDER BY delivr_week ASC;

#---------------------------------------------------------------------
Average orders per user

Dave wants to add the average orders per user value to his unit economics study, since more orders usually correspond to more revenue.

Calculate the average orders per user for Dave.

Note: The count of distinct orders is different than the sum of ordered meals. One order can have many meals within it. Average orders per user depends on the count of orders, not the sum of ordered meals.

WITH kpi AS (
  SELECT
    -- Select the count of orders and users
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT user_id) AS users
  FROM orders)

SELECT
  -- Calculate the average orders per user
  ROUND(
    orders :: NUMERIC / GREATEST(users, 1),
  2) AS arpu
FROM kpi;

#---------------------------------------------------------------------

Histograms - overview
Histogram: Visualizes the frequencies of each
value in a dataset
Frequency table

Histograms - query (I)
WITH user_orders AS (
SELECT
user_id,
COUNT(DISTINCT order_id) AS orders
FROM meals
JOIN orders ON meals.meal_id = orders.meal_id
GROUP BY user_id)
SELECT
orders,
COUNT(DISTINCT user_id) AS users
FROM user_orders
GROUP BY orders
ORDER BY orders ASC;

Histograms - query (II)
WITH user_revenues AS (
SELECT
user_id,
SUM(meal_price * order_quantity) AS revenue
FROM meals
JOIN orders ON meals.meal_id = orders.meal_id
GROUP BY user_id)
SELECT
ROUND(revenue :: NUMERIC, -2) AS revenue_100,
COUNT(DISTINCT user_id) AS users
FROM user_revenues
GROUP BY revenue_100
ORDER BY revenue_100 ASC;

#---------------------------------------------------------------------

Histogram of revenue

After determining that Delivr is doing well at scaling its business model, Dave wants to explore the distribution of revenues. He wants to see whether the distribution is U-shaped or normal to see how best to categorize users by the revenue they generate.

Send Dave a frequency table of revenues by user.

WITH user_revenues AS (
  SELECT
    -- Select the user ID and revenue
    user_id,
    SUM(meal_price * order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)

SELECT
  -- Return the frequency table of revenues by user
  ROUND(revenue :: NUMERIC, -2) AS revenue_100,
  COUNT(DISTINCT user_id) AS users
FROM user_revenues
GROUP BY revenue_100
ORDER BY revenue_100 ASC;

#---------------------------------------------------------------------

Histogram of orders

Dave also wants to plot the histogram of orders to see if it matches the shape of the histogram of revenues.

Send Dave a frequency table of orders by user.

WITH user_orders AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS orders
  FROM orders
  GROUP BY user_id)

SELECT
  -- Return the frequency table of orders by user
  orders,
  COUNT(DISTINCT user_id) AS users
FROM user_orders
GROUP BY orders
ORDER BY orders ASC;

#---------------------------------------------------------------------

Bucketing users by revenue

Based on his analysis, Dave identified that $150 is a good cut-off for low-revenue users, and $300 is a good cut-off for mid-revenue users. He wants to find the number of users in each category to tweak Delivr's business model.

Split the users into low, mid, and high-revenue buckets, and return the count of users in each group.

WITH user_revenues AS (
  SELECT
    -- Select the user IDs and the revenues they generate
    user_id,
    SUM(meal_price * order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)

SELECT
  -- Fill in the bucketing conditions
  CASE
    WHEN revenue < 150 THEN 'Low-revenue users'
    WHEN revenue < 300 THEN 'Mid-revenue users'
    ELSE 'High-revenue users'
  END AS revenue_group,
  COUNT(DISTINCT user_id) AS users
FROM user_revenues
GROUP BY revenue_group;

#---------------------------------------------------------------------

Bucketing users by orders

Dave is repeating his bucketing analysis on orders to have a more complete profile of each group. He determined that 8 orders is a good cut-off for the low-orders group, and 15 is a good cut-off for the medium orders group.

Send Dave a table of each order group and how many users are in it.

-- Store each user's count of orders in a CTE named user_orders
WITH user_orders AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS orders
  FROM orders
  GROUP BY user_id)

SELECT
  -- Write the conditions for the three buckets
  CASE
    WHEN orders < 8 THEN 'Low-orders users'
    WHEN orders < 15 THEN 'Mid-orders users'
    ELSE 'High-orders users'
  END AS order_group,
  -- Count the distinct users in each bucket
  COUNT(DISTINCT user_id) AS users
FROM user_orders
GROUP BY order_group;

#---------------------------------------------------------------------
Percentiles - overview
Percentile: nth percentile is the value for which n% of a dataset's values are beneath this
value
Lowest value is the 0th percentile
Highest value is the 99th percentile

Quartiles
Example: 25th percentile of user orders is 17, then 25% have ordered 17 times or less
First quartile: 25th percentile
Third quartile: 75th percentile
Interquartile range (IQR): All data between the Quartiles
Example: 25th percentile of user orders is 17, then 25% have ordered 17 times or less
First quartile: 25th percentile
Third quartile: 75th percentile
Interquartile range (IQR): All data between the first and third quartiles
Second quartile: 50th percentile, median
Different form the mean

Quartiles - query
WITH user_orders AS (
SELECT
user_id,
COUNT(DISTINCT order_id) AS orders
FROM orders
GROUP BY user_id)
SELECT
ROUND(
  PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY orders ASC) :: NUMERIC,2) AS orders_p25,
ROUND(
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY orders ASC) :: NUMERIC,2) AS orders_p50,
ROUND(
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY orders ASC) :: NUMERIC,2) AS orders_p75,
ROUND(AVG(orders) :: NUMERIC, 2) AS avg_orders
FROM use_orders;


#---------------------------------------------------------------------
Revenue quartiles

Dave is wrapping up his study, and wants to calculate a few more figures. He wants to find out the first, second, and third revenue quartiles. He also wants to find the average to see in which direction the data is skewed.

Calculate the first, second, and third revenue quartiles, as well as the average.

Note: You can calculate the 30th percentile for a column named column_a by using PERCENTILE_CONT(0.30) WITHIN GROUP (ORDER BY column_a ASC).

WITH user_revenues AS (
  -- Select the user IDs and their revenues
  SELECT
    user_id,
    SUM(meal_price * order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)

SELECT
  -- Calculate the first, second, and third quartile
  ROUND(
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revenue ASC) :: NUMERIC,
  2) AS revenue_p25,
  ROUND(
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue ASC) :: NUMERIC,
  2) AS revenue_p50,
  ROUND(
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue ASC) :: NUMERIC,
  2) AS revenue_p75,
  -- Calculate the average
  ROUND(AVG(revenue) :: NUMERIC, 2) AS avg_revenue
FROM user_revenues;

#---------------------------------------------------------------------
Interquartile range

The final value that Dave wants is the count of users in the revenue interquartile range (IQR). Users outside the revenue IQR are outliers, and Dave wants to know the number of "typical" users.

Return the count of users in the revenue IQR.

step01

SELECT
  -- Select user_id and calculate revenue by user
  user_id,
  SUM(meal_price * order_quantity) AS revenue
FROM meals AS m
JOIN orders AS o ON m.meal_id = o.meal_id
GROUP BY user_id;

step02

-- Create a CTE named user_revenues
WITH user_revenues AS (
  SELECT
    -- Select user_id and calculate revenue by user 
    user_id,
    SUM(m.meal_price * o.order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id)

SELECT
  -- Calculate the first and third revenue quartiles
  ROUND(
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revenue ASC) :: NUMERIC,
  2) AS revenue_p25,
  ROUND(
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue ASC) :: NUMERIC,
  2) AS revenue_p75
FROM user_revenues;

step03
WITH user_revenues AS (
  SELECT
    -- Select user_id and calculate revenue by user 
    user_id,
    SUM(m.meal_price * o.order_quantity) AS revenue
  FROM meals AS m
  JOIN orders AS o ON m.meal_id = o.meal_id
  GROUP BY user_id),

  quartiles AS (
  SELECT
    -- Calculate the first and third revenue quartiles
    ROUND(
      PERCENTILE_CONT(0.25) WITHIN GROUP
      (ORDER BY revenue ASC) :: NUMERIC,
    2) AS revenue_p25,
    ROUND(
      PERCENTILE_CONT(0.75) WITHIN GROUP
      (ORDER BY revenue ASC) :: NUMERIC,
    2) AS revenue_p75
  FROM user_revenues)

SELECT
  -- Count the number of users in the IQR
  COUNT(DISTINCT user_id) AS users
FROM user_revenues
CROSS JOIN quartiles
-- Only keep users with revenues in the IQR range
WHERE revenue :: NUMERIC >= revenue_p25
  AND revenue :: NUMERIC <= revenue_p75;
  
######################################################################
######################################################################
######################################################################

######## Generating an executive report   (Module 04-031)
######################################################################

Survey of useful
functions

Dealing with dates
DATE_TRUNC('quarter','2018-08-13') ? '2018-07-01 00:00:00+00:00'
'2018-07-01 00:00:00+00:00' :: DATE ? '2018-07-01'
Dates in reports
Human-readable dates are important in reporting
The default date format,'2018-08-13', isn't very readable
How do you get from '2018-08-13' to 'Friday 13, August 2018' ?
Solution
TO_CHAR('2018-08-13','FMDay DD, FMMonth YYYY') ? 'Friday 13, August 2018'


TO_CHAR()
TO_CHAR(DATE, TEXT) ? TEXT (the formatted date string)
Example: Dy ? Abbreviated day name ( Mon , Tues , etc.)
TO_CHAR('2018-06-01','Dy') ? 'Fri'
TO_CHAR('2018-06-02','Dy') ? 'Sat'
Patterns in the format string will be replaced by what they represent in the date; other
characters remain as-is
Example: DD ? Day number ( 01 - 31 )
TO_CHAR('2018-06-01','Dy - DD') ? 'Fri - 01'
TO_CHAR('2018-06-02','Dy - DD') ? 'Sat - 02'

Pattern     Description
FMDay       Full day name ( Monday , Tuesday , etc.)
MM          Month of year ( 01 - 12 )
Mon         Abbreviated month name ( Jan , Feb , etc.)
FMMonth     Full month name ( January , February , etc.)
YY          Last 2 digits of year ( 18 , 19 , etc.)
YYYY        Full 4-digit year ( 2018 , 2019 , etc.)

Query
SELECT DISTINCT
order_date,
TO_CHAR(order_date,
'FMDay DD, FMMonth YYYY') AS format_1,
TO_CHAR(order_date,
'Dy DD Mon/YYYY') AS format_2
FROM orders
ORDER BY order_date ASC
LIMIT 3;

Window functions revisited
SUM(...) OVER (...) : Calculates a column's running total
Example: SUM(registrations) OVER (ORDER BY registration_month) calculates the
registrations running total

LAG(...) OVER (...) : Fetches a preceding row's value
Example: LAG(mau) OVER (ORDER BY active_month) returns the previous month's active
users (MAU)

RANK() OVER (...) : Assigns a rank to each row based on that row's position in a sorted
order
Example: RANK() OVER (ORDER BY revenue DESC) ranks users, eateries, or months by the
revenue they've generated

Query
SELECT
user_id,
SUM(meal_price * order_quantity) AS revenue
FROM meals
JOIN orders ON meals.meal_id = orders.meal_id
GROUP BY user_id
ORDER BY revenue DESC
LIMIT 3;

Query
WITH user_revenues AS (
SELECT
user_id,
SUM(meal_price * order_quantity) AS revenue
FROM meals
JOIN orders ON meals.meal_id = orders.meal_id
GROUP BY user_id)
SELECT
user_id,
RANK() OVER (ORDER BY revenue DESC)
AS revenue_rank
FROM user_revenues
ORDER BY revenue_rank DESC
LIMIT 3;

#---------------------------------------------------------------------
Formatting dates

Eve from the Business Intelligence (BI) team lets you know that she's gonna need your help to write queries for reports. The reports are read by C-level execs, so they need to be as readable and quick to scan as possible. Eve tells you that the C-level execs' preferred date format is something like Friday 01, June 2018 for 2018-06-01.

You have a list of useful patterns.
Pattern 	Description
DD 	Day number (01 - 31)
FMDay 	Full day name (Monday, Tuesday, etc.)
FMMonth 	Full month name (January, February, etc.)
YYYY 	Full 4-digit year (2018, 2019, etc.)

Figure out the format string that formats 2018-06-01 as "Friday 01, June 2018" when using TO_CHAR.

SELECT DISTINCT
  -- Select the order date
  order_date,
  -- Format the order date
  TO_CHAR(order_date, 'FMDay DD, FMMonth YYYY') AS format_order_date
FROM orders
ORDER BY order_date ASC
LIMIT 3;

#---------------------------------------------------------------------
Rank users by their count of orders

Eve tells you that she wants to report which user IDs have the most orders each month. She doesn't want to display long numbers, which will only distract C-level execs, so she wants to display only their ranks. The top 1 rank goes to the user with the most orders, the second-top 2 rank goes to the user with the second-most orders, and so on.

Send Eve a list of the top 3 user IDs by orders in August 2018 with their ranks.

step01

SELECT
  user_id,
  COUNT(DISTINCT order_id) AS count_orders
FROM orders
-- Only keep orders in August 2018
WHERE DATE_TRUNC('month', order_date) = '2018-08-01'
GROUP BY user_id;

step02

-- Set up the user_count_orders CTE
WITH user_count_orders AS (
  SELECT
    user_id,
    COUNT(DISTINCT order_id) AS count_orders
  FROM orders
  -- Only keep orders in August 2018
  WHERE DATE_TRUNC('month', order_date) = '2018-08-01'
  GROUP BY user_id)

SELECT
  -- Select user ID, and rank user ID by count_orders
  user_id,
  RANK() OVER (ORDER BY count_orders DESC) AS count_orders_rank
FROM user_count_orders
ORDER BY count_orders_rank ASC
-- Limit the user IDs selected to 3
LIMIT 3;

#---------------------------------------------------------------------

Pivotin

What is pivoting?
Pivoting: Rotating a table around a pivot column; transposing a column's values into
columns
Converts a "long" table into a "wide" one

Benefits
Control a table's shape while preserving its data
Unstacked data viewed horizontally is often easier to read than stacked data viewed
vertically

Before
meal_id delivr_month count_orders
------- ------------ ------------
0 2018-06-01 39
0 2018-07-01 47
1 2018-06-01 25
1 2018-07-01 55

After
meal_id 2018-06-01 2018-07-01
------- ---------- ----------
0 39 47
1 25 55
Pivoted by delivr_month

Before table

SELECT
  meal_id,
  DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
  COUNT(DISTINCT orders) :: INT AS revenue
FROM meals
JOIN orders ON meals.meal_id = orders.meal_id
WHERE meals.meal_id IN (0, 1)
  AND order_date < '2018-08-01'
GROUP BY meal_id, delivr_month
ORDER BY meal_id, delivr_month;

CROSSTAB()
CREATE EXTENSION IF NOT EXISTS tablefunc;
CREATE EXTENSION is like import in Python
SELECT * FROM CROSSTAB($$
TEXT source_sql
$$)
AS ct (column_1 DATA_TYPE_1,
        column_2 DATA_TYPE_2,
...,
column_n DATA_TYPE_N)
;

Using CROSSTAB()
CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT * FROM CROSSTAB($$
SELECT
meal_id,
DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
COUNT(DISTINCT order_id) :: INT AS orders
FROM orders
WHERE meal_id IN (0, 1)
AND order_date < '2018-08-01'
GROUP BY meal_id, delivr_month
ORDER BY meal_id, delivr_month $$)
AS ct (meal_id INT,
"2018-06-01" INT,
"2018-07-01" INT)
ORDER BY meal_id ASC;

#---------------------------------------------------------------------
Pivoting user revenues by month

Next, Eve tells you that the C-level execs prefer wide tables over long ones because they're easier to scan. She prepared a sample report of user revenues by month, detailing the first 5 user IDs' revenues from June to August 2018. The execs told her to pivot the table by month. She's passed that task off to you.

Pivot the user revenues by month query so that the user ID is a row and each month from June to August 2018 is a column.

-- Import tablefunc
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
  SELECT
    user_id,
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    SUM(meal_price * order_quantity) :: FLOAT AS revenue
  FROM meals
  JOIN orders ON meals.meal_id = orders.meal_id
 WHERE user_id IN (0, 1, 2, 3, 4)
   AND order_date < '2018-09-01'
 GROUP BY user_id, delivr_month
 ORDER BY user_id, delivr_month;
$$)
-- Select user ID and the months from June to August 2018
AS ct (user_id INT,
       "2018-06-01" FLOAT,
       "2018-07-01" FLOAT,
       "2018-08-01" FLOAT)
ORDER BY user_id ASC;

#---------------------------------------------------------------------
Costs

The C-level execs next tell Eve that they want a report on the total costs by eatery in the last two months.

First, write a query to get the total costs by eatery in November and December 2018, then pivot by month.

Note: Recall from Chapter 1 that total cost is the sum of each meal's cost times its stocking quantity.

step01

SELECT
  -- Select eatery and calculate total cost
  eatery,
  DATE_TRUNC('month', stocking_date) :: DATE AS delivr_month,
  SUM(meal_cost * stocked_quantity) :: FLOAT AS cost
FROM meals
JOIN stock ON meals.meal_id = stock.meal_id
-- Keep only the records after October 2018
WHERE stocking_date > '2018-10-01'
GROUP BY eatery, delivr_month
ORDER BY eatery, delivr_month;

step02

-- Import tablefunc
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
  SELECT
    -- Select eatery and calculate total cost
    eatery,
    DATE_TRUNC('month', stocking_date) :: DATE AS delivr_month,
    SUM(meal_cost * stocked_quantity) :: FLOAT AS cost
  FROM meals
  JOIN stock ON meals.meal_id = stock.meal_id
  -- Keep only the records after October 2018
  WHERE DATE_TRUNC('month', stocking_date) > '2018-10-01'
  GROUP BY eatery, delivr_month
  ORDER BY eatery, delivr_month;
$$)

-- Select the eatery and November and December 2018 as columns
AS ct (eatery TEXT,
       "2018-11-01" FLOAT,
       "2018-12-01" FLOAT)
ORDER BY eatery ASC;

#---------------------------------------------------------------------

Producing executive
reports

Readability
Dates: Use readable date formats ( August 2018 , not 2018-08-01 )
Numbers: Round numbers to the second decimal at most ( 98.76 , not 98.761234 )
Table shape: Reshape long tables into wide ones, pivoting by date when possible
Order: Don't forget to sort!

Executive report - query
Query
SELECT
eatery,
TO_CHAR(order_date,
'MM-Mon YYYY') AS delivr_month,
COUNT(DISTINCT order_id) AS count_orders
FROM meals
JOIN orders ON meals.meal_id = orders.meal_id
WHERE order_date >= '2018-10-01'
GROUP BY eatery, delivr_month
ORDER BY eatery, delivr_month;

Executive report (II)
WITH eatery_orders AS (
SELECT
eatery,
TO_CHAR(order_date,'MM-Mon YYYY') AS delivr_month,
COUNT(DISTINCT order_id) AS count_orders
FROM meals
WHERE order_date >= '2018-10-01'
JOIN orders ON meals.meal_id = orders.meal_id
GROUP BY eatery, delivr_month)

SELECT
eatery,
delivr_month,
RANK() OVER
(PARTITION BY delivr_month
ORDER BY count_orders DESC) :: INT AS orders_rank
FROM eatery_orders
ORDER BY eatery, delivr_month;

CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT * FROM CROSSTAB($$
...
$$) AS ct (eatery TEXT,
"10-Oct 2018" INT,
"11-Nov 2018" INT,
"12-Dec 2018" INT)
ORDER BY eatery ASC;

Executive report - result
eatery Q2 2018 Q3 2018 Q4 2018
---------------------- ------- ------- -------
The Moon Wok 1 1 1
Bean Me Up Scotty 3 2 2
Leaning Tower of Pizza 4 4 3
Burgatorio 2 3 4
Life of Pie 5 5 5

#---------------------------------------------------------------------

Executive report

Eve wants to produce a final executive report about the rankings of eateries by the number of unique users who order from them by quarter. She said she'll handle the pivoting, so you only need to prepare the source table for her to pivot.

Send Eve a table of unique ordering users by eatery and by quarter.

step01

SELECT
  eatery,
  -- Format the order date so "2018-06-01" becomes "Q2 2018"
  TO_CHAR(order_date, '"Q"Q YYYY') AS delivr_quarter,
  -- Count unique users
  COUNT(DISTINCT user_id) AS users
FROM meals
JOIN orders ON meals.meal_id = orders.meal_id
GROUP BY eatery, delivr_quarter
ORDER BY delivr_quarter, users;

step02

WITH eatery_users AS  (
  SELECT
    eatery,
    -- Format the order date so "2018-06-01" becomes "Q2 2018"
    TO_CHAR(order_date, '"Q"Q YYYY') AS delivr_quarter,
    -- Count unique users
    COUNT(DISTINCT user_id) AS users
  FROM meals
  JOIN orders ON meals.meal_id = orders.meal_id
  GROUP BY eatery, delivr_quarter
  ORDER BY delivr_quarter, users)

SELECT
  -- Select eatery and quarter
  eatery,
  delivr_quarter,
  -- Rank rows, partition by quarter and order by users
  RANK() OVER
    (PARTITION BY delivr_quarter
     ORDER BY users DESC) :: INT AS users_rank
FROM eatery_users
ORDER BY delivr_quarter, users_rank;

step03

-- Import tablefunc
CREATE EXTENSION IF NOT EXISTS tablefunc;

-- Pivot the previous query by quarter
SELECT * FROM CROSSTAB($$
  WITH eatery_users AS  (
    SELECT
      eatery,
      -- Format the order date so "2018-06-01" becomes "Q2 2018"
      TO_CHAR(order_date, '"Q"Q YYYY') AS delivr_quarter,
      -- Count unique users
      COUNT(DISTINCT user_id) AS users
    FROM meals
    JOIN orders ON meals.meal_id = orders.meal_id
    GROUP BY eatery, delivr_quarter
    ORDER BY delivr_quarter, users)

  SELECT
    -- Select eatery and quarter
    eatery,
    delivr_quarter,
    -- Rank rows, partition by quarter and order by users
    RANK() OVER
      (PARTITION BY delivr_quarter
       ORDER BY users DESC) :: INT AS users_rank
  FROM eatery_users
  ORDER BY eatery, delivr_quarter;
$$)
-- Select the columns of the pivoted table
AS  ct (eatery TEXT,
        "Q2 2018" INT,
        "Q3 2018" INT,
        "Q4 2018" INT)
ORDER BY "Q4 2018";

#---------------------------------------------------------------------

Course recap
Course recap
Chapter 1: Revenue, cost, and profit
Chapter 2: User-centric metrics
Chapter 3: Unit economics and distributions
Chapter 4: Generating an executive report


END

*/