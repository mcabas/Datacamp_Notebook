/*
######################################################################
######################################################################
######################################################################
DataCamp.Course_032_Reporting_in_SQL
# COURSE Reporting in SQL_032

######################################################################
######################################################################
######################################################################

######## Exploring the Olympics Dataset (Module 01-032)
######################################################################

Case study

Course goals
Create real-world reports
Use real-world data
Overcome real-world obstacles


What is a base report?
SELECT
country,
SUM(wins) AS wins
FROM game_log
GROUP BY country
ORDER BY wins DESC
LIMIT 3;

The Olympics
dataset

Building the base report

Now, build the base report for this visualization:

This should be built by querying the summer_games table, found in the explorer on the bottom right.

-- Query the sport and distinct number of athletes
SELECT 
	sport, 
    COUNT(distinct(athlete_id)) AS athletes
FROM summer_games
GROUP BY sport
-- Only include the 3 sports with the most athletes
ORDER BY athletes DESC
LIMIT 3;

#---------------------------------------------------------------------

Athletes vs events by sport

Now consider the following visualization:

Using the summer_games table, run a query that creates the base report that sources this visualization.

-- Query sport, events, and athletes from summer_games
SELECT 
	sport, 
    COUNT(DISTINCT(event)) AS events, 
    COUNT(DISTINCT(athlete_id)) AS athletes
FROM summer_games
GROUP BY sport;

#---------------------------------------------------------------------

The Olympics dataset

Entity-Relationship (E:R) diagram
Visual representation of database structure
Lays out tables and fields
Identifies relationships

Olympics dataset E:R diagram

SELECT *
FROM countries AS c1
JOIN country_stats AS c2
ON c1.id = c2.country_id;

Reference for queries

SELECT
region,
SUM(pop_in_millions) AS pop_in_millions
FROM countries AS c1
JOIN country_stats AS c2
ON c1.id = c2.country_id
GROUP BY region;

#---------------------------------------------------------------------

Age of oldest athlete by region

You are given the following E:R diagram:

In the previous exercise, you identified which tables are needed to create a report that shows Age of Oldest Athlete by Region. Now, set up the query to create this report.

-- Select the age of the oldest athlete for each region
SELECT 
	region, 
    MAX(age) AS age_of_oldest_athlete
FROM countries AS c
-- First JOIN statement
JOIN summer_games as s
ON c.id = s.country_id
-- Second JOIN statement
JOIN athletes as a
ON a.id = s.athlete_id
GROUP BY region;

#---------------------------------------------------------------------

Number of events in each sport

The full E:R diagram for the database is shown below:

Since the company will be involved in both summer sports and winter sports, it is beneficial to look at all sports in one centralized report.

Your task is to create a query that shows the unique number of events held for each sport. Note that since no relationships exist between these two tables, you will need to use a UNION instead of a JOIN.

-- Select sport and events for summer sports
SELECT 
	sport, 
    COUNT(DISTINCT event) AS events
FROM summer_games
GROUP BY sport
UNION
-- Select sport and events for winter sports
SELECT 
	sport, 
    COUNT(DISTINCT event) AS events
FROM winter_games
GROUP BY sport
-- Show the most events at the top of the report
ORDER BY events DESC;

#---------------------------------------------------------------------

Exploring our data

Exploring with the console

Exploring with the console
May show an inaccurate picture
preview of table: summer_games
+-------------+-----------------------------------------+--------+
| sport | event | bronze |
|-------------|-----------------------------------------|--------|
| Gymnastics | Gymnastics Men's Individual All-Around | null |
| Gymnastics | Gymnastics Men's Floor Exercise | null |
| Gymnastics | Gymnastics Men's parallel Bars | null |
+-------------+-----------------------------------------+--------+

Exploring with the console
No insight into distributions
preview of table: clients
+--------------------+
| country_of_client |
|--------------------|
| United States |
| United States |
| Mexico |
| United States |
| Canada |
| Canada |
+--------------------+

Exploring with queries
SELECT DISTINCT region
FROM countries;
+-------------------------+
| region |
|-------------------------|
| WESTERN EUROPE |
| null |
| C.W. IF IND. STATES |
| OCEANIA |
| NEAR EAST |
| SUB-SAHARAN AFRICA |
+-------------------------+

Exploring with queries
SELECT region
FROM countries
GROUP BY region;
+-------------------------+
| region |
|-------------------------|
| WESTERN EUROPE |
| null |
| C.W. IF IND. STATES |
| OCEANIA |
| NEAR EAST |
| SUB-SAHARAN AFRICA |
+-------------------------+

Field-level aggregations
SELECT region, COUNT(*) AS row_num
FROM countries
GROUP BY region
ORDER BY row_num DESC;
+-------------------------+---------+
| region | row_num |
|-------------------------|---------|
| SUB-SAHARAN AFRICA | 49 |
| LATIN AMER. & CARIB | 38 |
| ASIA (EX. NEAR EAST) | 26 |
| WESTERN EUROPE | 23 |
| OCEANIA | 15 |
| EASTERN EUROPE | 15 |
+-------------------------+---------+

Field-level aggregations
SELECT revenue_source, SUM(revenue) AS revenue
FROM orders
GROUP BY revenue_source
ORDER BY revenue DESC;
+----------------+----------+
| revenue_source | revenue |
|----------------|----------|
| Olympics | 122000 |
| NFL | 80500 |
| MLB | 300 |
| NBA | 220 |
| NCAAF | 120 |
| NCAAB | 90 |
+----------------+----------+

Table-level aggregations
SELECT COUNT(*)
FROM country_
stats;
+---------+
| count |
|---------|
| 3451 |
+---------+

Query validation
QUERY:
SELECT SUM(rev) AS revenue
FROM
(SELECT country, SUM(rev) AS rev
FROM orders AS o
JOIN countries AS c
ON o.country_id = c.id
GROUP BY country);
+------------+
| revenue |
|------------|
| 50.00 |
+------------+

ORIGINAL TABLE:
SELECT SUM(rev) AS revenue
FROM orders;
+------------+
| revenue |
|------------|
| 500.00 |
+------------+
Our Query (Left) = $50
Original Table (Right) = $500
Lost 90% of revenue from JOIN

Query validation
QUERY:
SELECT SUM(rev) AS revenue
FROM
(SELECT country, SUM(rev) AS rev
FROM orders AS o
JOIN country_stats AS cs
ON o.country_id = cs.country_id
GROUP BY country);
+------------+
| revenue |
|------------|
| 5,000.00 |
+------------+

ORIGINAL TABLE:
SELECT SUM(rev) AS revenue
FROM orders;
+------------+
| revenue |
|------------|
| 500.00 |
+------------+
Our Query (Left) = $5,000
Original Table (Right) = $500
10x duplication from JOIN

#---------------------------------------------------------------------

Exploring summer_games

Exploring the data in a table can provide further insights into the database as a whole. In this exercise, you will try out a series of different techniques to explore the summer_games table.

step01

-- Update the query to explore the bronze field
SELECT bronze
FROM summer_games;

step02

-- Update query to explore the unique bronze field values
SELECT DISTINCT bronze
FROM summer_games;

step03

-- Recreate the query by using GROUP BY 
SELECT bronze
FROM summer_games
GROUP BY bronze;

step04

-- Add the rows column to your query
SELECT 
	bronze, 
	count(*) AS rows
FROM summer_games
GROUP BY bronze;

#---------------------------------------------------------------------

Validating our query

The same techniques we use to explore the data can be used to validate queries. By using the query as a subquery, you can run exploratory techniques to confirm the query results are as expected.

In this exercise, you will create a query that shows Bronze Medals by Country and then validate it using the subquery technique.

Feel free to reference the E:R Diagram as needed.

step01

-- Pull total_bronze_medals from summer_games below
SELECT SUM(bronze) AS total_bronze_medals
FROM summer_games;

step02

/* Pull total_bronze_medals from summer_games below
SELECT SUM(bronze) AS total_bronze_medals
FROM summer_games; 
>> OUTPUT = 141 total_bronze_medals */

-- Setup a query that shows bronze_medal by country 
/*
SELECT 
	country, 
    SUM(bronze) AS bronze_medals
FROM summer_games AS s
JOIN countries AS c
ON s.country_id = c.id
GROUP BY country;
/*

step03

/* Pull total_bronze_medals from summer_games below
SELECT SUM(bronze) AS total_bronze_medals
FROM summer_games; 
>> OUTPUT = 141 total_bronze_medals */

