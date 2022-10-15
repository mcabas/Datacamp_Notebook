/*

######################################################################
######################################################################
######################################################################

# COURSE 026_Exploratory_Data_Analysis_in_SQL

######################################################################
######################################################################
######################################################################

######## What's in the database? (Module 01-026)
######################################################################

***Select a few rows
SELECT *
FROM company
LIMIT 5;

***A few reminders
A few reminders
Code                                Note
NULL                                missing
IS NULL , IS NOT NULL               don't use = NULL
count(*)                            number of rows
count(column_name)                  number of non- NULL values
count(DISTINCT column_name)         number of different non- NULL values
SELECT DISTINCT column_name ...     distinct values, including NULL

#---------------------------------------------------------------------

Explore table sizes
Let's start by exploring five related tables:

stackoverflow: questions asked on Stack Overflow with certain tags
company: information on companies related to tags in stackoverflow
tag_company: links stackoverflow to company
tag_type: type categories applied to tags in stackoverflow
fortune500: information on top US companies
Count the number of rows in a table with

SELECT count(*) 
  FROM tablename;
Count the number of columns in a table by selecting a few rows and manually counting the columns in the result.

Which table has the most rows? Which table has the most columns?

#---------------------------------------------------------------------
Count missing values
Which column of fortune500 has the most missing values? To find out, you'll need to check each column individually, although here we'll check just three.

Course Note: While you're unlikely to encounter this issue during this exercise, note that if you run a query that takes more than a few seconds to execute, your session may expire or you may be disconnected from the server. You will not have this issue with any of the exercise solutions, so if your session expires or disconnects, there's an error with your query.

step01
-- Select the count of the number of rows
SELECT COUNT(*)
  FROM fortune500;

step02
-- Select the count of ticker, 
-- subtract from the total number of rows, 
-- and alias as missing
SELECT count(*) - COUNT(ticker) AS missing
  FROM fortune500;

R:32 

step03
-- Select the count of profits_change, 
-- subtract from total number of rows, and alias as missing
SELECT count(*) - COUNT(profits_change) AS missing
  FROM fortune500;

R: 63

step04
-- Select the count of industry, 
-- subtract from total number of rows, and alias as missing
-- Select the count of profits_change, 
-- subtract from total number of rows, and alias as missing
SELECT count(*) - COUNT(industry) AS missing
  FROM fortune500;

R:13

#---------------------------------------------------------------------
Join tables
Part of exploring a database is figuring out how tables relate to each other. The company and fortune500 tables don't have a formal relationship between them in the database, but this doesn't prevent you from joining them.

To join the tables, you need to find a column that they have in common where the values are consistent across the tables. Remember: just because two tables have a column with the same name, it doesn't mean those columns necessarily contain compatible data. If you find more than one pair of columns with similar data, you may need to try joining with each in turn to see if you get the same number of results.

Reference the entity relationship diagram if needed.

SELECT company.name
-- Table(s) to select from
  FROM company
       INNER JOIN fortune500
       ON company.ticker = fortune500.ticker;
       
#---------------------------------------------------------------------
video
The keys to the
database

Foreign keys

Foreign keys
Reference another row
In a different table or the same table
Via a unique ID
>> Primary key column containing unique, non-NULL values
Values restricted to values in referenced column OR NULL

***Coalesce function
coalesce(value_1, value_2 [, ...])
Operates row by row
Returns 

SELECT coalesce(column_1, column_2)
FROM prices;

#---------------------------------------------------------------------
Foreign keys
Recall that foreign keys reference another row in the database via a unique ID. Values in a foreign key column are restricted to values in the referenced column OR NULL.

Using what you know about foreign keys, why can't the tag column in the tag_type table be a foreign key that references the tag column in the stackoverflow table?

Remember, you can reference the slides using the icon in the upper right of the screen to review the requirements for a foreign key.

stackoverflow doesn't have unique values
it has to reference an identify unique values

#---------------------------------------------------------------------
Read an entity relationship diagram
The information you need is sometimes split across multiple tables in the database.

What is the most common stackoverflow tag_type? What companies have a tag of that type?

To generate a list of such companies, you'll need to join three tables together.

Reference the entity relationship diagram as needed when determining which columns to use when joining tables.

step01
-- Count the number of tags with each type
SELECT type, COUNT(*) AS count
  FROM tag_type
 -- To get the count for each type, what do you need to do?
 GROUP BY type
 -- Order the results with the most common
 -- tag types listed first
 ORDER BY type ASC;

 STEP02
-- Select the 3 columns desired
SELECT company.name, tag_type.tag, tag_type.type
  FROM company
  	   -- Join to the tag_company table
       INNER JOIN tag_company 
       ON company.id = tag_company.company_id
       -- Join to the tag_type table
       INNER JOIN tag_type
       ON tag_company.tag = tag_type.tag
  -- Filter to most common type
  WHERE type='cloud';

#---------------------------------------------------------------------
Coalesce
The coalesce() function can be useful for specifying a default or backup value when a column contains NULL values.

coalesce() checks arguments in order and returns the first non-NULL value, if one exists.

coalesce(NULL, 1, 2) = 1
coalesce(NULL, NULL) = NULL
coalesce(2, 3, NULL) = 2
In the fortune500 data, industry contains some missing values. Use coalesce() to use the value of sector as the industry when industry is NULL. Then find the most common industry.

-- Use coalesce
SELECT coalesce(industry, sector, 'Unknown') AS industry2,
       -- Don't forget to count!
       COUNT(*) 
  FROM fortune500 
-- Group by what? (What are you counting by?)
 GROUP BY industry2
-- Order results to see most common first
 ORDER BY COUNT DESC
-- Limit results to get just the one value you want
 LIMIT 1;

#---------------------------------------------------------------------
Coalesce with a self-join
You previously joined the company and fortune500 tables to find out which companies are in both tables. Now, also include companies from company that are subsidiaries of Fortune 500 companies as well.

To include subsidiaries, you will need to join company to itself to associate a subsidiary with its parent company's information. To do this self-join, use two different aliases for company.

coalesce will help you combine the two ticker columns in the result of the self-join to join to fortune500.

SELECT company_original.name, title, rank
  -- Start with original company information
  FROM company AS company_original
       -- Join to another copy of company with parent
       -- company information
	   LEFT JOIN company AS company_parent
       ON company_original.parent_id = company_parent.id 
       -- Join to fortune500, only keep rows that match
       INNER JOIN fortune500 
       -- Use parent ticker if there is one, 
       -- otherwise original ticker
       ON coalesce(company_parent.ticker, 
                   company_original.ticker) = 
             fortune500.ticker
 -- For clarity, order by rank
 ORDER BY rank; 

#---------------------------------------------------------------------
video
Column Types and
Constraints

Column constraints
  Foreign key: value that exists in the referenced column, or NULL
  Primary key: unique, not NULL
  Unique: values must all be different except for NULL
  Not null: NULL not allowed: must have a value
  Check constraints: conditions on the values
    column1 > 0
    columnA > columnB

Data types
  Common
    Numeric
    Character
    Date/Time
    Boolean
  Special
    Arrays
    Monetary
    Binary
    Geometric
    Network Address
    XML
    JSON
    and more!

Numeric types: PostgreSQL documentation
smallint,integer,bigint...etc

***Casting with CAST()
  Format
-- With the CAST function
SELECT CAST (value AS new_type);
  Examples
-- Cast 3.7 as an integer
SELECT CAST (3.7 AS integer);
4
-- Cast a column called total as an integer
SELECT CAST (total AS integer)
FROM prices;

***Casting with ::
  Format
-- With :: notation
SELECT value::new_type;
  Examples
-- Cast 3.7 as an integer
SELECT 3.7::integer;
-- Cast a column called total as an integer
SELECT total::integer
FROM prices;

#---------------------------------------------------------------------
Effects of casting
When you cast data from one type to another, information can be lost or changed. See how the casting changes values and practice casting data using the CAST() function and the :: syntax.

SELECT CAST(value AS new_type);

SELECT value::new_type;

step01
-- Select the original value
SELECT profits_change, 
	   -- Cast profits_change
       CAST(profits_change AS integer) AS profits_change_int
  FROM fortune500;

step02
-- Divide 10 by 3
SELECT 10/3, 
       -- Cast 10 as numeric and divide by 3
       10::numeric/3;

step3
SELECT '3.2'::numeric,
       '-123'::numeric,
       '1e3'::numeric,
       '1e-3'::numeric,
       '02314'::numeric,
       '0002'::numeric;

#---------------------------------------------------------------------
Summarize the distribution of numeric values
Was 2017 a good or bad year for revenue of Fortune 500 companies? Examine how revenue changed from 2016 to 2017 by first looking at the distribution of revenues_change and then counting companies whose revenue increased.

step01
-- Select the count of each value of revenues_change
SELECT revenues_change, COUNT(*)
  FROM fortune500
 GROUP BY revenues_change
 -- order by the values of revenues_change
 ORDER BY revenues_change;

 step02
 -- Select the count of each revenues_change integer value
SELECT revenues_change::integer, COUNT(*)
  FROM fortune500
 GROUP BY revenues_change::integer
 -- order by the values of revenues_change
 ORDER BY revenues_change;

 step03
 -- Count rows 
SELECT COUNT(*)
  FROM fortune500
 -- Where...
 WHERE revenues_change > 0;

######################################################################
######################################################################
######################################################################

######## Summarizing and aggregating numeric data (Module 02-026)
######################################################################

video
Numeric Data Types
and Summary
Functions

Numeric types: integer
Name                            Storage Size      Description            Range
integer or int or int4          4 bytes           typical choice        -2147483648 to +2147483647
smallint or int2                2 bytes           small-range           -32768 to +32767
bigint or int8                  8 bytes           large-range           -9223372036854775808 to +9223372036854775807
serial                          4 bytes           auto-increment         1 to 2147483647
smallserial                     2 bytes           small autoincrement    1 to 32767

Numeric types: decimal
Name                            Storage Size      Description                          Range
decimal or numeric              variable          user-specified precision, exact      up to 131072 digits before the decimal point; up to 16383 digits after the decimal point
real                            4 bytes           variableprecision, inexact           6 decimal digits precision
double precision                8 bytes           variableprecision, inexact           15 decimal digits precision

***Division
-- integer division
SELECT 10/4;
2
-- numeric division
SELECT 10/4.0;
2.500000000

***Range: min and max
SELECT min(question_pct)
FROM stackoverflow;
min
-----
0
(1 row)
SELECT max(question_pct)
FROM stackoverflow;
max
-------------
0.071957428
(1 row)

***Average or mean
SELECT avg(question_pct)
FROM stackoverflow;
avg
---------------------
0.00379494620059319
(1 row)

***Variance
Population Variance
SELECT var_pop(question_pct)
FROM stackoverflow;
var_pop
----------------------
0.000140268640974167
(1 row)
Sample Variance
SELECT var_samp(question_pct)
FROM stackoverflow;
var_samp
----------------------
0.000140271571051059
(1 row)
SELECT variance(question_pct)
FROM stackoverflow;
variance
----------------------
0.000140271571051059
(1 row)

***Standard deviation
Sample Standard Deviation
SELECT stddev_samp(question_pct)
FROM stackoverflow;
stddev_samp
--------------------
0.0118436299778007
(1 row)
SELECT stddev(question_pct)
FROM stackoverflow;
stddev
--------------------
0.0118436299778007
(1 row)
Population Standard Deviation
SELECT stddev_pop(question_pct)
FROM stackoverflow;
stddev_pop
--------------------
0.0118435062787237
(1 row)

***Round
SELECT round(42.1256, 2);
42.13

***Summarize by group
-- Summarize by group with GROUP BY
SELECT tag,
min(question_pct),
avg(question_pct),
max(question_pct)
FROM stackoverflow
GROUP BY tag;

#---------------------------------------------------------------------
Division
Compute the average revenue per employee for Fortune 500 companies by sector.

-- Select average revenue per employee by sector
SELECT sector, 
       avg(revenues/employees::numeric ) AS avg_rev_employee
  FROM fortune500
 GROUP BY sector
 -- Use the column alias to order the results
 ORDER BY avg_rev_employee;

#---------------------------------------------------------------------
Explore with division
In exploring a new database, it can be unclear what the data means and how columns are related to each other.

What information does the unanswered_pct column in the stackoverflow table contain? Is it the percent of questions with the tag that are unanswered (unanswered ?s with tag/all ?s with tag)? Or is it something else, such as the percent of all unanswered questions on the site with the tag (unanswered ?s with tag/all unanswered ?s)?

Divide unanswered_count (unanswered ?s with tag) by question_count (all ?s with tag) to see if the value matches that of unanswered_pct to determine the answer.

-- Divide unanswered_count by question_count
SELECT unanswered_count/question_count::numeric AS computed_pct, 
       -- What are you comparing the above quantity to?
       unanswered_pct
  FROM stackoverflow
 -- Select rows where question_count is not 0
 WHERE question_count != 0
 LIMIT 10;

#---------------------------------------------------------------------
Summarize numeric columns
Summarize the profit column in the fortune500 table using the functions you've learned.

You can access the course slides for reference using the PDF icon in the upper right corner of the screen.

step01
-- Select min, avg, max, and stddev of fortune500 profits
SELECT min(profits),
       avg(profits),
       max(profits),
       stddev(profits)
  FROM fortune500;

step02
-- Select sector and summary measures of fortune500 profits
SELECT sector,
       min(profits),
       avg(profits),
       max(profits),
       stddev(profits)
  FROM fortune500
 -- What to group by?
 GROUP BY sector
 -- Order by the average profits
 ORDER BY avg;

#---------------------------------------------------------------------
Summarize group statistics
Sometimes you want to understand how a value varies across groups. For example, how does the maximum value per group vary across groups?

To find out, first summarize by group, and then compute summary statistics of the group results. One way to do this is to compute group values in a subquery, and then summarize the results of the subquery.

For this exercise, what is the standard deviation across tags in the maximum number of Stack Overflow questions per day? What about the mean, min, and max of the maximums as well?

-- Compute standard deviation of maximum values
SELECT stddev(maxval),
	   -- min
       min(maxval),
       -- max
       max(maxval),
       -- avg
       avg(maxval)
  -- Subquery to compute max of question_count by tag
  FROM (SELECT max(question_count) AS maxval
          FROM stackoverflow
         -- Compute max by...
         GROUP BY tag) AS max_results; -- alias for subquery

#---------------------------------------------------------------------

Exploring
distributions

***Count values
SELECT unanswered_count, count(*)
FROM stackoverflow
WHERE tag='amazon-ebs'
GROUP BY unanswered_count
ORDER BY unanswered_count;

***Truncate
SELECT trunc(42.1256, 2);
42.12
SELECT trunc(12345, -3);
12000

***Truncating and grouping
SELECT trunc(unanswered_count, -1) AS trunc_ua,
count(*)
FROM stackoverflow
WHERE tag='amazon-ebs'
GROUP BY trunc_ua -- column alias
ORDER BY trunc_ua; -- column alias

***Generate series
SELECT generate_series(start, end, step);

***Generate series
SELECT generate_series(1, 10, 2);
generate_series
-----------------
1
3
5
7
9
(5 rows)
SELECT generate_series(0, 1, .1);
generate_series
-----------------
0
0.1
0.2
0.3
0.4
0.5
0.6
0.7
0.8
0.9
1.0
(11 rows)

***Create bins: output
lower | upper | count
-------+-------+-------
30 | 35 | 0
35 | 40 | 74
40 | 45 | 155
45 | 50 | 39
50 | 55 | 445
55 | 60 | 35
60 | 65 | 0
(7 rows)

1***Create bins: query
-- Create bins
WITH bins AS (
SELECT generate_series(30,60,5) AS lower,
generate_series(35,65,5) AS upper),
-- Subset data to tag of interest
ebs AS (
SELECT unanswered_count
FROM stackoverflow
WHERE tag='amazon-ebs')
-- Count values in each bin
SELECT lower, upper, count(unanswered_count)
-- left join keeps all bins
FROM bins
LEFT JOIN ebs
ON unanswered_count >= lower
AND unanswered_count < upper
-- Group by bin bounds to create the groups
GROUP BY lower, upper
ORDER BY lower;

#---------------------------------------------------------------------
Truncate
Use trunc() to examine the distributions of attributes of the Fortune 500 companies.

Remember that trunc() truncates numbers by replacing lower place value digits with zeros:

trunc(value_to_truncate, places_to_truncate)
Negative values for places_to_truncate indicate digits to the left of the decimal to replace, while positive values indicate digits to the right of the decimal to keep.

step01
-- Truncate employees
SELECT trunc(employees, -5) AS employee_bin,
       -- Count number of companies with each truncated value
       COUNT(*)
  FROM fortune500
 -- Use alias to group
 GROUP BY employee_bin
 -- Use alias to order
 ORDER BY employee_bin;

 STEP02
 -- Truncate employees
SELECT trunc(employees, -4) AS employee_bin,
       -- Count number of companies with each truncated value
       COUNT(*)
  FROM fortune500
 -- Limit to which companies?
 WHERE employees < 100000 
 -- Use alias to group
 GROUP BY employee_bin
 -- Use alias to order
 ORDER BY employee_bin;

#---------------------------------------------------------------------
Generate series
Summarize the distribution of the number of questions with the tag "dropbox" on Stack Overflow per day by binning the data.

Recall:

generate_series(from, to, step)
You can reference the slides using the PDF icon in the upper right corner of the screen.

STEP01
-- Select the min and max of question_count
SELECT MIN(question_count), 
       MAX(question_count)
  -- From what table?
  FROM stackoverflow
 -- For tag dropbox
 WHERE tag = 'dropbox';

 STEP02
 -- Create lower and upper bounds of bins
SELECT generate_series(2200, 3050, 50) AS lower,
       generate_series(2250, 3100, 50) AS upper;

STEP03
-- Bins created in Step 2
WITH bins AS (
      SELECT generate_series(2200, 3050, 50) AS lower,
             generate_series(2250, 3100, 50) AS upper),
     -- Subset stackoverflow to just tag dropbox (Step 1)
     dropbox AS (
      SELECT question_count 
        FROM stackoverflow
       WHERE tag='dropbox') 
-- Select columns for result
-- What column are you counting to summarize?
SELECT lower, upper, count(question_count) 
  FROM bins  -- Created above
       -- Join to dropbox (created above), 
       -- keeping all rows from the bins table in the join
       LEFT JOIN dropbox
       -- Compare question_count to lower and upper
         ON question_count >= lower 
        AND question_count < upper
 -- Group by lower and upper to count values in each bin
 GROUP BY lower, upper
 -- Order by lower to put bins in order
 ORDER BY lower;

#---------------------------------------------------------------------
VIDEO
More summary functions

***Correlation function
SELECT corr(assets, equity)
FROM fortune500;
corr
-------------------
0.637710143588615
(1 row)

***Median

***Percentile functions
***
SELECT percentile_disc(percentile) WITHIN GROUP (ORDER BY column_name)
FROM table;
-- percentile between 0 and 1
Returns a value from column
***
SELECT percentile_cont(percentile) WITHIN GROUP (ORDER BY column_name)
FROM table;
Interpolates between values

Percentile examples
SELECT val
FROM nums;
val
-----
1
3
4
5
(4 rows)
SELECT percentile_disc(.5) WITHIN GROUP (ORDER BY val),
percentile_cont(.5) WITHIN GROUP (ORDER BY val)
FROM nums;
percentile_disc | percentile_cont
-----------------+-----------------
3 | 3.5

Common issues
Error codes
Examples: 9, 99, -99
Missing value codes
NA, NaN, N/A, #N/A
0 = missing or 0?
Outlier (extreme) values
Really high or low?
Negative values?
Not really a number
Examples: zip codes, survey response categories

#---------------------------------------------------------------------
Correlation
What's the relationship between a company's revenue and its other financial attributes? Compute the correlation between revenues and other financial variables with the corr() function.

-- Correlation between revenues and profit
SELECT corr(revenues, profits) AS rev_profits,
	   -- Correlation between revenues and assets
       corr(revenues, assets) AS rev_assets,
       -- Correlation between revenues and equity
       corr(revenues, equity) AS rev_equity 
  FROM fortune500;

#---------------------------------------------------------------------
Mean and Median
Compute the mean (avg()) and median assets of Fortune 500 companies by sector.

Use the percentile_disc() function to compute the median:

percentile_disc(0.5) 
WITHIN GROUP (ORDER BY column_name)

-- What groups are you computing statistics by?
SELECT sector,
       -- Select the mean of assets with the avg function
       AVG(assets) AS mean,
       -- Select the median
       percentile_disc(.5) WITHIN GROUP (ORDER BY assets) AS median
  FROM fortune500
 -- Computing statistics for each what?
 GROUP BY sector
 -- Order results by a value of interest
 ORDER BY mean;

#---------------------------------------------------------------------
VIDEO
Creating temporary tables

***Syntax

Create Temp Table Syntax
-- Create table as
CREATE TEMP TABLE new_tablename AS
-- Query results to store in the table
SELECT column1, column2
FROM table;

Select Into Syntax
-- Select existing columns
SELECT column1, column2
-- Clause to direct results to a new temp table
INTO TEMP TABLE new_tablename
-- Existing table with exisitng columns
FROM table;

***Create a table
CREATE TEMP TABLE top_companies AS
SELECT rank,
title
FROM fortune500
WHERE rank <= 10;
SELECT *
FROM top_companies;
rank | title
------+--------------------
1 | Walmart
2 | Berkshire Hathaway
3 | Apple
4 | Exxon Mobil
5 | McKesson
6 | UnitedHealth Group
7 | CVS Health
8 | General Motors
9 | AT&T
10 | Ford Motor
(10 rows)

***Insert into table
INSERT INTO top_companies
SELECT rank, title
FROM fortune500
WHERE rank BETWEEN 11 AND 20;
SELECT * FROM top_companies;

***Delete (drop) table
DROP TABLE top_companies;
DROP TABLE IF EXISTS top_companies;

#---------------------------------------------------------------------
Create a temp table
Find the Fortune 500 companies that have profits in the top 20% for their sector (compared to other Fortune 500 companies).

To do this, first, find the 80th percentile of profit for each sector with

percentile_disc(fraction) 
WITHIN GROUP (ORDER BY sort_expression)
and save the results in a temporary table.

Then join fortune500 to the temporary table to select companies with profits greater than the 80th percentile cut-off.

step01
-- To clear table if it already exists;
-- fill in name of temp table
DROP TABLE IF EXISTS profit80;

-- Create the temporary table
CREATE TEMP TABLE profit80 AS 
  -- Select the two columns you need; alias as needed
  SELECT sector, 
         percentile_disc(.8) WITHIN GROUP (ORDER BY profits) AS pct80
    -- What table are you getting the data from?
    FROM fortune500
   -- What do you need to group by?
   GROUP BY sector;
   
-- See what you created: select all columns and rows 
-- from the table you created
SELECT * 
  FROM profit80;

step02
-- Code from previous step
DROP TABLE IF EXISTS profit80;

CREATE TEMP TABLE profit80 AS
  SELECT sector, 
         percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    FROM fortune500 
   GROUP BY sector;

-- Select columns, aliasing as needed
SELECT title, profit80.sector, 
       profits, profits/pct80 AS ratio
-- What tables do you need to join?  
  FROM fortune500 
       LEFT JOIN profit80
-- How are the tables joined?
       ON fortune500.sector=profit80.sector
-- What rows do you want to select?
 WHERE profits > pct80;

#---------------------------------------------------------------------
Create a temp table to simplify a query
The Stack Overflow data contains daily question counts through 2018-09-25 for all tags, but each tag has a different starting date in the data.

Find out how many questions had each tag on the first date for which data for the tag is available, as well as how many questions had the tag on the last day. Also, compute the difference between these two values.

To do this, first compute the minimum date for each tag.

Then use the minimum dates to select the question_count on both the first and last day. To do this, join the temp table startdates to two different copies of the stackoverflow table: one for each column - first day and last day - aliased with different names.

step01
-- To clear table if it already exists
DROP TABLE IF EXISTS startdates;

-- Create temp table syntax
CREATE TEMP TABLE startdates AS
-- Compute the minimum date for each what?
SELECT tag,
       min(date) AS mindate
  FROM stackoverflow
 -- What do you need to compute the min date for each tag?
 GROUP BY tag;
 
 -- Look at the table you created
 SELECT * 
   FROM startdates;

step02
-- To clear table if it already exists
DROP TABLE IF EXISTS startdates;

CREATE TEMP TABLE startdates AS
SELECT tag, min(date) AS mindate
  FROM stackoverflow
 GROUP BY tag;
 
-- Select tag (Remember the table name!) and mindate
SELECT startdates.tag, 
       mindate, 
       -- Select question count on the min and max days
	   so_min.question_count  AS min_date_question_count,
       so_max.question_count  AS max_date_question_count,
       -- Compute the change in question_count (max- min)
       so_max.question_count - so_min.question_count AS change
  FROM startdates
       -- Join startdates to stackoverflow with alias so_min
       INNER JOIN stackoverflow AS so_min
          -- What needs to match between tables?
          ON startdates.tag = so_min.tag
         AND startdates.mindate = so_min.date
       -- Join to stackoverflow again with alias so_max
       INNER JOIN stackoverflow AS so_max
       	  -- Again, what needs to match between tables?
          ON startdates.tag = so_max.tag
         AND so_max.date = '2018-09-25';

#---------------------------------------------------------------------

Insert into a temp table
While you can join the results of multiple similar queries together with UNION, sometimes it's easier to break a query down into steps. You can do this by creating a temporary table and inserting rows into it.

Compute the correlations between each pair of profits, profits_change, and revenues_change from the Fortune 500 data.

The resulting temporary table should have the following structure:

measure	profits	profits_change	revenues_change
profits	1.00	#	#
profits_change	#	1.00	#
revenues_change	#	#	1.00
Recall the round() function to make the results more readable:

round(column_name::numeric, decimal_places)
Note that Steps 1 and 2 do not produce output. It is normal for the query result pane to say "Your query did not generate any results."

step01
DROP TABLE IF EXISTS correlations;

-- Create temp table 
CREATE TEMP TABLE correlations AS
-- Select each correlation
SELECT 'profits'::varchar AS measure,
       -- Compute correlations
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

step02
DROP TABLE IF EXISTS correlations;

CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure,
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

-- Add a row for profits_change
-- Insert into what table?
INSERT INTO correlations
-- Follow the pattern of the select statement above
-- Using profits_change instead of profits
SELECT 'profits_change'::varchar AS measure,
       corr(profits_change, profits) AS profits,
       corr(profits_change, profits_change) AS profits_change,
       corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;

-- Repeat the above, but for revenues_change
INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure,
       corr(revenues_change, profits) AS profits,
       corr(revenues_change, profits_change) AS profits_change,
       corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;

step03
DROP TABLE IF EXISTS correlations;

CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure,
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

INSERT INTO correlations
SELECT 'profits_change'::varchar AS measure,
       corr(profits_change, profits) AS profits,
       corr(profits_change, profits_change) AS profits_change,
       corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;

INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure,
       corr(revenues_change, profits) AS profits,
       corr(revenues_change, profits_change) AS profits_change,
       corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;

-- Select each column, rounding the correlations
SELECT measure, 
       ROUND(profits::numeric, 2) AS profits,
       ROUND(profits_change::numeric, 2) AS profits_change,
       ROUND(revenues_change::numeric, 2) AS revenues_change
  FROM correlations;


######################################################################
######################################################################
######################################################################

######## Exploring categorical data and unstructured text (Module 03-026)
######################################################################

video

Character data types
and common issues

***PostgreSQL character types
character(n) or char(n)
  fixed length n
  trailing spaces ignored in comparisons
character varying(n) or varchar(n)
  variable length up to a maximum of n
text or varchar
  unlimited length

***Types of text data
  Categorical
    Tues, Tuesday, Mon, TH
    shirts, shoes, hats, pants

  Unstructured Text
    I really like this product. I use it every day. It's my
    favorite color.
    We've redesigned your favorite t-shirt to make it
    even better. You'll love...

***Grouping and counting
SELECT category, -- categorical variable
count(*) -- count rows for each category
FROM product -- table
GROUP BY category; -- categorical variable

***Order: most frequent values
SELECT category, -- categorical variable
count(*) -- count rows for each category
FROM product -- table
GROUP BY category -- categorical variable
ORDER BY count DESC; -- show most frequent values first

***Order: category value
SELECT category, -- categorical variable
count(*) -- count rows for each category
FROM product -- table
GROUP BY category -- categorical variable
ORDER BY category; -- order by categorical variable

***Alphabetical order
-- Results
category | count
----------+-------
apple | 1
Apple | 4
Banana | 1
apple | 2
banana | 3
(5 rows)
-- Alphabetical Order:
' ' < 'A' < 'a'
-- From results
' ' < 'A' < 'B' < 'a' < 'b'

***Common issues
Case matters
'apple' != 'Apple'
Spaces count
' apple' != 'apple'
'' != ' '
Empty strings aren't null
'' != NULL
Punctuation differences
'to-do' != 'to–do'


#---------------------------------------------------------------------

Count the categories
In this chapter, we'll be working mostly with the Evanston 311 data in table evanston311. This is data on help requests submitted to the city of Evanston, IL.

This data has several character columns. Start by examining the most frequent values in some of these columns to get familiar with the common categories.

STEP01
-- Select the count of each level of priority
SELECT priority, COUNT(*)
  FROM evanston311
 GROUP BY priority;

 STEP02
 -- Find values of zip that appear in at least 100 rows
-- Also get the count of each value
SELECT zip, COUNT(*)
  FROM evanston311
 GROUP BY zip
HAVING COUNT(*) >=100; 

STEP03
-- Find values of source that appear in at least 100 rows
-- Also get the count of each value
SELECT source, COUNT(*)
  FROM evanston311
 GROUP BY source
HAVING COUNT(*) >=100; 

STEP04
-- Find the 5 most common values of street and the count of each
SELECT street, COUNT(*)
  FROM evanston311
 GROUP BY street
 ORDER BY count(*) DESC
 LIMIT 5;

#---------------------------------------------------------------------

Spotting character data problems
Explore the distinct values of the street column. Select each street value and the count of the number of rows with that value. Sort the results by street to see similar values near each other.

Look at the results.

Which of the following is NOT an issue you see with the values of street?

-- Find the 5 most common values of street and the count of each
SELECT street, COUNT(*)
  FROM evanston311
 GROUP BY street
 ORDER BY count(*), street  DESC

Correct! street values do not have extra spaces. You could verify this with a LIKE query.

#---------------------------------------------------------------------
VIDEO

Cases and Spaces

***Converting case
SELECT lower('aBc DeFg 7-');
abc defg 7-
SELECT upper('aBc DeFg 7-');
ABC DEFG 7-

***Case insensitive comparisons
SELECT *
FROM fruit;

SELECT *
FROM fruit
WHERE lower(fav_fruit)='apple';

***Case insensitive searches
-- Using LIKE
SELECT *
FROM fruit
-- "apple" in value
WHERE fav_fruit LIKE '%apple%';

-- Using ILIKE
SELECT *
FROM fruit
-- ILIKE for case insensitive
WHERE fav_fruit ILIKE '%apple%';

***Watch out
SELECT fruit
FROM fruit2;
fruit
------------
apple
banana
pineapple
grapefruit
grapes

SELECT fruit
FROM fruit2
WHERE fruit LIKE '%apple%';
fruit
------------
apple
pineapple

***Trimming spaces
SELECT trim(' abc ');
  trim or btrim : both ends
    trim(' abc ') = 'abc'
  rtrim : right end
    rtrim(' abc ') = ' abc'
  ltrim : left start
    ltrim(' abc ') = 'abc '

***Trimming other values
SELECT trim('Wow!', '!');
Wow
SELECT trim('Wow!', '!wW');
o

***Combining functions
SELECT trim(lower('Wow!'), '!w');
o

***Bring order to messy
text!

#---------------------------------------------------------------------
Trimming
Some of the street values in evanston311 include house numbers with # or / in them. In addition, some street values end in a ..

Remove the house numbers, extra punctuation, and any spaces from the beginning and end of the street values as a first attempt at cleaning up the values.

SELECT distinct street,
       -- Trim off unwanted characters from street
       trim(street, '0123456789 #/.') AS cleaned_street
  FROM evanston311
 ORDER BY street;

#---------------------------------------------------------------------
Exploring unstructured text
The description column of evanston311 has the details of the inquiry, while the category column groups inquiries into different types. How well does the category capture what's in the description?

LIKE and ILIKE queries will help you find relevant descriptions and categories. Remember that with LIKE queries, you can include a % on each side of a word to find values that contain the word. For example:

SELECT category
  FROM evanston311
 WHERE category LIKE '%Taxi%';
% matches 0 or more characters.

Building up the query through the steps below, find inquires that mention trash or garbage in the description without trash or garbage being in the category. What are the most frequent categories for such inquiries?

step01
-- Count rows
SELECT COUNT(*)
  FROM evanston311
 -- Where description includes trash or garbage
 WHERE description ILIKE '%trash%'
    OR description ILIKE '%garbage%';

STEP02
-- Select categories containing Trash or Garbage
SELECT category
  FROM evanston311
 -- Use LIKE
 WHERE category LIKE '%Trash%'
    OR category LIKE '%Garbage%';

STEP03
-- Count rows
SELECT COUNT(*)
  FROM evanston311 
 -- description contains trash or garbage (any case)
 WHERE (description ILIKE '%Trash%'
    OR description ILIKE '%Garbage%') 
 -- category does not contain Trash or Garbage
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%';

STEP04
-- Count rows with each category
SELECT category, count(*)
  FROM evanston311 
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%'
 -- What are you counting?
 GROUP BY category
 --- order by most frequent values
 ORDER BY count DESC
 LIMIT 10;

#---------------------------------------------------------------------
video

Splitting and
concatenating text

***Substring
SELECT left('abcde', 2), -- first 2 characters
right('abcde', 2); -- last 2 characters
left | right
------+-------
ab | de
SELECT left('abc', 10),
length(left('abc', 10));
left | length
------+--------
abc | 3

SELECT substring(string FROM start FOR length);
SELECT substring('abcdef' FROM 2 FOR 3);
bcd
SELECT substr('abcdef', 2, 3);

***Delimiters
some text,more text,still more text
^ ^
delimiter delimiter
Fields/chunks:
1. some text
2. more text
3. still more text

***Splitting on a delimiter
SELECT split_part(string, delimiter, part);
SELECT split_part('a,bc,d', ',', 2);
bc

SELECT split_part('cats and dogs and fish', ' and ', 1);
cats

Concatenating text
SELECT concat('a', 2, 'cc');
a2cc
SELECT 'a' || 2 || 'cc';
a2cc
SELECT concat('a', NULL, 'cc');
acc
SELECT 'a' || NULL || 'cc';
NULL

***Manipulate some
strings!

#---------------------------------------------------------------------
Concatenate strings
House number (house_num) and street are in two separate columns in evanston311. Concatenate them together with concat() with a space in between the values.

-- Concatenate house_num, a space, and street
-- and trim spaces from the start of the result
SELECT TRIM(CONCAT(house_num,' ', street)) AS address
  FROM evanston311;

#---------------------------------------------------------------------

Split strings on a delimiter
The street suffix is the part of the street name that gives the type of street, such as Avenue, Road, or Street. In the Evanston 311 data, sometimes the street suffix is the full word, while other times it is the abbreviation.

Extract just the first word of each street value to find the most common streets regardless of the suffix.

To do this, use

split_part(string_to_split, delimiter, part_number)

-- Select the first word of the street value
SELECT split_part(street, ' ', 1) AS street_name, 
       count(*)
  FROM evanston311
 GROUP BY street_name
 ORDER BY count DESC
 LIMIT 20;

#---------------------------------------------------------------------

Shorten long strings
The description column of evanston311 can be very long. You can get the length of a string with the length() function.

For displaying or quickly reviewing the data, you might want to only display the first few characters. You can use the left() function to get a specified number of characters at the start of each value.

To indicate that more data is available, concatenate '...' to the end of any shortened description. To do this, you can use a CASE WHEN statement to add '...' only when the string length is greater than 50.

Select the first 50 characters of description when description starts with the word "I".

-- Select the first 50 chars when length is greater than 50
SELECT CASE WHEN length(description) > 50
            THEN left(description, 50) || '...'
       -- otherwise just select description
       ELSE description
       END
  FROM evanston311
 -- limit to descriptions that start with the word I
 WHERE description LIKE 'I %'
 ORDER BY description;

#---------------------------------------------------------------------
video
Strategies for
Multiple
Transformations

***Multiple transformations
SELECT * FROM naics;

***CASE WHEN
-- Case for each of :, -, and |
SELECT CASE WHEN category LIKE '%: %' THEN split_part(category, ': ', 1)
WHEN category LIKE '% - %' THEN split_part(category, ' - ', 1)
ELSE split_part(category, ' | ', 1)
END AS major_category, -- alias the result
sum(businesses) -- also select number of businesses
FROM naics
GROUP BY major_category; -- Group by categories created above

***Recoding table
Original values: fruit table

Standardized values: recode table

***Step 1: CREATE TEMP TABLE
CREATE TEMP TABLE recode AS
SELECT DISTINCT fav_fruit AS original, -- original, messy values
fav_fruit AS standardized -- new standardized values
FROM fruit;

***Initial table
SELECT *
FROM recode;

***Step 2: UPDATE values
UPDATE table_name
SET column_name = new_value
WHERE condition;

***Step 2: UPDATE values
-- All rows: lower case, remove white space on ends
UPDATE recode
SET standardized=trim(lower(original));
-- Specific rows: correct a misspelling
UPDATE recode
SET standardized='banana'
WHERE standardized LIKE '%nn%';
-- All rows: remove any s
UPDATE recode
SET standardized=rtrim(standardized, 's');

Resulting recode table
SELECT *
FROM recode;

***Step 3: JOIN original and recode tables
Original only
SELECT fav_fruit, count(*)
FROM fruit
GROUP BY fav_fruit;
fav_fruit | count
-----------+-------
APPLES | 1
apple | 1
apple | 3
banana | 1
BANANA | 2
apple | 1
APPLE | 1
bannana | 1
banana | 1
Apple | 1

With recoded values
SELECT standardized,
count(*)
FROM fruit
LEFT JOIN recode
ON fav_fruit=original
GROUP BY standardized;
standardized | count
--------------+-------
apple | 8
banana | 5
(2 rows)

***Recap
1. CREATE TEMP TABLE with original values
2. UPDATE to create standardized values
3. JOIN original data to standardized data

#---------------------------------------------------------------------
Create an "other" category
If we want to summarize Evanston 311 requests by zip code, it would be useful to group all of the low frequency zip codes together in an "other" category.

Which of the following values, when substituted for ??? in the query, would give the result below?

Query:

SELECT CASE WHEN zipcount < ??? THEN 'other'
       ELSE zip
       END AS zip_recoded,
       sum(zipcount) AS zipsum
  FROM (SELECT zip, count(*) AS zipcount
          FROM evanston311
         GROUP BY zip) AS fullcounts
 GROUP BY zip_recoded
 ORDER BY zipsum DESC;
Result:

zip_recoded    zipsum
60201          19054
60202          11165
null           5528
other          429
60208          255

SELECT CASE WHEN zipcount < 100 THEN 'other'
       ELSE zip
       END AS zip_recoded,
       sum(zipcount) AS zipsum
  FROM (SELECT zip, count(*) AS zipcount
          FROM evanston311
         GROUP BY zip) AS fullcounts
 GROUP BY zip_recoded
 ORDER BY zipsum DESC;
#---------------------------------------------------------------------

Group and recode values
There are almost 150 distinct values of evanston311.category. But some of these categories are similar, with the form "Main Category - Details". We can get a better sense of what requests are common if we aggregate by the main category.

To do this, create a temporary table recode mapping distinct category values to new, standardized values. Make the standardized values the part of the category before a dash ('-'). Extract this value with the split_part() function:

split_part(string text, delimiter text, field int)
You'll also need to do some additional cleanup of a few cases that don't fit this pattern.

Then the evanston311 table can be joined to recode to group requests by the new standardized category values.

step01
-- Fill in the command below with the name of the temp table
DROP TABLE IF EXISTS recode;

-- Create and name the temporary table
CREATE TEMP TABLE recode AS
-- Write the select query to generate the table 
-- with distinct values of category and standardized values
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    -- What table are you selecting the above values from?
    FROM evanston311;
    
-- Look at a few values before the next step
SELECT DISTINCT standardized 
  FROM recode
 WHERE standardized LIKE 'Trash%Cart'
    OR standardized LIKE 'Snow%Removal%';

step02
-- Code from previous step
DROP TABLE IF EXISTS recode;

CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    FROM evanston311;

-- Update to group trash cart values
UPDATE recode 
   SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';

-- Update to group snow removal values
UPDATE recode 
   SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';
    
-- Examine effect of updates
SELECT DISTINCT standardized 
  FROM recode
 WHERE standardized LIKE 'Trash%Cart'
    OR standardized LIKE 'Snow%Removal%';

step03
-- Code from previous step
DROP TABLE IF EXISTS recode;

CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    FROM evanston311;
  
UPDATE recode SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';

UPDATE recode SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';

-- Update to group unused/inactive values
UPDATE recode 
   SET standardized='UNUSED' 
 WHERE standardized IN ('THIS REQUEST IS INACTIVE...Trash Cart', 
               '(DO NOT USE) Water Bill',
                'DO NOT USE Trash', 
                'NO LONGER IN USE');

-- Examine effect of updates
SELECT DISTINCT standardized 
  FROM recode
 ORDER BY standardized;

 step04
-- Code from previous step
DROP TABLE IF EXISTS recode;
CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
  FROM evanston311;
UPDATE recode SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';
UPDATE recode SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';
UPDATE recode SET standardized='UNUSED' 
 WHERE standardized IN ('THIS REQUEST IS INACTIVE...Trash Cart', 
               '(DO NOT USE) Water Bill',
               'DO NOT USE Trash', 'NO LONGER IN USE');

-- Select the recoded categories and the count of each
SELECT standardized, COUNT(*)
-- From the original table and table with recoded values
  FROM evanston311 
       LEFT JOIN recode 
       -- What column do they have in common?
       ON evanston311.category = recode.category
 -- What do you need to group by to count?
 GROUP BY standardized
 -- Display the most common val values first
 ORDER BY COUNT DESC;

#---------------------------------------------------------------------
Create a table with indicator variables
Determine whether medium and high priority requests in the evanston311 data are more likely to contain requesters' contact information: an email address or phone number.

Emails contain an @.
Phone numbers have the pattern of three characters, dash, three characters, dash, four characters. For example: 555-555-1212.
Use LIKE to match these patterns. Remember % matches any number of characters (even 0), and _ matches a single character. Enclosing a pattern in % (i.e. before and after your pattern) allows you to locate it within other text.

For example, '%___.com%'would allow you to search for a reference to a website with the top-level domain '.com' and at least three characters preceding it.

Create and store indicator variables for email and phone in a temporary table. LIKE produces True or False as a result, but casting a boolean (True or False) as an integer converts True to 1 and False to 0. This makes the values easier to summarize later.

step01
-- To clear table if it already exists
DROP TABLE IF EXISTS indicators;

-- Create the indicators temp table
CREATE TEMP TABLE indicators AS
  -- Select id
  SELECT id, 
         -- Create the email indicator (find @)
         CAST (description LIKE '%@%' AS integer) AS email,
         -- Create the phone indicator
         CAST (description LIKE '%___-___-____%' AS integer) AS phone 
    -- What table contains the data? 
    FROM evanston311;

-- Inspect the contents of the new temp table
SELECT *
  FROM indicators;

step02
-- To clear table if it already exists
DROP TABLE IF EXISTS indicators;

-- Create the temp table
CREATE TEMP TABLE indicators AS
  SELECT id, 
         CAST (description LIKE '%@%' AS integer) AS email,
         CAST (description LIKE '%___-___-____%' AS integer) AS phone 
    FROM evanston311;
  
-- Select the column you'll group by
SELECT priority,
       -- Compute the proportion of rows with each indicator
       SUM(email)/COUNT(*)::numeric AS email_prop, 
       SUM(phone)/COUNT(*)::numeric AS phone_prop
  -- Tables to select from
  FROM evanston311
       LEFT JOIN indicators
       -- Joining condition
       ON evanston311.id=indicators.id
 -- What are you grouping by?
 GROUP BY priority;


######################################################################
######################################################################
######################################################################

######## Working with dates and timestamps  (Module 04-026)
######################################################################

video

Date/time types and
formats

***Main types
  date
    YYYY-MM-DD
    example: 2018-12-30
  timestamp
    YYYY-MM-DD HH:MM:SS
    example: 2018-12-30 13:10:04.3

***Intervals
interval examples:
6 days 01:48:08
00:51:03
1 day 21:57:47
07:48:46
406 days 00:31:56

***ISO 8601
ISO = International Organization for Standards
YYYY-MM-DD HH:MM:SS
Example: 2018-01-05 09:35:15

***UTC and timezones
UTC = Coordinated Universal Time
Timestamp with timezone:
YYYY-MM-DD HH:MM:SS+HH
Example: 2004-10-19 10:23:54+02

***Date and time comparisons
Compare with > , < , =
SELECT '2018-01-01' > '2017-12-31';
now() : current timestamp
SELECT now() > '2017-12-31';

***Date subtraction
SELECT now() - '2018-01-01';
343 days 21:26:32.710898
SELECT now() - '2015-01-01';
1439 days 21:32:22.616076

***Date addition
SELECT '2010-01-01'::date + 1;
2010-01-02
SELECT '2018-12-10'::date + '1 year'::interval;
2019-12-10 00:00:00
SELECT '2018-12-10'::date + '1 year 2 days 3 minutes'::interval ;
2019-12-12 00:03:00

#---------------------------------------------------------------------

Date comparisons
When working with timestamps, sometimes you want to find all observations on a given day. However, if you specify only a date in a comparison, you may get unexpected results. This query:

SELECT count(*) 
  FROM evanston311
 WHERE date_created = '2018-01-02';
returns 0, even though there were 49 requests on January 2, 2018.

This is because dates are automatically converted to timestamps when compared to a timestamp. The time fields are all set to zero:

SELECT '2018-01-02'::timestamp;
 2018-01-02 00:00:00
When working with both timestamps and dates, you'll need to keep this in mind.

step01
-- Count requests created on January 31, 2017
SELECT count(*) 
  FROM evanston311
 WHERE date_created::date = '2017-01-31';

 step02
 -- Count requests created on February 29, 2016
SELECT count(*)
  FROM evanston311 
 WHERE date_created >= '2016-02-29' 
   AND date_created < '2016-03-01';

step03
-- Count requests created on March 13, 2017
SELECT count(*)
  FROM evanston311
 WHERE date_created >= '2017-03-13'
   AND date_created < '2017-03-13'::date + 1;


#---------------------------------------------------------------------
Date arithmetic
You can subtract dates or timestamps from each other.

You can add time to dates or timestamps using intervals. An interval is specified with a number of units and the name of a datetime field. For example:

'3 days'::interval
'6 months'::interval
'1 month 2 years'::interval
'1 hour 30 minutes'::interval
Practice date arithmetic with the Evanston 311 data and now().

step01
-- Subtract the min date_created from the max
SELECT MAX(date_created) - MIN(date_created)
  FROM evanston311;

step02
-- How old is the most recent request?
SELECT NOW()-MAX(date_created)
  FROM evanston311;

step03
-- Add 100 days to the current timestamp
SELECT NOW() + '100 days'::interval;

step04
-- Select the current timestamp, 
-- and the current timestamp + 5 minutes
SELECT NOW(), NOW() + '5 minutes'::interval;

#---------------------------------------------------------------------
Completion time by category
The evanston311 data includes a date_created timestamp from when each request was created and a date_completed timestamp for when it was completed. The difference between these tells us how long a request was open.

Which category of Evanston 311 requests takes the longest to complete?

-- Select the category and the average completion time by category
SELECT category, 
       AVG(date_completed - date_created) AS completion_time
  FROM evanston311
 GROUP BY category
-- Order the results
 ORDER BY completion_time DESC;

#---------------------------------------------------------------------
video

Date/time
components and
aggregation

***Common date/time 
  Fields
    century: 2019-01-01 = century 21
    decade: 2019-01-01 = decade 201
    year, month, day
    hour, minute, second
    week
    dow: day of week

***Extracting fields
-- functions to extract datetime fields
date_part('field', timestamp)
EXTRACT(FIELD FROM timestamp)

-- now is 2019-01-08 22:15:10.647281-06
SELECT date_part('month', now()),
EXTRACT(MONTH FROM now());

date_part | date_part
-----------+-----------
1 | 1

***Extract to summarize by 
Individual sales
SELECT *
FROM sales
WHERE date >= '2010-01-01'
AND date < '2017-01-01';

By month
SELECT date_part('month', date)
AS month,
sum(amt)
FROM sales
GROUP BY month
ORDER BY month;

***Truncating dates
date_trunc('field', timestamp)
-- now() is 2018-12-17 21:45:15.6829-06
SELECT date_trunc('month', now());
date_trunc
------------------------
2018-12-01 00:00:00-06

***Truncate to keep larger units
Individual sales
SELECT *
FROM sales
WHERE date >= '2017-06-01'
AND date < '2019-02-01';

By month with year
SELECT date_trunc('month', date)
AS month
sum(amt)
FROM sales
GROUP BY month
ORDER BY month;

***Time to practice
extracting and
aggregating dates

#---------------------------------------------------------------------
Date parts
The date_part() function is useful when you want to aggregate data by a unit of time across multiple larger units of time. For example, aggregating data by month across different years, or aggregating by hour across different days.

Recall that you use date_part() as:

SELECT date_part('field', timestamp);
In this exercise, you'll use date_part() to gain insights about when Evanston 311 requests are submitted and completed.

step01
-- Extract the month from date_created and count requests
SELECT date_part('month', date_created) AS month, 
       count(*)
  FROM evanston311
 -- Limit the date range
 WHERE date_created >= '2016-01-01'
   AND date_created <= '2018-01-01'
 -- Group by what to get monthly counts?
 GROUP BY month;

step02
 -- Get the hour and count requests
SELECT date_part('hour', date_created) AS hour,
       count(*)
  FROM evanston311
 GROUP BY hour
 -- Order results to select most common
 ORDER BY count DESC 
 LIMIT 1;

step03
-- Count requests completed by hour
SELECT date_part('hour', date_completed) AS hour,
       count(*)
  FROM evanston311
 GROUP BY hour
 ORDER BY count DESC ;

#---------------------------------------------------------------------
Variation by day of week
Does the time required to complete a request vary by the day of the week on which the request was created?

We can get the name of the day of the week by converting a timestamp to character data:

to_char(date_created, 'day') 
But character names for the days of the week sort in alphabetical, not chronological, order. To get the chronological order of days of the week with an integer value for each day, we can use:

EXTRACT(DOW FROM date_created)
DOW stands for "day of week."

-- Select name of the day of the week the request was created 
SELECT to_char(date_created, 'day') AS day, 
       -- Select avg time between request creation and completion
       AVG(date_completed - date_created) AS duration
  FROM evanston311 
 -- Group by the name of the day of the week and 
 -- integer value of day of week the request was created
 GROUP BY day, EXTRACT(DOW FROM date_created)
 -- Order by integer value of the day of the week 
 -- the request was created
 ORDER BY EXTRACT(DOW FROM date_created);

#---------------------------------------------------------------------
Date truncation
Unlike date_part() or EXTRACT(), date_trunc() keeps date/time units larger than the field you specify as part of the date. So instead of just extracting one component of a timestamp, date_trunc() returns the specified unit and all larger ones as well.

Recall the syntax:

date_trunc('field', timestamp)
Using date_trunc(), find the average number of Evanston 311 requests created per day for each month of the data. Ignore days with no requests when taking the average.

-- Aggregate daily counts by month
SELECT date_trunc('month', day) AS month,
       avg(count)
  -- Subquery to compute daily counts
  FROM (SELECT date_trunc('day', date_created) AS day,
               count(*) AS count
          FROM evanston311
         GROUP BY day) AS daily_count
 GROUP BY month
 ORDER BY month;

#---------------------------------------------------------------------
video
Aggregating with date/time series

***Generate series
SELECT generate_series(from, to, interval);
SELECT generate_series('2018-01-01',
'2018-01-15',
'2 days'::interval);

SELECT generate_series('2018-01-01',
'2018-01-02',
'5 hours'::interval);

***Generate series from the beginning
SELECT generate_series('2018-01-31',
'2018-12-31',
'1 month'::interval);

-- Subtract 1 day to get end of month
SELECT generate_series('2018-02-01', -- start 1 month late
'2019-01-01',
'1 month'::interval) - '1 day'::interval;

***Normal aggregation
SELECT * FROM sales;
SELECT date_trunc('hour', date)
AS hour,
count(*)
FROM sales
GROUP BY hour
ORDER BY hour;
hour | count
---------------------+-------
2018-04-23 09:00:00 | 3
2018-04-23 10:00:00 | 2
2018-04-23 12:00:00 | 3
2018-04-23 13:00:00 | 2
(4 rows)
--don'tshowhourswithnosales--

***Aggregation with series
-- Create the series as a table called hour_series
WITH hour_series AS (
SELECT generate_series('2018-04-23 09:00:00', -- 9am
'2018-04-23 14:00:00', -- 2pm
'1 hour'::interval) AS hours)
-- Hours from series, count date (NOT *) to count non-NULL
SELECT hours, count(date)
-- Join series to sales data
FROM hour_series
LEFT JOIN sales
ON hours=date_trunc('hour', date)
GROUP BY hours
ORDER BY hours;

***Aggregation with series: result
hours | count
------------------------+-------
2018-04-23 09:00:00-05 | 3
2018-04-23 10:00:00-05 | 2
2018-04-23 11:00:00-05 | 0
2018-04-23 12:00:00-05 | 3
2018-04-23 13:00:00-05 | 2
2018-04-23 14:00:00-05 | 0
(6 rows)

***Aggregation with bins
-- Create bins
WITH bins AS (
SELECT generate_series('2018-04-23 09:00:00',
'2018-04-23 15:00:00',
'3 hours'::interval) AS lower,
generate_series('2018-04-23 12:00:00',
'2018-04-23 18:00:00',
'3 hours'::interval) AS upper)
-- Count values in each bin
SELECT lower, upper, count(date)
-- left join keeps all bins
FROM bins
LEFT JOIN sales
ON date >= lower
AND date < upper
-- Group by bin bounds to create the groups
GROUP BY lower, upper
ORDER BY lower;

***Bin result
lower | upper | count
---------------------+---------------------+-------
2018-04-23 09:00:00 | 2018-04-23 12:00:00 | 5
2018-04-23 12:00:00 | 2018-04-23 15:00:00 | 5
2018-04-23 15:00:00 | 2018-04-23 18:00:00 | 0
(3 rows)

#---------------------------------------------------------------------
Find missing dates
The generate_series() function can be useful for identifying missing dates.

Recall:

generate_series(from, to, interval)
where from and to are dates or timestamps, and interval can be specified as a string with a number and a unit of time, such as '1 month'.

Are there any days in the Evanston 311 data where no requests were created?

SELECT day
-- 1) Subquery to generate all dates
-- from min to max date_created
  FROM (SELECT generate_series(min(date_created),
                               max(date_created),
                               '1 day')::date AS day
          -- What table is date_created in?
          FROM evanston311) AS all_dates
-- 4) Select dates (day from above) that are NOT IN the subquery
 WHERE day NOT IN
       -- 2) Subquery to select all date_created values as dates
       (SELECT date_created::date
          FROM evanston311);

#---------------------------------------------------------------------
Custom aggregation periods
Find the median number of Evanston 311 requests per day in each six month period from 2016-01-01 to 2018-06-30. Build the query following the three steps below.

Recall that to aggregate data by non-standard date/time intervals, such as six months, you can use generate_series() to create bins with lower and upper bounds of time, and then summarize observations that fall in each bin.

Remember: you can access the slides with an example of this type of query using the PDF icon link in the upper right corner of the screen.

step01
-- Generate 6 month bins covering 2016-01-01 to 2018-06-30

-- Create lower bounds of bins
SELECT generate_series('2016-01-01',  -- First bin lower value
                       '2018-01-30',  -- Last bin lower value
                       '6 month'::interval) AS lower,
-- Create upper bounds of bins
       generate_series('2016-07-01',  -- First bin upper value
                       '2018-07-01',  -- Last bin upper value
                       '6 month'::interval) AS upper;

step02
-- Count number of requests made per day
SELECT day, count(date_created) AS count
-- Use a daily series from 2016-01-01 to 2018-06-30 
-- to include days with no requests
  FROM (SELECT generate_series('2016-01-01',  -- series start date
                               '2018-06-30',  -- series end date
                               '1 day'::interval)::date AS day) AS daily_series
       LEFT JOIN evanston311
       -- match day from above (which is a date) to date_created
       ON day = date_created::date
 GROUP BY day;

 step03
 -- Bins from Step 1
WITH bins AS (
	 SELECT generate_series('2016-01-01',
                            '2018-01-01',
                            '6 months'::interval) AS lower,
            generate_series('2016-07-01',
                            '2018-07-01',
                            '6 months'::interval) AS upper),
-- Daily counts from Step 2
     daily_counts AS (
     SELECT day, count(date_created) AS count
       FROM (SELECT generate_series('2016-01-01',
                                    '2018-06-30',
                                    '1 day'::interval)::date AS day) AS daily_series
            LEFT JOIN evanston311
            ON day = date_created::date
      GROUP BY day)
-- Select bin bounds 
SELECT lower, 
       upper, 
       -- Compute median of count for each bin
       percentile_disc(0.5) WITHIN GROUP (ORDER BY day) AS median
  -- Join bins and daily_counts
  FROM bins
       LEFT JOIN daily_counts
       -- Where the day is between the bin bounds
       ON day >= lower
          AND day < upper
 -- Group by bin bounds
 GROUP BY lower, upper
 ORDER BY lower;


****Well done! You might need to create custom bins to correspond 
to fiscal years, academic years, 2-week periods, or other reporting 
periods for your organization.*****

#---------------------------------------------------------------------
Monthly average with missing dates
Find the average number of Evanston 311 requests created per day for each month of the data.

This time, do not ignore dates with no requests.

-- generate series with all days from 2016-01-01 to 2018-06-30
WITH all_days AS 
     (SELECT generate_series('2016-01-01',
                             '2018-06-30',
                             '1 day'::interval) AS date),
     -- Subquery to compute daily counts
     daily_count AS 
     (SELECT date_trunc('day', date_created) AS day,
             count(*) AS count
        FROM evanston311
       GROUP BY day)
-- Aggregate daily counts by month using date_trunc
SELECT date_trunc('month', date) AS month,
       -- Use coalesce to replace NULL count values with 0
       avg(coalesce(count, 0)) AS average
  FROM all_days
       LEFT JOIN daily_count
       -- Joining condition
       ON all_days.date=daily_count.day
 GROUP BY month
 ORDER BY month; 

#---------------------------------------------------------------------
video
Time between events

***Lead and lag
SELECT date,
lag(date) OVER (ORDER BY date),
lead(date) OVER (ORDER BY date)
FROM sales;

***Lead and lag
SELECT date,
lag(date) OVER (ORDER BY date),
lead(date) OVER (ORDER BY date)
FROM sales;

***Time between events
SELECT date,
date - lag(date) OVER (ORDER BY date) AS gap
FROM sales;

***Average time between events
SELECT avg(gap)
FROM (SELECT date - lag(date) OVER (ORDER BY date) AS gap
FROM sales) AS gaps;
avg
-----------------
00:32:15.555556
(1 row)

***Change in a time series
SELECT date,
amount,
lag(amount) OVER (ORDER BY date),
amount - lag(amount) OVER (ORDER BY date) AS change
FROM sales;


#---------------------------------------------------------------------
Longest gap
What is the longest time between Evanston 311 requests being submitted?

Recall the syntax for lead() and lag():

lag(column_to_adjust) OVER (ORDER BY ordering_column)
lead(column_to_adjust) OVER (ORDER BY ordering_column)

-- Compute the gaps
WITH request_gaps AS (
        SELECT date_created,
               -- lead or lag
               lag(date_created) OVER (ORDER BY date_created) AS previous,
               -- compute gap as date_created minus lead or lag
               date_created - lag(date_created) OVER (ORDER BY date_created) AS gap
          FROM evanston311)
-- Select the row with the maximum gap
SELECT *
  FROM request_gaps
-- Subquery to select maximum gap from request_gaps
 WHERE gap = (SELECT MAX(gap)
                FROM request_gaps);
              
#---------------------------------------------------------------------

Rats!
Requests in category "Rodents- Rats" average over 64 days to resolve. Why?

Investigate in 4 steps:

Why is the average so high? Check the distribution of completion times. Hint: date_trunc() can be used on intervals.

See how excluding outliers influences average completion times.

Do requests made in busy months take longer to complete? Check the correlation between the average completion time and requests per month.

Compare the number of requests created per month to the number completed.

Remember: the time to resolve, or completion time, is date_completed - date_created.

step01
-- Truncate the time to complete requests to the day
SELECT date_trunc('day', date_completed - date_created) AS completion_time,
-- Count requests with each truncated time
       count(*)
  FROM evanston311
-- Where category is rats
 WHERE category = 'Rodents- Rats'
-- Group and order by the variable of interest
 GROUP BY completion_time
 ORDER BY count;

 step02
 SELECT category, 
       -- Compute average completion time per category
       avg(date_completed - date_created) AS avg_completion_time
  FROM evanston311
-- Where completion time is less than the 95th percentile value
 WHERE date_completed - date_created < 
-- Compute the 95th percentile of completion time in a subquery
         (SELECT percentile_disc(0.95) WITHIN GROUP (ORDER BY date_completed - date_created)
            FROM evanston311)
 GROUP BY category
-- Order the results
 ORDER BY avg_completion_time DESC;

 step03
 -- Compute correlation (corr) between 
-- avg_completion time and count from the subquery
SELECT corr(avg_completion, count)
  -- Convert date_created to its month with date_trunc
  FROM (SELECT date_trunc('month', date_created) AS month, 
               -- Compute average completion time in number of seconds           
               avg(EXTRACT(epoch FROM date_completed - date_created)) AS avg_completion, 
               -- Count requests per month
               count(*) AS count
          FROM evanston311
         -- Limit to rodents
         WHERE category='Rodents- Rats' 
         -- Group by month, created above
         GROUP BY month) 
         -- Required alias for subquery 
         AS monthly_avgs;


step04
-- Compute monthly counts of requests created
WITH created AS (
       SELECT date_trunc('month', date_created) AS month,
              count(*) AS created_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month),
-- Compute monthly counts of requests completed
      completed AS (
       SELECT date_trunc('month', date_completed) AS month,
              count(*) AS completed_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month)
-- Join monthly created and completed counts
SELECT created.month, 
       created_count,
       completed_count
  FROM created
       INNER JOIN completed
       ON created.month=completed.month
 ORDER BY created.month;


whap-up

Parting tips
Spend time exploring your data
Use the PostgreSQL documentation
Be curious
Check data distributions 

END


*/