-- Select the total bronze_medals from your query
/*
SELECT SUM(bronze_medals)
FROM 
-- Previous query is shown below.  Alias this AS subquery.
  (SELECT 
      country, 
      SUM(bronze) AS bronze_medals
  FROM summer_games AS s
  JOIN countries AS c
  ON s.country_id = c.id
  GROUP BY country) AS subquery
;

#---------------------------------------------------------------------

Report 1: Most decorated summer athletes

Now that you have a good understanding of the data, let's get back to our case study and build out the first element for the dashboard, Most Decorated Summer Athletes:

Your job is to create the base report for this element. Base report details:

    Column 1 should be athlete_name.
    Column 2 should be gold_medals.
    The report should only include athletes with at least 3 medals.
    The report should be ordered by gold medals won, with the most medals at the top.

-- Pull athlete_name and gold_medals for summer games
SELECT 
	____ AS athlete_name, 
    ____ AS gold_medals
FROM ____ AS s
JOIN ____ AS a
ON ____
GROUP BY ____
-- Filter for only athletes with 3 gold medals or more
____
-- Sort to show the most gold medals at the top
ORDER BY ____;


######################################################################
######################################################################
######################################################################

######## Creating Reports (Module 02-032)
######################################################################

Planning the query

Chapter goal

Questions to ask
What tables do we need to pull from?
How should we combine the tables?
What fields do we need to create?
What filters need to be included?
Any ordering or limiting needed?

Scenario
Gold Medals by Demographic Group
(Western European Countries Only)
+----------+--------------------+-------+
| season | demographic
_group | golds |
|----------|--------------------|-------|
| Winter | Male Age 26+ | 13 |
| Winter | Female Age 26+ | 8 |
| Summer | Male Age 13-25 | 7 |
| Summer | Female Age 13-25 | 6 |
| Winter | Male Age 13-25 | 4 |
| Summer | Male Age 26+ | 4 |
| Winter | Female Age 13-25 | 4 |
| Summer | Female Age 26+ | 2 |
+----------+--------------------+-------+

3 - What fields do we need to create?
+----------+--------------------+-------+
| season | demographic
_group | golds |
|----------|--------------------|-------|
| Winter | Male Age 26+ | 13 |
| Winter | Female Age 26+ | 8 |
| Summer | Male Age 13-25 | 7 |
| Summer | Female Age 13-25 | 6 |
| Winter | Male Age 13-25 | 4 |
| Summer | Male Age 26+ | 4 |
+----------+--------------------+-------+
season - static string
demographic
_group - conditional
golds - SUM()

4 - What filters need to be included?
Gold Medals by Demographic Group
(Western European Countries Only)
+----------+--------------------+-------+
| season | demographic
_group | golds |
|----------|--------------------|-------|
| Winter | Male Age 26+ | 13 |
| Winter | Female Age 26+ | 8 |
| Summer | Male Age 13-25 | 7 |
| Summer | Female Age 13-25 | 6 |
| Winter | Male Age 13-25 | 4 |
| Summer | Male Age 26+ | 4 |
+----------+--------------------+-------+
WHERE or HAVING ?
Filter on dimension = WHERE

5 - Any ordering or limiting needed?
Gold Medals by Demographic Group
(Western European Countries Only)
+----------+--------------------+-------+
| season | demographic
_group | golds |
|----------|--------------------|-------|
| Winter | Male Age 26+ | 13 |
| Winter | Female Age 26+ | 8 |
| Summer | Male Age 13-25 | 7 |
| Summer | Female Age 13-25 | 6 |
| Winter | Male Age 13-25 | 4 |
| Summer | Male Age 26+ | 4 |
+----------+--------------------+-------+
No LIMIT needed
Sort by golds in descending order

#---------------------------------------------------------------------

Planning the filter

Your boss is looking to see which winter events include athletes over the age of 40. To answer this, you need a report that lists out all events that satisfy this condition. In order to have a correct list, you will need to leverage a filter. In this exercise, you will decide which filter option to use.

-- Pull distinct event names found in winter_games
SELECT DISTINCT event
FROM winter_games;

#---------------------------------------------------------------------

Combining tables

Goal report
Gold Medals by Demographic Group
(Western European Countries Only)
+----------+--------------------+-------+
| season | demographic
_group | golds |
|----------+--------------------+-------|
| Winter | Male Age 26+ | 13 |
| Winter | Female Age 26+ | 8 |
| Summer | Male Age 13-25 | 7 |
| Summer | Female Age 13-25 | 6 |
| Winter | Male Age 13-25 | 4 |
| Summer | Male Age 26+ | 4 |
| Winter | Female Age 13-25 | 4 |
| Summer | Female Age 26+ | 2 |
+----------+--------------------+-------+

Relevant tables

Option A: JOIN first, UNION second
Step 1: Setup top query with JOIN
SELECT
athlete_id,
gender,
age,
gold
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id;
Query ran successfully!

Option A: JOIN first, UNION second
Step 2: Setup bottom query + UNION the two
SELECT
athlete_id,
gender,
age,
gold
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id
UNION ALL
SELECT
athlete_id,
gender,
age,
gold
FROM winter_games AS wg
JOIN athletes AS a
ON wg.athlete_id = a.id;

Option B: UNION first, JOIN second
Step 1: Create initial UNION
SELECT
athlete_id,
gold
FROM summer_games AS sg
UNION
SELECT
athlete_id,
gold
FROM winter_games AS wg;

Option B: UNION first, JOIN second
Step 2: Convert to subquery + JOIN
SELECT
athlete_id,
gender,
age,
gold
FROM
(SELECT
athlete_id,
gold
FROM summer_games AS sg
UNION ALL
SELECT athlete_id, gold
FROM winter_games AS wg) AS g
JOIN athletes AS a
ON g.athlete_id = a.id;

Comparison
Option A
SELECT
athlete_id,
gender,
age,
gold
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id
UNION ALL
SELECT
athlete_id,
gender,
age,
gold
FROM winter_games AS wg
JOIN athletes AS a
ON wg.athlete_id = a.id;

Option B
SELECT
athlete_id,
gender,
age,
gold
FROM
(SELECT
athlete_id,
gold
FROM summer_games AS sg
UNION ALL
SELECT athlete_id, gold
FROM winter_games AS wg) AS g
JOIN athletes AS a
ON g.athlete_id = a.id;

Key takeaways
Several ways to create the same report
Step-by-step = easier to troubleshoot

Creating custom
fields

Goal report
+----------+--------------------+-------+
| season | demographic
_group | golds |
|----------+--------------------+-------|
| Winter | Male Age 26+ | 13 |
| Winter | Female Age 26+ | 8 |
| Summer | Male Age 13-25 | 7 |
+----------+--------------------+-------+
SELECT athlete_id, gender, age, gold
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id
UNION ALL
SELECT athlete_id, gender, age, gold
FROM winter_games AS wg
JOIN athletes AS a
ON wg.athlete_id = a.id;

Preparation
Step 1: Comment out bottom half

SELECT athlete_id, gender, age, gold
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id;
/*UNION ALL
SELECT athlete_id, gender, age, gold
FROM winter_games AS wg
JOIN athletes AS a
ON wg.athlete_id = a.id;*/
/*

Preparation
Step 2: Add new field placeholders

SELECT
--___ AS season,
--___ AS demographic_group,
--___ AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id;
/*UNION ALL
SELECT athlete_id, gender, age, gold
FROM winter_games AS wg
JOIN athletes AS a
ON wg.athlete_id = a.id;*/
/*

Field 1: seasons
SELECT
'Summer' AS season,
--___AS demographic_group,
--___AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id;

Field 2: golds
SELECT
'Summer' AS season,
--___AS demographic_group,
SUM(gold) AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id;
+---------+-------+
| season | golds |
|---------+-------|
| Summer | 159 |
+---------+-------+

Field 3: demographic_group
+--------+-------+--------------------+
| gender | age | demographic
_group |
|--------+-------+--------------------|
| M | 18 | Male Age 13-25 |
| M | 31 | Male Age 26+ |
| F | 22 | Female Age 13-25 |
| F | 26 | Female Age 26+ |
+--------+-------+--------------------+

CASE statement
CASE WHEN {condition_1} THEN {output_1}
WHEN {condition_2} THEN {output_2}
ELSE {output_3}
END

Field 3: demographic_group
SELECT
'Summer' AS season,
CASE WHEN___THEN 'Male Age 13-25'
WHEN___THEN 'Male Age 26+'
WHEN___THEN 'Female Age 13-25'
WHEN___THEN 'Female Age 26+'
END AS demographic_group,
SUM(gold) AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id;

Field 3: demographic_group
SELECT
'Summer' AS season,
CASE WHEN age >= 13 AND age <= 25 AND gender = 'M' THEN 'Male Age 13-25'
WHEN ___ THEN 'Male Age 26+'
WHEN ___ THEN 'Female Age 13-25'
WHEN ___ THEN 'Female Age 26+'
END AS demographic_group,
SUM(gold) AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id;

Field 3: demographic_group
SELECT
'Summer' AS season,
CASE WHEN age >= 13 AND age <= 25 AND gender = 'M' THEN 'Male Age 13-25'
WHEN age > 25 AND gender = 'M' THEN 'Male Age 26+'
WHEN age >= 13 AND age <= 25 AND gender = 'F' THEN 'Female Age 13-25'
WHEN age > 25 AND gender = 'F' THEN 'Female Age 26+'
END AS demographic_group,
SUM(gold) AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id;
ERROR: Column must be in a GROUP BY clause.

Field 3: demographic_group
SELECT
'Summer' AS season,
CASE WHEN age >= 13 AND age <= 25 AND gender = 'M' THEN 'Male Age 13-25'
WHEN age > 25 AND gender = 'M' THEN 'Male Age 26+'
WHEN age >= 13 AND age <= 25 AND gender = 'F' THEN 'Female Age 13-25'
WHEN age > 25 AND gender = 'F' THEN 'Female Age 26+'
END AS demographic_group,
SUM(gold) AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id
GROUP BY demographic_group;
Query Ran Successfully!

Field 3: demographic_group
SELECT
'Summer' AS season,
CASE WHEN age >= 13 AND age <= 25 AND gender = 'M' THEN 'Male Age 13-25'
WHEN age > 25 AND gender = 'M' THEN 'Male Age 26+'
WHEN age >= 13 AND age <= 25 AND gender = 'F' THEN 'Female Age 13-25'
WHEN age > 25 AND gender = 'F' THEN 'Female Age 26+'
END AS demographic_group,
SUM(gold) AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id
GROUP BY demographic_group;
No ELSE statement = easier to validate

New state of query
SELECT
'Summer' AS season,
CASE WHEN age >= 13 AND age <= 25 AND gender = 'M' THEN 'Male Age 13-25'
WHEN age > 25 AND gender = 'M' THEN 'Male Age 26+'
WHEN age >= 13 AND age <= 25 AND gender = 'F' THEN 'Female Age 13-25'
WHEN age > 25 AND gender = 'F' THEN 'Female Age 26+'
END AS demographic_group,
SUM(gold) AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id
GROUP BY demographic_group
UNION ALL
SELECT
...
FROM winter_games AS wg
JOIN athletes AS a
ON wg.athlete_id = a.id
GROUP BY demographic_group;

#---------------------------------------------------------------------

JOIN then UNION query

Your goal is to create a report with the following fields:

    season, which outputs either summer or winter
    country
    events, which shows the unique number of events

There are multiple ways to create this report. In this exercise, create the report by using the JOIN first, UNION second approach.

As always, feel free to reference your E:R Diagram to identify relevant fields and tables.
Instructions
100 XP

    Setup a query that shows unique events by country and season for summer events.
    Setup a similar query that shows unique events by country and season for winter events.
    Combine the two queries using a UNION ALL.
    Sort the report by events in descending order.

-- Query season, country, and events for all summer events
SELECT 
	'summer' AS season, 
    country, 
    COUNT(DISTINCT event) AS events
FROM summer_games AS s
JOIN countries AS c
ON s.country_id = c.id
GROUP BY country
-- Combine the queries
UNION
-- Query season, country, and events for all winter events
SELECT 
	'winter' AS season, 
    country, 
    COUNT(DISTINCT event) AS events
FROM winter_games AS w
JOIN countries AS c
ON w.country_id = c.id
GROUP BY country
-- Sort the results to show most events at the top
ORDER BY events DESC;

#---------------------------------------------------------------------

UNION then JOIN query

Your goal is to create the same report as before, which contains with the following fields:

    season, which outputs either summer or winter
    country
    events, which shows the unique number of events

In this exercise, create the query by using the UNION first, JOIN second approach. When taking this approach, you will need to use the initial UNION query as a subquery. The subquery will need to include all relevant fields, including those used in a join.

As always, feel free to reference the E:R Diagram.
Instructions
100 XP
Instructions
100 XP

    In the subquery, construct a query that outputs season, country_id and event by combining summer and winter games with a UNION ALL.
    Leverage a JOIN and another SELECT statement to show the fields season, country and unique events.
    GROUP BY any unaggregated fields.
    Sort the report by events in descending order.

-- Add outer layer to pull season, country and unique events
SELECT 
	season, 
    country, 
    COUNT(DISTINCT event) AS events
FROM
    -- Pull season, country_id, and event for both seasons
    (SELECT 
     	'summer' AS season, 
     	country_id, 
     	event
    FROM summer_games
    UNION ALL
    SELECT 
     	'winter' AS season, 
     	country_id, 
     	event
    FROM winter_games) AS subquery
JOIN countries AS c
ON subquery.country_id = c.id
-- Group by any unaggregated fields
GROUP BY season, country
-- Order to show most events at the top
ORDER BY events DESC;

#---------------------------------------------------------------------

CASE statement refresher

CASE statements are useful for grouping values into different buckets based on conditions you specify. Any row that fails to satisfy any condition will fall to the ELSE statement (or show as null if no ELSE statement exists).

In this exercise, your goal is to create the segment field that buckets an athlete into one of three segments:

    Tall Female, which represents a female that is at least 175 centimeters tall.
    Tall Male, which represents a male that is at least 190 centimeters tall.
    Other

Each segment will need to reference the fields height and gender from the athletes table. Leverage CASE statements and conditional logic (such as AND/OR) to build this.

Remember that each line of a case statement looks like this: CASE WHEN {condition} THEN {output}
Instructions
100 XP

    Update the CASE statement to output three values: Tall Female, Tall Male, and Other.

SELECT 
	name,
    -- Output 'Tall Female', 'Tall Male', or 'Other'
	CASE WHEN gender = 'F' AND height >= 175 THEN 'Tall Female'
        WHEN  gender = 'M' AND height >= 190 THEN 'Tall Male'
    ELSE 'Other' END AS segment
FROM athletes;

#---------------------------------------------------------------------

BMI bucket by sport

You are looking to understand how BMI differs by each summer sport. To answer this, set up a report that contains the following:

    sport, which is the name of the summer sport
    bmi_bucket, which splits up BMI into three groups: <.25, .25-.30, >.30
    athletes, or the unique number of athletes

Definition: BMI = 100 * weight / (height squared).

Also note that CASE statements run row-by-row, so the second conditional is only applied if the first conditional is false. This makes it that you do not need an AND statement excluding already-mentioned conditionals.

Feel free to reference the E:R Diagram.
Instructions
100 XP
Instructions
100 XP

    Build a query that pulls from summer_games and athletes to show sport, bmi_bucket, and athletes.
    Without using AND or ELSE, set up a CASE statement that splits bmi_bucket into three groups: '<.25', '.25-.30', and '>.30'.
    Group by the non-aggregated fields.
    Order the report by sport and then athletes in descending order.

-- Pull in sport, bmi_bucket, and athletes
SELECT 
	sport,
    -- Bucket BMI in three groups: <.25, .25-.30, and >.30	
    CASE WHEN 100*weight/POWER(height,2) < .25 THEN '<.25'
    WHEN 100*weight/POWER(height,2) <= .30 THEN '.25-.30'
    WHEN 100*weight/POWER(height,2) > .30 THEN '>.30' END AS bmi_bucket,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id
-- GROUP BY non-aggregated fields
GROUP BY sport,bmi_bucket
-- Sort by sport and then by athletes in descending order
ORDER BY sport, athletes DESC;


#---------------------------------------------------------------------

Troubleshooting CASE statements

In the previous exercise, you may have noticed several null values in our case statement, which can indicate there is an issue with the code.

In these instances, it's worth investigating to understand why these null values are appearing. In this exercise, you will go through a series of steps to identify the issue and make changes to the code where necessary.

-- Query from last exercise shown below.  Comment it out.
/*
SELECT 
	sport,
    CASE WHEN weight/height^2*100 <.25 THEN '<.25'
    WHEN weight/height^2*100 <=.30 THEN '.25-.30'
    WHEN weight/height^2*100 >.30 THEN '>.30' END AS bmi_bucket,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id
GROUP BY sport, bmi_bucket
ORDER BY sport, athletes DESC;
*/
-- Show height, weight, and bmi for all athletes
/*
SELECT 
	height,
    weight,
    weight/height^2*100 AS bmi
FROM athletes
-- Filter for NULL bmi values
WHERE weight IS NULL;
/*

#---------------------------------------------------------------------

Filtering and
finishing touches

Goal report
Gold Medals by Demographic Group
(Western European Countries Only)
+----------+--------------------+-------+
| season | demographic
_group | golds |
|----------+--------------------+-------|
| Winter | Male Age 26+ | 13 |
| Winter | Female Age 26+ | 8 |
| Summer | Male Age 13-25 | 7 |
| Summer | Female Age 13-25 | 6 |
| Winter | Male Age 13-25 | 4 |
| Summer | Male Age 26+ | 4 |
| Winter | Female Age 13-25 | 4 |
| Summer | Female Age 26+ | 2 |
+----------+--------------------+-------+

Filtering with a subquery
Top half of query:
SELECT
'Summer' AS season,
CASE WHEN age >= 13 AND age <= 25 AND gender = 'M' THEN 'Male Age 13-25'
WHEN age > 25 AND gender = 'M' THEN 'Male Age 26+'
WHEN age >= 13 AND age <= 25 AND gender = 'F' THEN 'Female Age 13-25'
WHEN age > 25 AND gender = 'F' THEN 'Female Age 26+'
END AS demographic_group,
SUM(gold) AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id
GROUP BY demographic_group;

Filtering with a subquery
Step 1: Setup subquery
SELECT id
FROM countries
WHERE region = 'WESTERN EUROPE';
+------+
| id |
|------|
| 5 |
| 12 |
| 19 |
+------+

Filtering with a subquery
Step 2: Setup WHERE statement
SELECT
'Summer' AS season,
CASE WHEN age >= 13 AND age <= 25 AND gender = 'M' THEN 'Male Age 13-25'
WHEN age > 25 AND gender = 'M' THEN 'Male Age 26+'
WHEN age >= 13 AND age <= 25 AND gender = 'F' THEN 'Female Age 13-25'
WHEN age > 25 AND gender = 'F' THEN 'Female Age 26+'
END AS demographic_group,
SUM(gold) AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id
WHERE country_id IN
(___)
GROUP BY demographic_group;

Filtering with a subquery
Step 2: Setup WHERE statement
SELECT
'Summer' AS season,
CASE WHEN age >= 13 AND age <= 25 AND gender = 'M' THEN 'Male Age 13-25'
WHEN age > 25 AND gender = 'M' THEN 'Male Age 26+'
WHEN age >= 13 AND age <= 25 AND gender = 'F' THEN 'Female Age 13-25'
WHEN age > 25 AND gender = 'F' THEN 'Female Age 26+'
END AS demographic_group,
SUM(gold) AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id
WHERE country_id IN
(SELECT id
FROM countries
WHERE region = 'WESTERN EUROPE')
GROUP BY demographic_group;

Filtering with a JOIN
SELECT
'Summer' AS season,
CASE WHEN age >= 13 AND age <= 25 AND gender = 'M' THEN 'Male Age 13-25'
WHEN age > 25 AND gender = 'M' THEN 'Male Age 26+'
WHEN age >= 13 AND age <= 25 AND gender = 'F' THEN 'Female Age 13-25'
WHEN age > 25 AND gender = 'F' THEN 'Female Age 26+'
END AS demographic_group,
SUM(gold) AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id
JOIN countries AS c
ON sg.country_id = c.id
WHERE region = 'WESTERN EUROPE'
GROUP BY demographic_group;

Remaining questions
ORDER BY?
LIMIT?
Gold Medals by Demographic Group
(Western European Countries Only)
+----------+--------------------+-------+
| season | demographic
_group | golds |
|----------+--------------------+-------|
| Winter | Male Age 26+ | 13 |
| Winter | Female Age 26+ | 8 |
| Summer | Male Age 13-25 | 7 |
| Summer | Female Age 13-25 | 6 |
| Winter | Male Age 13-25 | 4 |
| Summer | Male Age 26+ | 4 |
| Winter | Female Age 13-25 | 4 |
| Summer | Female Age 26+ | 2 |
+----------+--------------------+-------+

Final code
SELECT
'Summer' AS season,
CASE WHEN age >= 13 AND age <= 25 AND gender = 'M' THEN 'Male Age 13-25'
WHEN age > 25 AND gender = 'M' THEN 'Male Age 26+'
WHEN age >= 13 AND age <= 25 AND gender = 'F' THEN 'Female Age 13-25'
WHEN age > 25 AND gender = 'F' THEN 'Female Age 26+'
END AS demographic_group,
SUM(gold) AS golds
FROM summer_games AS sg
JOIN athletes AS a
ON sg.athlete_id = a.id
WHERE country_id IN
(SELECT id
FROM countries
WHERE region = 'WESTERN EUROPE')
GROUP BY demographic_group
UNION ALL
...
ORDER BY golds DESC;

Order of operations
Two JOINs
Add LOGIC
UNION
ORDER BY

Option B
SELECT
season,
CASE WHEN age >= 13 AND age <= 25 AND gender = 'M' THEN 'Male Age 13-25'
WHEN age > 25 AND gender = 'M' THEN 'Male Age 26+'
WHEN age >= 13 AND age <= 25 AND gender = 'F' THEN 'Female Age 13-25'
WHEN age > 25 AND gender = 'F' THEN 'Female Age 26+'
END AS demographic_group,
SUM(gold) as golds
FROM
(SELECT 'Summer' AS season, country_id, athlete_id, gold
FROM summer_games AS sg
UNION ALL
SELECT 'Winter' AS season, country_id, athlete_id, gold
FROM winter_games AS wg) AS g
JOIN athletes AS a
ON g.athlete_id = a.id
WHERE country_id IN
(SELECT id
FROM countries
WHERE region = 'WESTERN EUROPE')
GROUP BY season, demographic_group
ORDER BY golds DESC;

#---------------------------------------------------------------------

Filtering with a JOIN

When adding a filter to a query that requires you to reference a separate table, there are different approaches you can take. One option is to JOIN to the new table and then add a basic WHERE statement.

Your goal is to create a report with the following characteristics:

    First column is bronze_medals, or the total number of bronze.
    Second column is silver_medals, or the total number of silver.
    Third column is gold_medals, or the total number of gold.
    Only summer_games are included.
    Report is filtered to only include athletes age 16 or under.

In this exercise, use the JOIN approach.
Instructions
100 XP

    Create a query that pulls total bronze_medals, silver_medals, and gold_medals from summer_games.
    Use a JOIN and a WHERE statement to filter for athletes ages 16 and below.

-- Pull summer bronze_medals, silver_medals, and gold_medals
SELECT 
	SUM(bronze) AS bronze_medals, 
    SUM(silver) AS silver_medals, 
    SUM(gold) AS gold_medals
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id
-- Filter for athletes age 16 or below
WHERE age <= 16;

#---------------------------------------------------------------------

Filtering with a subquery

Another approach to filter from a separate table is to use a subquery. The process is as follows:

    Create a subquery that outputs a list.
    In your main query, add a WHERE statement that references the list.

Your goal is to create the same report as the last exercise, which contains the following characteristics:

    First column is bronze_medals, or the total number of bronze.
    Second column is silver_medals, or the total number of silver.
    Third column is gold_medals, or the total number of gold.
    Only summer_games are included.
    Report is filtered to only include athletes age 16 or under.

In this exercise, use the subquery approach.
Instructions
100 XP

    Create a query that pulls total bronze_medals, silver_medals, and gold_medals from summer_games.
    Setup a subquery that outputs all athletes age 16 or below.
    Add a WHERE statement that references the subquery to filter for athletes age 16 or below.

-- Pull summer bronze_medals, silver_medals, and gold_medals
SELECT 
	SUM(bronze) AS bronze_medals, 
    SUM(silver) AS silver_medals, 
    SUM(gold) AS gold_medals
FROM summer_games
-- Add the WHERE statement below
WHERE athlete_id IN
    -- Create subquery list for athlete_ids age 16 or below    
    (SELECT id
     FROM athletes
     WHERE age <= 16);

#---------------------------------------------------------------------

Report 2: Top athletes in nobel-prized countries

It's time to bring together all the concepts brought up in this chapter to expand on your dashboard! Your next report to build is Report 2: Athletes Representing Nobel-Prize Winning Countries.

Report Details:

    Column 1 should be event, which represents the Olympic event. Both summer and winter events should be included.
    Column 2 should be gender, which represents the gender of athletes in the event.
    Column 3 should be athletes, which represents the unique athletes in the event.
    Athletes from countries that have had no nobel_prize_winners should be excluded.
    The report should contain 10 events, where events with the most athletes show at the top.

Click to view the E:R Diagram.
Instructions 1/4
25 XP

    Select event from the summer_games table and create the athletes field by counting the distinct number of athlete_id.

step01

-- Pull event and unique athletes from summer_games 
SELECT 	
	event,
	COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY event;

step02

-- Pull event and unique athletes from summer_games 
SELECT 
	event, 
    -- Add the gender field below
    CASE WHEN event LIKE '%Women%' THEN 'female'
    ELSE 'male' END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
GROUP BY event;

step03

-- Pull event and unique athletes from summer_games 
SELECT 
    event,
    -- Add the gender field below
    CASE WHEN event LIKE '%Women%' THEN 'female' 
    ELSE 'male' END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
-- Only include countries that won a nobel prize
WHERE country_id IN 
	(SELECT country_id
    FROM country_stats
    WHERE nobel_prize_winners >= 1)
GROUP BY event;

step04

-- Pull event and unique athletes from summer_games 
SELECT 
    event,
    -- Add the gender field below
    CASE WHEN event LIKE '%Women%' THEN 'female' 
    ELSE 'male' END AS gender,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games
-- Only include countries that won a nobel prize
WHERE country_id IN 
	(SELECT country_id 
    FROM country_stats 
    WHERE nobel_prize_winners > 0)
GROUP BY event
-- Add the second query below and combine with a UNION
UNION
SELECT 
	event,
    CASE WHEN event LIKE '%Women%' THEN 'female'
	ELSE 'male' END AS gender,
	COUNT(DISTINCT athlete_id) AS athletes
FROM winter_games
WHERE country_id IN 
	(SELECT country_id
    FROM country_stats
    WHERE nobel_prize_winners > 0)
GROUP BY event
-- Order and limit the final output
ORDER BY athletes DESC
LIMIT 10;

######################################################################
######################################################################
######################################################################

######## Cleaning & Validation (Module 03-032)
######################################################################

Converting data
types

Interpreting errors
Type-Specific Function Error:
SELECT AVG(first_name)
FROM athletes;
ERROR: Function avg(character varying) does not exist
JOIN Error:
SELECT country, continent
FROM countries AS c1
JOIN continents AS c2
ON c1.continent_id = c2.id;
ERROR: Operator does not exist: integer = character varying

Solution: Wrap it in a CAST()
Syntax:
CAST(field AS type)
Examples:
CAST(birthday AS date)
CAST(country_id AS int)

CASTing for functions
SELECT DATE_PART('month'
,birthdate)
FROM birthdates;
ERROR: Can't run DATE_PART on string.
SELECT DATE_PART('month'
,
CAST(birthdate AS date))
FROM birthdates;
+-----+
| 04 |
| 05 |
+-----+

CASTing for JOINs
SELECT a.id, b.id
FROM table_a AS a
JOIN table_b AS b
ON a.id = b.id;
ERROR: Cannot join ON varchar = int.
SELECT a.id, b.id
FROM table_a AS a
JOIN table_b AS b
ON a.id = CAST(b.id AS varchar);
Query Ran Successfully!

Planning for data type issues
Fix as they come up
Read error messages!

Planning for data type issues
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'countries';
+--------------+--------------------+
| column_name | data_type |
|--------------|--------------------|
| id | integer |
| country | character varying |
| region | character varying |
+--------------+--------------------+

Data type documentation
https://www.postgresql.org/docs/9.5/datatype.html


#---------------------------------------------------------------------

Identifying data types

Being able to identify data types before setting up your query can help you plan for any potential issues. There is a group of tables, or a schema, called the information_schema, which provides a wide array of information about the database itself, including the structure of tables and columns.

The columns table houses useful details about the columns, including the data type.

Note that the information_schema is not the default schema SQL looks at when querying, which means you will need to explicitly tell SQL to pull from this schema. To pull a table from a non-default schema, use the syntax schema_name.table_name.
Instructions 1/2
50 XP

    Select the fields column_name and data_type from the table columns that resides within the information_schema schema.
    Filter only for the 'country_stats' table.

step01

-- Pull column_name & data_type from the columns table
SELECT 
	column_name,
    data_type
FROM information_schema.columns
-- Filter for the table 'country_stats'
WHERE table_name = 'country_stats';


#---------------------------------------------------------------------

Interpreting error messages

Inevitably, you will run into errors when running SQL queries. It is important to understand how to interpret these errors to correctly identify what type of error it is.

The console contains two separate queries, each which will output an error when ran. In this exercise, you will run each query, read the error message, and troubleshoot the error.
Instructions 1/2
50 XP

        Run the query in the console.
        After reading the error, fix it by converting the data type to float.
        Comment the first query and uncomment the second query.
        Run the code and fix errors by making the join columns int.

-- Run the query, then convert a data type to fix the error
SELECT AVG(CAST(pop_in_millions AS float)) AS avg_population
FROM country_stats;

step01

/*SELECT 
	s.country_id, 
    COUNT(DISTINCT s.athlete_id) AS summer_athletes, 
    COUNT(DISTINCT w.athlete_id) AS winter_athletes
FROM summer_games AS s
JOIN winter_games_str AS w
ON s.country_id = w.country_id
GROUP BY s.country_id;*/
/*
step02

-- Comment out the previous query
/*SELECT AVG(CAST(pop_in_millions AS float)) AS avg_population
FROM country_stats;*/

-- Uncomment the following block & run the query
/*
SELECT 
	s.country_id, 
    COUNT(DISTINCT s.athlete_id) AS summer_athletes, 
    COUNT(DISTINCT w.athlete_id) AS winter_athletes
FROM summer_games AS s
JOIN winter_games_str AS w
-- Fix the error by making both columns integers
ON CAST(s.country_id AS VARCHAR) = w.country_id
GROUP BY s.country_id;

#---------------------------------------------------------------------

Using date functions on strings

There are several useful functions that act specifically on date or datetime fields. For example:

    DATE_TRUNC('month', date) truncates each date to the first day of the month.
    DATE_PART('year', date) outputs the year, as an integer, of each date value.

In general, the arguments for both functions are ('period', field), where period is a date or time interval, such as 'minute', 'day', or 'decade'.

In this exercise, your goal is to test out these date functions on the country_stats table, specifically by outputting the decade of each year using two separate approaches. To run these functions, you will need to use CAST() function on the year field.
Instructions
100 XP
Instructions
100 XP

    Pulling from the country_stats table, select the decade using two methods: DATE_PART() and DATE_TRUNC.
    Convert the data type of the year field to fix errors.
    Sum up gdp to get world_gdp.
    Group and order by year (in descending order).

SELECT 
	year,
    -- Pull decade, decade_truncate, and the world's gdp
    DATE_PART('decade', CAST(year AS DATE)) AS decade,
    DATE_TRUNC('decade', CAST(year AS DATE)) AS decade_truncated,
    SUM(gdp) AS world_gdp
FROM country_stats
-- Group and order by year in descending order
GROUP BY year
ORDER BY year DESC;

#---------------------------------------------------------------------

Cleaning strings

Messy strings
+---------------------+
| country |
|---------------------|
| US |
| U.S. |
| US (United States) |
| us |
|      US |
+---------------------+

Replacing or removing characters
+------------+--------+
| country | points |
|------------|--------|
| US | 5 |
| U.S. | 3 |
+------------+--------+
SELECT REPLACE(country,'.','') AS country_
cleaned, SUM(points) as points
FROM original_table
GROUP BY country_cleaned;
+-----------------+--------+
| country_cleaned | points |
|-----------------|--------|
| US | 8 |
+-----------------+--------+

Parsing strings
+---------------------+--------+
| country | points |
|---------------------|--------|
| US | 5 |
| US (United States) | 1 |
+---------------------+--------+
SELECT LEFT(country,2) AS country_cleaned, SUM(points) as points
FROM original_table
GROUP BY country_cleaned;
+------------------+--------+
| country_
cleaned | points |
|------------------|--------|
| US | 6 |
+------------------+--------+

Changing case
+----------+--------+
| country | points |
|----------|--------|
| US | 5 |
| us | 4 |
+----------+--------+
SELECT UPPER(country) AS country_cleaned, SUM(points) as points
FROM original_table
GROUP BY country_cleaned;
+------------------+--------+
| country_cleaned | points |
|------------------|--------|
| US | 9 |
+------------------+--------+

Trimming extra spaces
+----------+--------+
| country | points |
|----------|--------|
| US | 5 |
| US | 2 |
+----------+--------+
SELECT TRIM(country) AS country_cleaned, SUM(points) as points
FROM original_table
GROUP BY country_cleaned;
+------------------+--------+
| country_cleaned | points |
|------------------|--------|
| US | 7 |
+------------------+--------+

Nesting functions
original
_
table
+---------------------+
| country |
|---------------------|
| US |
| U.S. |
| US (United States) |
| us |
| US |
+---------------------+
REPLACE(country,'.','')
TRIM(country)
LEFT(country,2)
UPPER(country)

Take it step-by-step
REPLACE(country,'.','')
TRIM(REPLACE(country,'.',''))
LEFT(TRIM(REPLACE(country,'.','')),2)
UPPER(LEFT(TRIM(REPLACE(country,'.','')),2))
Final Query:
SELECT UPPER(LEFT(TRIM(REPLACE(country,'.','')),2)) AS country_cleaned
FROM original_table
GROUP BY country_cleaned;

Order of nesting matters!
SELECT TRIM(REPLACE(UPPER(LEFT(country,2)),'.','')) AS country_cleaned
FROM original_table
GROUP BY country_cleaned;
+-------------------+
| country_cleaned |
|-------------------|
| US |
| U |
| |
+-------------------+

String function documentation
https://www.postgresql.org/docs/9.1/functions-string.html

#---------------------------------------------------------------------

String functions

There are a number of string functions that can be used to alter strings. A description of a few of these functions are shown below:

    The LOWER(fieldName) function changes the case of all characters in fieldName to lower case.
    The INITCAP(fieldName) function changes the case of all characters in fieldName to proper case.
    The LEFT(fieldName,N) function returns the left N characters of the string fieldName.
    The SUBSTRING(fieldName from S for N) returns N characters starting from position S of the string fieldName. Note that both from S and for N are optional.

step01

-- Convert country to lower case
SELECT 
	country, 
    LOWER(country) AS country_altered
FROM countries
GROUP BY country;

step02

-- Convert country to proper case
SELECT 
	country, 
    INITCAP(country) AS country_altered
FROM countries
GROUP BY country;

step03

-- Output the left 3 characters of country
SELECT 
	country, 
    LEFT(country,3) AS country_altered
FROM countries
GROUP BY country;

step04

-- Output all characters starting with position 7
SELECT 
	country, 
    SUBSTRING((country),7) AS country_altered
FROM countries
GROUP BY country;

#---------------------------------------------------------------------

Replacing and removing substrings

The REPLACE() function is a versatile function that allows you to replace or remove characters from a string. The syntax is as follows:

REPLACE(fieldName, 'searchFor', 'replaceWith')

Where fieldName is the field or string being updated, searchFor is the characters to be replaced, and replaceWith is the replacement substring.

In this exercise, you will look at one specific value in the countries table and change up the format by using a few REPLACE() functions.
Instructions 1/2
50 XP

    Create the field character_swap that replaces all '&' characters with 'and' from region.
    Create the field character_remove that removes all periods from region.

step01

SELECT 
	region, 
    -- Replace all '&' characters with the string 'and'
    REPLACE(region, '&', 'and') AS character_swap,
    -- Remove all periods
    REPLACE(region, '.', '') AS character_remove
FROM countries
WHERE region = 'LATIN AMER. & CARIB'
GROUP BY region;

step02

SELECT 
	region, 
    -- Replace all '&' characters with the string 'and'
    REPLACE(region,'&','and') AS character_swap,
    -- Remove all periods
    REPLACE(region,'.','') AS character_remove,
    -- Combine the functions to run both changes at once
    REPLACE(REPLACE(region,'.',''),'&','and') AS character_swap_and_remove
FROM countries
WHERE region = 'LATIN AMER. & CARIB'
GROUP BY region;

#---------------------------------------------------------------------

Fixing incorrect groupings

One issues with having strings stored in different formats is that you may incorrectly group data. If the same value is represented in multiple ways, your report will split the values into different rows, which can lead to inaccurate conclusions.

In this exercise, you will query from the summer_games_messy table, which is a messy, smaller version of summer_games. You'll notice that the same event is stored in multiple ways. Your job is to clean the event field to show the correct number of rows.
Instructions 1/3
35 XP

    Create a query that pulls the number of distinct athletes by event from the table summer_games_messy.
    Group by the non-aggregated field.

step01

-- Pull event and unique athletes from summer_games_messy 
SELECT 
	event, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games_messy
-- Group by the non-aggregated field
GROUP BY event;

step02

-- Pull event and unique athletes from summer_games_messy 
SELECT
    -- Remove trailing spaces and alias as event_fixed
	TRIM(event) AS event_fixed, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games_messy
-- Update the group by accordingly
GROUP BY event_fixed;

step03

-- Pull event and unique athletes from summer_games_messy 
SELECT 
    -- Remove dashes from all event values
    REPLACE(TRIM(event),'-','') AS event_fixed, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games_messy
-- Update the group by accordingly
GROUP BY event_fixed;

#---------------------------------------------------------------------

Dealing with nulls

What does null really mean?
+--------+-----------------+
| order | price_per_unit |
|--------|-----------------|
| 1 | 4.50 |
| 2 | 2.25 |
| 3 | null |
+--------+-----------------+
Yet to go through?
Free?
Flat price?

Issues with nulls
soccer_games
+---------+-------+-------+
| game_id | home | away |
|---------|-------|-------|
| 123 | 3 | 2 |
| 124 | 2 | null |
| 125 | null | 1 |
+---------+-------+-------+
SELECT *, home + away AS total_goals
FROM soccer_games;

Issues with nulls
+---------+-------+-------+--------------+
| game_id | home | away | total_goals |
|---------|-------|-------|--------------|
| 123 | 3 | 2 | 5 |
| 124 | 2 | null | null |
| 125 | null | 1 | null |
+---------+-------+-------+--------------+

Issues with nulls
SELECT
region,
COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games AS s
JOIN countries AS c
ON s.country_id = c.id
GROUP BY region;
+----------+-----------+
| region | athletes |
|----------|-----------|
| BALTICS | 42 |
| OCEANIA | 62 |
| null | 10 |
+----------+-----------+
Unclear what null represents!

Fix 1: Filtering nulls
original_table
+--------+-----------------+
| order | price_per_unit |
|--------|-----------------|
| 1 | 4.50 |
| 2 | 2.25 |
| 3 | null |
+--------+-----------------+
SELECT *
FROM original_table
WHERE price_per_unit IS NOT NULL;

Fix 1: Filtering nulls
+--------+-----------------+
| order | price_per_unit |
|--------|-----------------|
| 1 | 4.50 |
| 2 | 2.25 |
+--------+-----------------+

Fix 2: COALESCE()
Syntax: COALESCE(field, null_replacement)
SELECT
COALESCE(region,
'Independent Athletes') AS region,
COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games AS s
JOIN countries AS c
ON s.country_id = c.id;
%20-----------------------%20-----------%20
| region | athletes |
|-----------------------|-----------|
| BALTICS | 42 |
| OCEANIA | 62 |
| Independent Athletes | 10 |
%20-----------------------%20-----------%20

Fix 2: COALESCE()
soccer_games
+---------+-------+-------+
| game_id | home | away |
|---------|-------|-------|
| 123 | 3 | 2 |
| 124 | 2 | null |
| 125 | null | 1 |
+---------+-------+-------+
SELECT *, COALESCE(home,0) + COALESCE(away,0) AS total_goals
FROM soccer_games;

Fix 2: COALESCE()
+---------+-------+-------+--------------+
| game_id | home | away | total_goals |
|---------|-------|-------|--------------|
| 123 | 3 | 2 | 5 |
| 124 | 2 | null | 2 |
| 125 | null | 1 | 1 |
+---------+-------+-------+--------------+

Nulls as a result of a query
Causes:
LEFT JOIN does not match all rows
No CASE statement conditional is satisfied
Several others!

Measuring the impact of nulls
Ratio of rows that are null
SELECT SUM(CASE when country IS NULL then 1 else 0 end) / SUM(1.00)
FROM orders;
+-------+
| .12 |
+-------+
Ratio of revenue that is null
SELECT SUM(CASE when country IS NULL then revenue else 0 end) / SUM(revenue)
FROM orders;
+-------+
| .25 |
+-------+

#---------------------------------------------------------------------

Filtering out nulls

One way to deal with nulls is to simply filter them out. There are two important conditionals related to nulls:

    IS NULL is true for any value that is null.
    IS NOT NULL is true for any value that is not null. Note that a zero or a blank cell is not the same as a null.

These conditionals can be leveraged by several clauses, such as CASE statements, WHERE statements, and HAVING statements. In this exercise, you will learn how to filter out nulls using two separate techniques.

Feel free to reference the E:R Diagram.
Instructions 1/3
35 XP

    Setup a query that pulls country and total golds as gold_medals for all winter games.
    Group by the non-aggregated field and order by gold_medals in descending order.

step01

-- Show total gold_medals by country
SELECT 
	country,
    SUM(gold) AS gold_medals
FROM winter_games AS w
JOIN countries AS c
ON w.country_id = c.id
GROUP BY country
-- Order by gold_medals in descending order
ORDER BY gold_medals DESC;

step02

-- Show total gold_medals by country
SELECT 
	country, 
    SUM(gold) AS gold_medals
FROM winter_games AS w
JOIN countries AS c
ON w.country_id = c.id
-- Removes any row with no gold medals
WHERE gold IS NOT NULL
GROUP BY country
-- Order by gold_medals in descending order
ORDER BY gold_medals DESC;

step03

-- Show total gold_medals by country
SELECT 
	country, 
    SUM(gold) AS gold_medals
FROM winter_games AS w
JOIN countries AS c
ON w.country_id = c.id
-- Comment out the WHERE statement
/*WHERE gold IS NOT NULL*/
/*
GROUP BY country
-- Replace WHERE statement with equivalent HAVING statement
HAVING SUM(gold) IS NOT NULL
-- Order by gold_medals in descending order
ORDER BY gold_medals DESC;

#---------------------------------------------------------------------

Fixing calculations with coalesce

Null values impact aggregations in a number of ways. One issue is related to the AVG() function. By default, the AVG() function does not take into account any null values. However, there may be times when you want to include these null values in the calculation as zeros.

To replace null values with a string or a number, use the COALESCE() function. Syntax is COALESCE(fieldName,replacement), where replacement is what should replace all null instances of fieldName.

This exercise will walk you through why null values can throw off calculations and how to troubleshoot these issues.
Instructions 1/4
25 XP

    Build a report that shows total_events and gold_medals by athlete_id for all summer events, ordered by total_events descending then athlete_id ascending.

step01

-- Pull events and golds by athlete_id for summer events
SELECT 
    athlete_id,
    COUNT(event) AS total_events, 
    SUM(gold) AS gold_medals
FROM summer_games
GROUP BY athlete_id
-- Order by total_events descending and athlete_id ascending
ORDER BY total_events DESC, athlete_id ASC;

step02

-- Pull events and golds by athlete_id for summer events
SELECT 
    athlete_id, 
    -- Add a field that averages the existing gold field
    AVG(gold) AS avg_golds,
    COUNT(event) AS total_events, 
    SUM(gold) AS gold_medals
FROM summer_games
GROUP BY athlete_id
-- Order by total_events descending and athlete_id ascending
ORDER BY total_events DESC, athlete_id;

step03

-- Pull events and golds by athlete_id for summer events
SELECT 
    athlete_id, 
    -- Add a field that averages the existing gold field
    AVG(gold) AS avg_golds,
    COUNT(event) AS total_events, 
    SUM(gold) AS gold_medals
FROM summer_games
GROUP BY athlete_id
-- Order by total_events descending and athlete_id ascending
ORDER BY total_events DESC, athlete_id;

#---------------------------------------------------------------------

Report duplication

What causes duplication?
SELECT p.id, SUM(points) AS points, SUM(matches_win) AS matches_won
FROM points AS p
JOIN matches AS m ON p.id = m.id
GROUP BY p.id;

What causes duplication?
+-----+--------+--------------+
| id | points | matches_won |
|-----|--------|--------------|
| 1 | 156 | 10 |
+-----+--------+--------------+

What causes duplication?
Intermediate Table
+-----+------+--------------+---------+
| id | year | matches_won | points |
|-----|------|--------------|---------|
| 1 | 2016 | 5 | 52 |
| 1 | 2017 | 2 | 52 |
| 1 | 2018 | 3 | 52 |
+-----+------+--------------+---------+

What causes duplication?
Intermediate Table
+-----+------+--------------+---------+
| id | year | matches_won | points |
|-----|------|--------------|---------|
| 1 | 2016 | 5 | 52 |<--
| 1 | 2017 | 2 | 52 |<-- SUM(points) = 52 x 3 = 156
| 1 | 2018 | 3 | 52 |<--
+-----+------+--------------+---------+

Ways to fix duplication
1. Remove aggregations
SELECT p.id, points, SUM(matches_won) AS matches_won
FROM points AS p
JOIN matches AS m ON p.id = m.id
GROUP BY p.id, points;
+-----+--------+--------------+
| id | points | matches_won |
|-----|--------|--------------|
| 1 | 52 | 10 |
+-----+--------+--------------+

Ways to fix duplication
2. Add field to JOIN statement
SELECT p.id, SUM(points) AS points, SUM(matches_win) AS matches_won
FROM points AS p
JOIN matches AS m ON p.id = m.id AND p.year = m.year
GROUP BY p.id;

Ways to fix duplication
2. Add field to JOIN statement
SELECT p.id, SUM(points) AS points, SUM(matches_win) AS matches_won
FROM points AS p
JOIN matches AS m ON p.id = m.id AND p.year = m.year
GROUP BY p.id;

Ways to fix duplication
SELECT id, SUM(matches_won)
FROM matches
GROUP BY id;
+-----+--------------+
| id | matches_won |
|-----|--------------|
| 1 | 10 |
| 2 | 7 |
+-----+--------------+

Ways to fix duplication
3. Rollup using subquery
SELECT p.id, points, matches_won
FROM points AS p
JOIN
(SELECT id, SUM(matches_won) AS matches_won
FROM matches
GROUP BY id) AS m
ON p.id = m.id;

Ways to fix duplication
1. Remove aggregations
2. Add field to JOIN statement
3. Rollup using subquery

Identifying duplication
Value in original table:
SELECT SUM(points) AS total_points
FROM points;
total_points = 52
Value in query:
SELECT SUM(points) AS total_points
FROM
(SELECT p.id, SUM(points) AS points
FROM points AS p
JOIN matches AS m ON p.id = m.id
GROUP BY p.id) AS subquery;
total_points = 156

#---------------------------------------------------------------------

Identifying duplication

Duplication can happen for a number of reasons, often in unexpected ways. Because of this, it's important to get in the habit of validating your queries to ensure no duplication exists. To validate a query, take the following steps:

    Check the total value of a metric from the original table.
    Compare that with the total value of the same metric in your final report.

If the number from step 2 is larger than step 1, then duplication is likely the culprit. In this exercise, you will go through these steps to identify if duplication exists.
Instructions 1/3
35 XP

    Setup a query that pulls total gold_medals from the winter_games table.

step01

-- Pull total gold_medals for winter sports
SELECT SUM(gold) AS gold_medals
FROM winter_games;

step02

-- Comment out the query after noting the gold medal count
/*
SELECT SUM(gold) AS gold_medals
FROM winter_games;
-- TOTAL GOLD MEDALS: ____  
*/
-- Show gold_medals and avg_gdp by country_id
/*
SELECT 
	w.country_id, 
    SUM(gold) AS gold_medals, 
    AVG(gdp) AS avg_gdp
FROM winter_games AS w
JOIN country_stats AS c
-- Only join on the country_id fields
ON w.country_id = c.country_id
GROUP BY w.country_id;

step03

-- Comment out the query after noting the gold medal count
/*SELECT SUM(gold) AS gold_medals
FROM winter_games;*/
-- TOTAL GOLD MEDALS: 47 

-- Calculate the total gold_medals in your query
/*
SELECT SUM(gold_medals)
FROM
	(SELECT 
        w.country_id, 
     	SUM(gold) AS gold_medals, 
        AVG(gdp) AS avg_gdp
    FROM winter_games AS w
    JOIN country_stats AS c
    ON c.country_id = w.country_id
    -- Alias your query as subquery
    GROUP BY w.country_id) AS subquery;

#---------------------------------------------------------------------
Fixing duplication through a JOIN

In the previous exercise, you set up a query that contained duplication. This exercise will remove the duplication. One approach to removing duplication is to change the JOIN logic by adding another field to the ON statement.

The final query from last exercise is shown in the console. Your job is to fix the duplication by updating the ON statement. Note that the total gold_medals value should be 47.

Feel free to reference the E:R Diagram.
Instructions
100 XP

    Update the ON statement in the subquery by adding a second field to JOIN on.
    If an error occurs related to the new JOIN field, use a CAST() statement to fix it.

SELECT SUM(gold_medals) AS gold_medals
FROM
	(SELECT 
     	w.country_id, 
     	SUM(gold) AS gold_medals, 
     	AVG(gdp) AS avg_gdp
    FROM winter_games AS w
    JOIN country_stats AS c
    -- Update the subquery to join on a second field
    ON c.country_id = w.country_id AND CAST(c.year AS DATE) = CAST(w.year AS DATE)
    GROUP BY w.country_id) AS subquery;


#---------------------------------------------------------------------

Report 3: Countries with high medal rates

Great work so far! It is time to use the concepts you learned in this chapter to build the next base report for your dashboard.

Details for report 3: medals vs population rate.

    Column 1 should be country_code, which is an altered version of the country field.
    Column 2 should be pop_in_millions, representing the population of the country (in millions).
    Column 3 should be medals, representing the total number of medals.
    Column 4 should be medals_per_million, which equals medals / pop_in_millions

step01

SELECT 
	c.country,
    -- Add the three medal fields using one sum function
	SUM(COALESCE(CAST(bronze AS INT),0)) + SUM(COALESCE(CAST(silver AS INT),0)) + SUM(COALESCE(CAST(gold AS INT),0)) AS medals
FROM summer_games AS s
JOIN countries AS c
ON s.country_id = c.id
GROUP BY country
ORDER BY medals DESC;

step02

SELECT 
	c.country,
    -- Pull in pop_in_millions and medals_per_million 
    pop_in_millions,
    -- Add the three medal fields using one sum function
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) AS medals,
    SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) / CAST(pop_in_millions AS float) AS medals_per_million
FROM summer_games AS s
JOIN countries AS c
ON s.country_id = c.id
-- Add a join
JOIN country_stats AS cs
ON c.id = cs.country_id
GROUP BY c.country, pop_in_millions
ORDER BY medals DESC;

step03

SELECT 
	c.country,
    -- Pull in pop_in_millions and medals_per_million 
	pop_in_millions,
    -- Add the three medal fields using one sum function
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) AS medals,
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) / CAST(cs.pop_in_millions AS float) AS medals_per_million
FROM summer_games AS s
JOIN countries AS c 
ON s.country_id = c.id
-- Update the newest join statement to remove duplication
JOIN country_stats AS cs 
ON s.country_id = cs.country_id AND CAST(s.year AS DATE) = CAST(cs.year AS DATE)
GROUP BY c.country, pop_in_millions
ORDER BY medals DESC;

step04

SELECT 
	-- Clean the country field to only show country_code
    LEFT(REPLACE(UPPER(TRIM(c.country)),'.',''),3) AS country_code,
    -- Pull in pop_in_millions and medals_per_million 
	pop_in_millions,
    -- Add the three medal fields using one sum function
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) AS medals,
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) / CAST(cs.pop_in_millions AS float) AS medals_per_million
FROM summer_games AS s
JOIN countries AS c 
ON s.country_id = c.id
-- Update the newest join statement to remove duplication
JOIN country_stats AS cs 
ON s.country_id = cs.country_id AND s.year = CAST(cs.year AS date)
-- Filter out null populations
WHERE pop_in_millions IS NOT NULL
GROUP BY c.country, pop_in_millions
-- Keep only the top 25 medals_per_million rows
ORDER BY medals_per_million DESC
LIMIT 25;

######################################################################
######################################################################
######################################################################

######## Complex Calculations (Module 04-032)
######################################################################

Building complex
calculations

Approaches
1. Window functions
2. Layered calculations

Window functions
References other rows in the table.

Window function syntax
PARTITION BY = range of calculation
ORDER BY = order of rows when running calculation

Window function examples
Total bronze medals
SELECT
country_id,
athlete_id,
SUM(bronze) OVER () AS total_bronze
FROM summer_games;
+-------------+-------------+---------------+
| country_id | athlete_id | total_bronze |
|-------------|-------------|---------------|
| 11 | 77505 | 141 |
| 11 | 11673 | 141 |
| 14 | 85554 | 141 |
| 14 | 76433 | 141 |
+-------------+-------------+---------------+

Window function examples
Country bronze medals
SELECT
country_id,
athlete_id,
SUM(bronze) OVER (PARTITION BY country_id) AS total_bronze
FROM summer_games
+-------------+-------------+---------------+
| country_id | athlete_id | total_bronze |
|-------------|-------------|---------------|
| 11 | 77505 | 12 |
| 11 | 11673 | 12 |
| 14 | 85554 | 5 |
| 14 | 76433 | 5 |
+-------------+-------------+---------------+

Types of window functions
SUM()
AVG()
MIN()
MAX()

Types of window functions
LAG() and LEAD()

Types of window functions
ROW_NUMBER() and RANK()

Window function on an aggregation
original_table
+----------+-----------+---------+
| team_id | player_id | points |
|----------|-----------|---------|
| 1 | 4123 | 3 |
| 1 | 5231 | 6 |
| 2 | 8271 | 5 |
+----------+-----------+---------+
desired_report
+----------+-------------+---------------+
| team_id | team_points | league_points |
|----------|-------------|---------------|
| 1 | 9 | 43 |
| 2 | 12 | 43 |
| 3 | 22 | 43 |
+----------+-------------+---------------+

Window function on an aggregation
Final query
SELECT
team_id,
SUM(points) AS team_points,
SUM(SUM(points)) OVER () AS league_points
FROM original_table
GROUP BY team_id;

Window function on an aggregation
SELECT
team_id,
SUM(points) AS team_points,
SUM(points) OVER () AS league_points
FROM original_table
GROUP BY team_id;
ERROR: points must be an aggregation or appear in a GROUP BY statement.

Layered calculations
Aggregate an existing aggregation
Leverages a subquery

Layered calculations example
Step 1: Total bronze medals per country
SELECT country_id, SUM(bronze) as bronze_medals
FROM summer_games
GROUP BY country_id;
Step 2: Convert to subquery and take the max
SELECT MAX(bronze_medals)
FROM
(SELECT country_
id, SUM(bronze) as bronze_medals
FROM summer_games
GROUP BY country_id) AS subquery;

Planning out complex calculations
Ordering for window function?
Two aggregations with a layered calculation?

#---------------------------------------------------------------------

Testing out window functions

Window functions reference other rows within the report. There are a variety of window-specific functions to use, but all basic aggregation functions can be used as a window function. These include:

    SUM()
    AVG()
    MAX()
    MIN()

The syntax of a window function is FUNCTION(value) OVER (PARTITION BY field ORDER BY field). Note that the PARTITION BY and ORDER BY clauses are optional. The FUNCTION should be replaced with the function of your choice.

In this exercise, you will run a few different window functions on the country_stats table.
Instructions 1/4
25 XP

    Add the field country_avg_gdp that outputs the average gdp for each country.

step01

SELECT 
	country_id,
    year,
    gdp,
    -- Show the average gdp across all years per country
	AVG(gdp) OVER(PARTITION BY country_id) AS country_avg_gdp
FROM country_stats;

step02

SELECT 
	country_id,
    year,
    gdp,
    -- Show total gdp per country and alias accordingly
	SUM(gdp) OVER (PARTITION BY country_id) AS country_sum_gdp
FROM country_stats;

step03

SELECT 
	country_id,
    year,
    gdp,
    -- Show max gdp per country and alias accordingly
	MAX(gdp) OVER (PARTITION BY country_id) AS country_max_gdp
FROM country_stats;

step04

SELECT 
	country_id,
    year,
    gdp,
    -- Show max gdp for the table and alias accordingly
	MAX(gdp) OVER () AS global_max_gdp
FROM country_stats;

#---------------------------------------------------------------------

Average total country medals by region

Layered calculations are when you create a basic query with an aggregation, then reference that query as a subquery to run an additional calculation. This approach allows you to run aggregations on aggregations, such as a MAX() of a COUNT() or an AVG() of a SUM().

In this exercise, your task is to pull the average total_golds for all countries within each region. This report will apply only for summer events.

To avoid having to deal with null handling, we have created a summer_games_clean table. Please use this when building the report.
Instructions 1/2
50 XP

    Set up a query that pulls total_golds by region and country_id from the summer_games_clean and countries tables.
    GROUP BY the unaggregated fields.

step01

-- Query total_golds by region and country_id
SELECT 
	region, 
    country_id, 
    SUM(gold) AS total_golds
FROM summer_games_clean AS s
JOIN countries AS c
ON s.country_id = c.id
GROUP BY region, country_id;

step02

-- Pull in avg_total_golds by region
SELECT 
	region,
    AVG(total_golds) AS avg_total_golds
FROM  
  (SELECT 
      region, 
      country_id, 
      SUM(gold) AS total_golds
  FROM summer_games_clean AS s
  JOIN countries AS c
  ON s.country_id = c.id
  -- Alias the subquery
  GROUP BY region, country_id) AS subquery
GROUP BY region
-- Order by avg_total_golds in descending order
ORDER BY avg_total_golds DESC;

#---------------------------------------------------------------------

Most decorated athlete per region

Your goal for this exercise is to show the most decorated athlete per region. To set up this report, you need to leverage the ROW_NUMBER() window function, which numbers each row as an incremental integer, where the first row is 1, the second is 2, and so on.

Syntax for this window function is ROW_NUMBER() OVER (PARTITION BY field ORDER BY field). Notice how there is no argument within the initial function.

When set up correctly, a row_num = 1 represents the most decorated athlete within that region. Note that you cannot use a window calculation within a HAVING or WHERE statement, so you will need to use a subquery to filter.

Feel free to reference the E:R Diagram. We will use summer_games_clean to avoid null handling.

step01

SELECT 
	-- Query region, athlete_name, and total gold medals
	region, 
    name AS athlete_name, 
    SUM(gold) AS total_golds,
    -- Assign a regional rank to each athlete
    ROW_NUMBER() OVER (PARTITION BY region ORDER BY a.name) AS row_num
FROM summer_games_clean AS s
JOIN athletes AS a
ON s.athlete_id = a.id
JOIN countries AS c
ON s.country_id = c.id
GROUP BY region, a.name;

step02

-- Query region, athlete name, and total_golds
SELECT 
	region,
    athlete_name,
    total_golds
FROM
    (SELECT 
		-- Query region, athlete_name, and total gold medals
        region, 
        name AS athlete_name, 
        SUM(gold) AS total_golds,
        -- Assign a regional rank to each athlete
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(gold) DESC) AS row_num
    FROM summer_games_clean AS s
    JOIN athletes AS a
    ON a.id = s.athlete_id
    JOIN countries AS c
    ON s.country_id = c.id
    -- Alias as subquery
    GROUP BY region, athlete_name) AS subquery
-- Filter for only the top athlete per region
WHERE row_num = 1;

#---------------------------------------------------------------------

Comparing groups

Types of metrics
Volume metrics
Efficiency metrics

Volume metrics
Scale with size

Percent of total calculation
basketball_points table
+----------+------------+---------+
| team_id | player_id | points |
|----------|------------|---------|
| 1 | 482 | 92 |
| 1 | 165 | 47 |
| 2 | 222 | 64 |
+----------+------------+---------+
SELECT team_id, SUM(points) AS points
FROM basketball_points
GROUP BY team_id;

Percent of total calculation
basketball_points table
+----------+------------+---------+
| team_id | player_id | points |
|----------|------------|---------|
| 1 | 482 | 92 |
| 1 | 165 | 47 |
| 2 | 222 | 64 |
+----------+------------+---------+
+----------+---------+
| team_id | points |
|----------|---------|
| 1 | 782 |
| 2 | 625 |
| 3 | 487 |
| 4 | 398 |
+----------+---------+

Percent of total calculation
Step 1: Calculate total
SELECT
team_id,
SUM(points) AS points,
SUM(points) OVER () AS total_points
FROM basketball_points
GROUP BY team_id;
Step 2: Calculate percent of total
SELECT
team_id,
SUM(points) AS points
SUM(points) / SUM(points) OVER () AS perc_of_total
FROM basketball_points
GROUP BY team_id;

Percent of total calculation
Results:
%20----------%20---------%20---------------%20
| team_id | points | perc_of_total |
|----------|---------|---------------|
| 1 | 782 | .34 |
| 2 | 625 | .27 |
| 3 | 487 | .21 |
| 4 | 398 | .17 |
%20----------%20---------%20---------------%20

Percent of total calculation
Percent of points scored per player for each team:
SELECT
player_id,
team_id,
SUM(points) AS points
SUM(points) / (SUM(points) OVER (PARTITION BY team_id)) AS perc_of_team
FROM basketball_points
GROUP BY player_id, team_id;

Percent of total calculation
Results:
%20-----------%20---------%20---------%20--------------%20
| player_id | team_id | points | perc_of_team |
|-----------|---------|---------|--------------|
| 482 | 1 | 92 | .12 |
| 165 | 1 | 47 | .06 |
| 222 | 2 | 64 | .10 |
%20-----------%20---------%20---------%20--------------%20

Efficiency metrics
Does not scale with size
Typically a ratio

Performance index
Compares performance to a benchmark
Benchmark typically an average or median

Performance index
basketball_summary table
+----------+--------+---------+
| team_id | games | points |
|----------|--------|---------|
| 1 | 24 | 782 |
| 2 | 20 | 625 |
| 3 | 12 | 487 |
+----------+--------+---------+
Points per game performance?

Performance index
Step 1: points per game for each team
SELECT
team_id,
points/games AS team_ppg
FROM basketball_summary;
Step 2: points per game for entire league
SELECT
team_id,
points/games AS team_ppg,
SUM(points) OVER () / SUM(games) OVER () AS league_ppg
FROM basketball_summary;

Performance index
Step 3: performance index
SELECT
team_id,
points/games AS team_ppg,
SUM(points) OVER () / SUM(games) OVER () AS league_ppg,
(points/games)
/
(SUM(points) OVER () / SUM(games) OVER ()) AS perf_index
FROM basketball_summary;

Performance index
Step 3: performance index
+----------+----------+------------+-------------+
| team_id | team_ppg | league_ppg | perf_index |
|----------|----------|------------|-------------|
| 1 | 32.6 | 33.8 | 0.96 |
| 2 | 31.3 | 33.8 | 0.92 |
| 3 | 40.6 | 33.8 | 1.20 |
+----------+----------+------------+-------------+

#---------------------------------------------------------------------

Percent of gdp per country

A percent of total calculation is a good way to compare volume metrics across groups. While simply showing the volume metric in a report provides some insights, adding a ratio allows us to easily compare values quickly.

To run a percent of total calculation, take the following steps:443376xjuuuuuuuuuuuuuuuuuuuuuuuuuuk9QE

    Create a window function that outputs the total volume, partitioned by whatever is considered the total. If the entire table is considered the total, then no partition clause is needed.
    Run a ratio that divides each row's volume metric by the total volume in the partition.

In this exercise, you will calculate the percent of gdp for each country relative to the entire world and relative to that country's region.

step01

-- Pull country_gdp by region and country
SELECT 
	country,
    region,
	SUM(gdp) AS country_gdp
FROM country_stats AS cs
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;

step02

-- Pull country_gdp by region and country
SELECT 
	region,
    country,
	SUM(gdp) AS country_gdp,
    -- Calculate the global gdp
    SUM(SUM(gdp)) OVER () AS global_gdp
FROM country_stats AS cs
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;

step03
-- Pull country_gdp by region and country
SELECT 
	region,
    country,
	SUM(gdp) AS country_gdp,
    -- Calculate the global gdp
    SUM(SUM(gdp)) OVER () AS global_gdp,
    -- Calculate percent of global gdp
    SUM(gdp) / (SUM(SUM(gdp)) OVER ()) AS perc_global_gdp
FROM country_stats AS cs
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;

step04

-- Pull country_gdp by region and country
SELECT 
	region,
    country,
	SUM(gdp) AS country_gdp,
    -- Calculate the global gdp
    SUM(SUM(gdp)) OVER () AS global_gdp,
    -- Calculate percent of global gdp
    SUM(gdp) / SUM(SUM(gdp)) OVER () AS perc_global_gdp,
    -- Calculate percent of gdp relative to its region
    SUM(gdp) / SUM(SUM(gdp)) OVER (PARTITION BY region) AS perc_region_gdp
FROM country_stats AS cs
JOIN countries AS c
ON cs.country_id = c.id
-- Filter out null gdp values
WHERE gdp IS NOT NULL
GROUP BY region, country
-- Show the highest country_gdp at the top
ORDER BY country_gdp DESC;

#---------------------------------------------------------------------

GDP per capita performance index

A performance index calculation is a good way to compare efficiency metrics across groups. A performance index compares each row to a benchmark.

To run a performance index calculation, take the following steps:

    Create a window function that outputs the performance for the entire partition.
    Run a ratio that divides each row's performance to the performance of the entire partition.

In this exercise, you will calculate the gdp_per_million for each country relative to the entire world.

    gdp_per_million = gdp / pop_in_millions

You will reference the country_stats_cleaned table, which is a copy of country_stats without data type issues.

step01

-- Bring in region, country, and gdp_per_million
SELECT 
    region,
    country,
    gdp/pop_in_millions AS gdp_per_million
-- Pull from country_stats_clean
FROM country_stats_clean AS cs
JOIN countries AS c
ON cs.country_id = c.id
-- Filter for 2016 and remove null gdp values
WHERE gdp IS NOT NULL AND year = '2016-01-01'
GROUP BY region, country, gdp, pop_in_millions
-- Show highest gdp_per_million at the top
ORDER BY gdp_per_million DESC;

step02

-- Bring in region, country, and gdp_per_million
SELECT 
    region,
    country,
    SUM(gdp) / SUM(pop_in_millions) AS gdp_per_million,
    -- Output the worlds gdp_per_million
    SUM(gdp) OVER () / SUM(pop_in_millions) OVER () AS gdp_per_million_total
-- Pull from country_stats_clean
FROM country_stats_clean AS cs
JOIN countries AS c 
ON cs.country_id = c.id
-- Filter for 2016 and remove null gdp values
WHERE year = '2016-01-01' AND gdp IS NOT NULL
GROUP BY region, country, gdp, pop_in_millions
-- Show highest gdp_per_million at the top
ORDER BY gdp_per_million DESC;

step03

-- Bring in region, country, and gdp_per_million
SELECT 
    region,
    country,
    SUM(gdp) / SUM(pop_in_millions) AS gdp_per_million,
    -- Output the worlds gdp_per_million
    SUM(SUM(gdp)) OVER () / SUM(SUM(pop_in_millions)) OVER () AS gdp_per_million_total,
    -- Build the performance_index in the 3 lines below
    (SUM(gdp) / SUM(pop_in_millions))
    /
    (SUM(SUM(gdp)) OVER () / SUM(SUM(pop_in_millions)) OVER ()) AS performance_index
-- Pull from country_stats_clean
FROM country_stats_clean AS cs
JOIN countries AS c 
ON cs.country_id = c.id
-- Filter for 2016 and remove null gdp values
WHERE year = '2016-01-01' AND gdp IS NOT NULL
GROUP BY region, country
-- Show highest gdp_per_million at the top
ORDER BY gdp_per_million DESC;

#---------------------------------------------------------------------
Comparing dates

Questions to answer
1. Last month vs previous month?
2. Rolling 7 days?
original_table
+------------+----------+
| date | revenue |
|------------+----------+
| 2018-01-01 | 400 |
| 2018-01-02 | 380 |
| 2018-01-03 | 625 |
+------------+----------+

Month-over-month comparison
LAG(value, offset) outputs a value from an offset number of rows previous to the
current row.
LEAD(value, offset) outputs a value from an offset number of rows after the current
row.

Month-over-month comparison
Step 1: show revenue by month
SELECT
DATE_PART('month',date) AS month,
SUM(revenue) as current_rev
FROM original_table
GROUP BY month;

Step 2: previous month's revenue
SELECT
DATE_PART('month',date) AS month,
SUM(revenue) as current_rev,
LAG(SUM(revenue)) OVER (ORDER BY DATE_PART('month',date)) AS prev_rev
FROM original_table
GROUP BY month;

Month-over-month comparison
Step 3: percent change calculation
SELECT
DATE_PART('month',date) AS month,
SUM(revenue) as current_rev,
LAG(SUM(revenue)) OVER (ORDER BY DATE_PART('month',date)) AS prev_rev,
SUM(revenue)
/
LAG(SUM(revenue)) OVER (ORDER BY DATE_PART('month',date))-1 AS perc_change
FROM original_table
GROUP BY month;

Month-over-month comparison
Step 3: percent change calculation
+--------+--------------+-----------+--------------+
| month | current_rev | prev_rev | perc_change |
|--------+--------------+-----------+--------------|
| 01 | 15000 | null | null |
| 02 | 14000 | 15000 | -.06 |
| 03 | 21000 | 14000 | .50 |
+--------+--------------+-----------+--------------+

Rolling calculations
Only take into account 7 rows
New clause: ROWS BETWEEN
SUM(value) OVER (ORDER BY value ROWS BETWEEN N PRECEDING AND CURRENT ROW)

Rolling calculations
Rolling sum query
SELECT
date,
SUM(SUM(revenue)) OVER
(ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_revenue
FROM original_table
GROUP BY date;

New table: web_data
web_data
+------------+-------------+--------+
| date | country_id | view |
|------------+-------------+--------|
| 2018-01-01 | 1 | 24313 |
| 2018-01-01 | 2 | 3768 |
| 2018-01-01 | 3 | 26817 |
+------------+-------------+--------+

#---------------------------------------------------------------------

Month-over-month comparison

In order to compare months, you need to use one of the following window functions:

    LAG(value, offset), which outputs a value from an offset number previous to to the current row in the report.
    LEAD(value, offset), which outputs a value from a offset number after the current row in the report.

Your goal is to build a report that shows each country's month-over-month views. A few tips:

    You will need to bucket dates into months. To do this, you can use the DATE_PART() function.
    You can calculate the percent change using the following formula: (value)/(previous_value) - 1.
    If no offset value is included in the LAG() or LEAD() functions, it will default to 1.

Since the table stops in the middle of June, the query is set up to only include data to the end of May.

Instructions
100 XP

    From web_data, pull in country_id and use a DATE_PART() function to create month.
    Create month_views that pulls the total views within the month.
    Create previous_month_views that pulls the total views from last month for the given country.
    Create the field perc_change that calculates the percent change of this month relative to last month for the given country, where a negative value represents a loss in views and a positive value represents growth.

SELECT
	-- Pull month and country_id
	DATE_PART('month', date) AS month,
	country_id,
    -- Pull in current month views
    SUM(views) AS month_views,
    -- Pull in last month views
    LAG(SUM(views)) OVER (PARTITION BY country_id ORDER BY DATE_PART('month',date)) AS previous_month_views,
    -- Calculate the percent change
    SUM(views)
/
LAG(SUM(views)) OVER (PARTITION BY country_id ORDER BY DATE_PART('month',date))-1 AS perc_change
FROM web_data
WHERE date <= '2018-05-31'
GROUP BY country_id, month;

#---------------------------------------------------------------------

Week-over-week comparison

In the previous exercise, you leveraged the set window of a month to calculate month-over-month changes. But sometimes, you may want to calculate a different time period, such as comparing last 7 days to the previous 7 days. To calculate a value from the last 7 days, you will need to set up a rolling calculation.

In this exercise, you will take the rolling 7 day average of views for each date and compare it to the previous 7 day average for views. This gives a clear week-over-week comparison for every single day.

Syntax for a rolling average is AVG(value) OVER (PARTITION BY field ORDER BY field ROWS BETWEEN N PRECEDING AND CURRENT ROW), where N is the number of rows to look back when doing the calculation. Remember that CURRENT ROW counts as a row.

step01

SELECT
	-- Pull in date and daily_views
	date,
	SUM(views) AS daily_views,
    -- Calculate the rolling 7 day average
	AVG(SUM(views)) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg
FROM web_data
GROUP BY date;

step02

SELECT 
	-- Pull in date and weekly_avg
	date,
    weekly_avg,
    -- Output the value of weekly_avg from 7 days prior
    LAG(weekly_avg,7) OVER (ORDER BY date) AS weekly_avg_previous
FROM
  (SELECT
      -- Pull in date and daily_views
      date,
      SUM(views) AS daily_views,
      -- Calculate the rolling 7 day average
      AVG(SUM(views)) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg
  FROM web_data
  -- Alias as subquery
  GROUP BY date) AS subquery
-- Order by date in descending order
ORDER BY date DESC;

step03

SELECT 
	-- Pull in date and weekly_avg
	date,
    weekly_avg,
    -- Output the value of weekly_avg from 7 days prior
    LAG(weekly_avg,7) OVER (ORDER BY date) AS weekly_avg_previous,
    -- Calculate percent change vs previous period
    weekly_avg
/
LAG(weekly_avg,7) OVER (ORDER BY date)-1 AS perc_change
FROM
  (SELECT
      -- Pull in date and daily_views
      date,
      SUM(views) AS daily_views,
      -- Calculate the rolling 7 day average
      AVG(SUM(views)) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg
  FROM web_data
  -- Alias as subquery
  GROUP BY date) AS subquery
-- Order by date in descending order
ORDER BY date DESC;

#---------------------------------------------------------------------
Report 4: Tallest athletes and % GDP by region

The final report on the dashboard is Report 4: Avg Tallest Athlete and % of world GDP by Region.

Report Details:

    Column 1 should be region found in the countries table.
    Column 2 should be avg_tallest, which averages the tallest athlete from each country within the region.
    Column 3 should be perc_world_gdp, which represents what % of the world's GDP is attributed to the region.
    Only winter_games should be included (no summer events).

step01

SELECT 
	-- Pull in country_id and height
	country_id,
    height,
    -- Number the height of each country's athletes
    ROW_NUMBER() OVER(PARTITION BY country_id ORDER BY country_id) AS row_num
FROM winter_games AS w
JOIN athletes AS a
ON w.athlete_id = a.id
GROUP BY country_id, height
-- Order by country_id and then height in descending order
ORDER BY country_id, height DESC;

step02

SELECT
	-- Pull in region and calculate avg tallest height
	region,
    AVG(height) AS avg_tallest
FROM countries AS c
JOIN
    (SELECT 
   	    -- Pull in country_id and height
        country_id, 
        height, 
        -- Number the height of each country's athletes
        ROW_NUMBER() OVER (PARTITION BY country_id ORDER BY height DESC) AS row_num
    FROM winter_games AS w 
    JOIN athletes AS a 
    ON w.athlete_id = a.id
    GROUP BY country_id, height
    -- Alias as subquery
    ORDER BY country_id, height DESC) AS subquery
ON c.id = subquery.country_id
-- Only include the tallest height for each country
WHERE row_num = 1
GROUP BY region;

step03

SELECT
	-- Pull in region and calculate avg tallest height
    region,
    AVG(height) AS avg_tallest,
    -- Calculate region's percent of world gdp
    (SUM(SUM(gdp)) OVER (PARTITION BY region) / SUM(SUM(gdp)) OVER ())  AS perc_world_gdp    
FROM countries AS c
JOIN
    (SELECT 
     	-- Pull in country_id and height
        country_id, 
        height, 
        -- Number the height of each country's athletes
        ROW_NUMBER() OVER (PARTITION BY country_id ORDER BY height DESC) AS row_num
    FROM winter_games AS w 
    JOIN athletes AS a ON w.athlete_id = a.id
    GROUP BY country_id, height
    -- Alias as subquery
    ORDER BY country_id, height DESC) AS subquery
ON c.id = subquery.country_id
-- Join to country_stats
JOIN country_stats AS cs
ON cs.country_id = subquery.country_id
-- Only include the tallest height for each country
WHERE row_num = 1
GROUP BY region;

#---------------------------------------------------------------------
#---------------------------------------------------------------------

You’ve completed
SQL for Business Analysts

END