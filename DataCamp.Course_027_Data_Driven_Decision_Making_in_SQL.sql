/*

######################################################################
######################################################################
######################################################################

# COURSE 027_Data-Driven Decision Making in SQL

Aim of this course
    A short review of SQL know-how
    Apply your SQL know-how to extract business insights from data
    Learn about new SQL statements to summarize data
        OLAP extensions were developed specifically for business intelligence
        Examples are CUBE, ROLLUP and GROUPING SETS

MovieNow: an online movie rental company
    Platform to stream movies
    Additional information for each movie: genre, main actors, etc.
    Customer information
    Customers can give a rating after watching a movie

######################################################################
######################################################################
######################################################################

######## Introduction to business intelligence for a online movie rental database (Module 01-027)
######################################################################

video

Objectives of data driven decision making
    Information for operational decisions
        Popularity of actors to decide which movies to invest in.
        Revenue of the last months to estimate budget for short term investments.
    Information for strategic decisions
        Success across countries to decide on market extensions.
        Longterm development of revenue for long term investments.

KPIs: Key Performance Indicators
    Extract information from the data which is relevant to measure the success of MovieNow.
        Total number of rentals: revenue
        The average rating of all movies: customer satisfaction
        Number of active customers: customer engagement

#---------------------------------------------------------------------
Exploring the table renting
The table renting includes all records of movie rentals. Each record has a unique ID renting_id. It also contains information about customers (customer_id) and which movies they watched (movie_id). Furthermore, customers can give a rating after watching the movie, and the day the movie was rented is recorded.

step01
SELECT *  -- Select all
FROM renting;        -- From table renting

step02
SELECT movie_id,  -- Select all columns needed to compute the average rating per movie
       rating
FROM renting;

step03
answered

#---------------------------------------------------------------------
video
Filtering and
ordering

***WHERE
Select all customers from Italy:
SELECT *
FROM customers
WHERE country = 'Italy';

***Operators in the WHERE clause
Comparison operators:
Equal =
Not equal <>
Less than <
Less than or equal to <=
Greater than >
Greater than or equal to >=
BETWEEN operator
IN operator
IS NULL and IS NOT NULL operators

***Example comparison operators
Select all columns from movies where the genre is not Drama.
SELECT *
FROM movies
WHERE genre <> 'Drama';
Select all columns from movies where the price for renting is larger equal 2.
SELECT *
FROM movies
WHERE renting_price >= 2;

***Example: BETWEEN operator
Select all columns of customers where the date when the account was created is between 2018-01-
01 and 2018-08-31.
SELECT *
FROM customers
WHERE date_account_start BETWEEN '2018-01-01' AND '2018-09-31';

***Example: IN operator
Select all actors with nationality USA or Australia.
SELECT *
FROM actors
WHERE nationality IN ('USA', 'Australia')

***Example: NULL operator
Select all columns from renting where rating is NULL .
SELECT *
FROM renting
WHERE rating IS NULL
Select all columns from renting where rating is not NULL .
SELECT *
FROM renting
WHERE rating IS NOT NULL

***Boolean operators AND
Select customer name and the date when they created their account for customers who are from Italy
AND who created an account between 2018-01-01 and 2018-08-31.
SELECT name, date_account_start
FROM customers
WHERE country = 'Italy'
AND date_account_start BETWEEN '2018-01-01' AND '2018-08-31';

***Boolean operators OR
Select customer name and the date when they created their account for customers who are from Italy
OR who created an account between 2018-01-01 and 2018-08-31.
SELECT name, date_account_start
FROM customers
WHERE country = 'Italy'
OR date_account_start BETWEEN '2018-01-01' AND '2018-08-31';

***ORDER BY
Order the results of a query by rating.
SELECT *
FROM renting
WHERE rating IS NOT NULL
ORDER BY rating;

***ORDER BY ... DESC
Order the results of a query by rating in descending order.
SELECT *
FROM renting
WHERE rating IS NOT NULL
ORDER BY rating DESC;

#---------------------------------------------------------------------
Working with dates
For the analysis of monthly or annual changes, it is important to select data from specific time periods. You will select records from the table renting of movie rentals. The format of dates is 'YYYY-MM-DD'.

step01
SELECT *
FROM renting
WHERE date_renting = '2018-10-09'; -- Movies rented on October 9th, 2018

step02
SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31'; -- from beginning April 2018 to end August 2018

step03
SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31'
ORDER BY date_renting DESC; -- Order by recency in decreasing order

#---------------------------------------------------------------------
Selecting movies
The table movies contains all movies available on the online platform.

step01
SELECT *
FROM movies
WHERE genre <> 'Drama'; -- All genres except drama

step02
SELECT *
FROM movies
WHERE title IN ('Showtime', 'Love Actually', 'The Fighter'); -- Select all movies with the given titles

step03
SELECT *
FROM movies
ORDER BY renting_price ASC ; -- Order the movies by increasing renting price

#---------------------------------------------------------------------
Select from renting
Only some users give a rating after watching a movie. Sometimes it is interesting to explore only those movie rentals where a rating was provided.

SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31' -- Renting in 2018
AND rating IS NOT NULL; -- Rating exists

#---------------------------------------------------------------------
Aggregations -
summarizing data

***Overview aggregations
SELECT AVG(renting_price)
FROM movies;
Some aggregate functions in SQL
AVG()
SUM()
COUNT()
MIN()
MAX()

***Aggregation with NULL values
SELECT COUNT(*)
FROM actors;
Result: 145
SELECT COUNT(name)
FROM actors;
Result: 145
SELECT COUNT(year_of_birth)
FROM actors;
Result: 143

***DISTINCT
SELECT DISTINCT country
FROM customers;

SELECT COUNT(DISTINCT country)
FROM customers;

***DISTINCT with `NULL` values
SELECT DISTINCT rating
FROM renting
ORDER BY rating;

***Give an alias to column names
SELECT AVG(renting_price) AS average_price,
COUNT(DISTINCT genre) AS number_genres
FROM movies;

#---------------------------------------------------------------------
Summarizing customer information
In most business decisions customers are analyzed in groups, such as customers per country or customers per age group.

step01
SELECT COUNT(*) -- Count the total number of customers
FROM customers
WHERE date_of_birth BETWEEN '1980-01-01' AND '1989-12-31'; -- Select customers born between 1980-01-01 and 1989-12-31

STEP02
SELECT COUNT(*)   -- Count the total number of customers
FROM customers
WHERE country = 'Germany'; -- Select all customers from Germany

STEP03
SELECT COUNT(DISTINCT country) -- Count the number of countries
FROM customers;

#---------------------------------------------------------------------
Ratings of movie 25
The movie ratings give us insight into the preferences of our customers. Report summary statistics, such as the minimum, maximum, average, and count, of ratings for the movie with ID 25.

SELECT MIN(rating) AS min_rating, -- Calculate the minimum rating and use alias min_rating
	   MAX(rating) AS max_rating, -- Calculate the maximum rating and use alias max_rating
	   AVG(rating) AS avg_rating, -- Calculate the average rating and use alias avg_rating
	   COUNT(rating) AS number_ratings -- Count the number of ratings and use alias number_ratings
FROM renting
WHERE movie_id = 25; -- Select all records of the movie with ID 25

#---------------------------------------------------------------------
Examining annual rentals
You are asked to provide a report about the development of the company. Specifically, your manager is interested in the total number of movie rentals, the total number of ratings and the average rating of all movies since the beginning of 2019.

STEP01
SELECT * -- Select all records of movie rentals since January 1st 2019
FROM renting
WHERE date_renting BETWEEN '2019-01-01' AND NOW(); 

STEP02
SELECT 
	COUNT(*), -- Count the total number of rented movies
	AVG(rating) -- Add the average rating
FROM renting
WHERE date_renting >= '2019-01-01';

STEP03
SELECT 
	COUNT(*) AS number_renting, -- Give it the column name number_renting
	AVG(rating) AS average_rating  -- Give it the column name average_rating
FROM renting
WHERE date_renting >= '2019-01-01';

STEP04
SELECT 
	COUNT(*) AS number_renting,
	AVG(rating) AS average_rating, 
    COUNT(rating) AS number_ratings -- Add the total number of ratings here.
FROM renting
WHERE date_renting >= '2019-01-01';

######################################################################
######################################################################
######################################################################

######## Decision Making with simple SQL queries (Module 02-027)
######################################################################
VIDEO
Grouping movies

***GROUP BY Applications
Preferences of customers by country or gender.
The popularity of movies by genre or year of release.
The average price of movies by genre.

***GROUP BY
SELECT genre
FROM movies_selected
GROUP BY genre;

***Average renting price
SELECT genre,
AVG(renting_price) AS avg_price
FROM movies_selected
GROUP BY genre;

***Average rental price and number of movies
SELECT genre,
AVG(renting_price) AS avg_price,
COUNT(*) AS number_movies
FROM movies_selected
GROUP BY genre

***HAVING
SELECT genre,
AVG(renting_price) avg_price,
COUNT(*) number_movies
FROM movies
GROUP BY genre
HAVING COUNT(*) > 2;

#---------------------------------------------------------------------
First account for each country.
Conduct an analysis to see when the first customer accounts were created for each country.

SELECT country, -- For each country report the earliest date when an account was created
	MIN(date_account_start) AS first_account
FROM customers
GROUP BY country
ORDER BY country ASC;

#---------------------------------------------------------------------
Average movie ratings
For each movie the average rating, the number of ratings and the number of views has to be reported. Generate a table with meaningful column names.

STEP01
SELECT movie_id, 
       AVG(rating)    -- Calculate average rating per movie
FROM renting
GROUP BY movie_id;

STEP02
SELECT movie_id, 
       AVG(rating) AS avg_rating, -- Use as alias avg_rating
       COUNT(rating) AS number_rating,                -- Add column for number of ratings with alias number_rating
       COUNT(*) AS number_renting                 -- Add column for number of movie rentals with alias number_renting
FROM renting
GROUP BY movie_id;

STEP03
SELECT movie_id, 
       AVG(rating) AS avg_rating,
       COUNT(rating) AS number_ratings,
       COUNT(*) AS number_renting
FROM renting
GROUP BY movie_id
ORDER BY avg_rating DESC; -- Order by average rating in decreasing order

#---------------------------------------------------------------------
Average rating per customer
Similar to what you just did, you will now look at the average movie ratings, this time for customers. So you will obtain a table with the average rating given by each customer. Further, you will include the number of ratings and the number of movie rentals per customer. You will report these summary statistics only for customers with more than 7 movie rentals and order them in ascending order by the average rating.

SELECT customer_id, -- Report the customer_id
      AVG(rating),  -- Report the average rating per customer
      COUNT(rating),  -- Report the number of ratings per customer
      COUNT(*)  -- Report the number of movie rentals per customer
FROM renting
GROUP BY customer_id
HAVING COUNT(*) > 7 -- Select only customers with more than 7 movie rentals
ORDER BY AVG ASC; -- Order by the average rating in ascending order

#---------------------------------------------------------------------
VIDEO
Joining movie ratings with customer data

***LEFT JOIN
LEFT JOIN is an outer join.
Keep all rows of the left table, match with rows in the right table.
Use identi

***Giving a table a name
SELECT *
FROM customers AS c
WHERE c.customer_id = 1;

***Tables for LEFT JOIN
Left table: renting_selected
Right table: customers_selected

***LEFT JOIN example
SELECT *
FROM renting_selected AS r
LEFT JOIN customers_selected AS c
ON r.customer_id = c.customer_id;

***More than one JOIN
SELECT m.title,
c.name
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id;

#---------------------------------------------------------------------
Join renting and customers
For many analyses it is necessary to add customer information to the data in the table renting.

STEP01
SELECT * -- Join renting with customers
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id;;

STEP02
SELECT *
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
WHERE C.country = 'Belgium'; -- Select only records from customers coming from Belgium

STEP03
SELECT AVG(r.rating) -- Average ratings of customers from Belgium
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
WHERE c.country='Belgium';

#---------------------------------------------------------------------
Aggregating revenue, rentals and active customers
The management of MovieNow wants to report key performance indicators (KPIs) for the performance of the company in 2018. They are interested in measuring the financial successes as well as user engagement. Important KPIs are, therefore, the profit coming from movie rentals, the number of movie rentals and the number of active customers.

step01
SELECT *
FROM renting AS r
LEFT JOIN movies AS m -- Choose the correct join statment
ON r.movie_id = m.movie_id;

step02
SELECT 
	SUM(m.renting_price), -- Get the revenue from movie rentals
	COUNT(*), -- Count the number of rentals
	COUNT(DISTINCT r.customer_id)  -- Count the number of customers
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id;

step03
SELECT 
	SUM(m.renting_price), 
	COUNT(*), 
	COUNT(DISTINCT r.customer_id)
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
-- Only look at movie rentals in 2018
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31';

#---------------------------------------------------------------------
Movies and actors
You are asked to give an overview of which actors play in which movie.

SELECT m.title, -- Create a list of movie titles and actor names
       a.name
FROM actsin AS ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
LEFT JOIN actors AS a
ON a.actor_id = ai.actor_id;

#---------------------------------------------------------------------
Money spent per customer with sub-queries

***Subsequent SELECT statements - actresses
Query 1:
SELECT *
FROM actors
WHERE gender = 'female';

***SELECT * -- Query 1
FROM actors
WHERE gender = 'female';
Group result table of query 1 by nationality.
Report year of birth for the oldest and youngest actress in each country.
SELECT af.nationality,
MIN(af.year_of_birth),
MAX(af.year_of_birth)
FROM
(SELECT *
FROM actors
WHERE gender = 'female') AS af
GROUP BY af.nationality;

***Result subsequent SELECT statement - actresses
SELECT af.nationality,
MIN(af.year_of_birth),
MAX(af.year_of_birth)
FROM
(SELECT *
FROM actors
WHERE gender = 'female') AS af
GROUP BY af.nationality;
| nationality | min | max |
|-------------|------|------|
| Italy | 1976 | 1976 |
| Iran | 1952 | 1952 |
| USA | 1945 | 1993 |

***How much money did each customer spend?
First step: Add renting_price from movies to table renting .
SELECT r.customer_id,
m.renting_price
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id=m.movie_id;
| customer_id | renting_price |
|-------------|---------------|
| 41 | 2.59 |
| 10 | 2.79 |
| 108 | 2.39 |
| 39 | 1.59 |
| 104 | 1.69 |

***How much money did each customer spend?
Second step:
group result table from  first step
take the sum of renting_price
SELECT rm.customer_id,
SUM(rm.renting_price)
FROM
(SELECT r.customer_id,
m.renting_price
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id=m.movie_id) AS rm
GROUP BY rm.customer_id;

***How much money did each customer spend?
| customer_id | sum |
|-------------|-------|
| 116 | 7.47 |
| 87 | 17.53 |
| 71 | 6.87 |
| 68 | 1.59 |
| 51 | 4.87 |

#---------------------------------------------------------------------
Income from movies
How much income did each movie generate? To answer this question subsequent SELECT statements can be used.

step01
SELECT m.title, -- Use a join to get the movie title and price for each movie rental
       m.renting_price
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id;

step02
SELECT rm.title, -- Report the income from movie rentals for each movie 
       SUM(rm.renting_price) AS income_movie
FROM
       (SELECT m.title, 
               m.renting_price
       FROM renting AS r
       LEFT JOIN movies AS m
       ON r.movie_id=m.movie_id) AS rm
GROUP BY rm.title
ORDER BY income_movie DESC; -- Order the result by decreasing income

#---------------------------------------------------------------------
Age of actors from the USA
Now you will explore the age of American actors and actresses. Report the date of birth of the oldest and youngest US actor and actress.

SELECT a.gender, -- Report for male and female actors from the USA 
       MIN(a.year_of_birth), -- The year of birth of the oldest actor
       MAX(a.year_of_birth) -- The year of birth of the youngest actor
FROM
   (SELECT gender, year_of_birth-- Use a subsequen SELECT to get all information about actors from the USA
   FROM actors
   WHERE nationality = 'USA') AS a -- Give the table the name a
GROUP BY a.gender;

#---------------------------------------------------------------------
video
Identify favorite actors of customer groups

***Combining SQL statements in one query
LEFT JOIN
WHERE
GROUP BY
HAVING
ORDER BY

***From renting records to customer and actor
information
Our question: Who is the favorite actor for a
certain customer group?
Join table renting with tables
customers
actsin
actors

SELECT *
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id;


***Male customers
Actors which play most often in movies watched by male customers.
SELECT a.name,
COUNT(*)
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id
WHERE c.gender = 'male'
GROUP BY a.name;

***Who is the favorite actor?
Actor being watched most often.
Best average rating when being watched.
SELECT a.name,
COUNT(*) AS number_views,
AVG(r.rating) AS avg_rating
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id

***Add HAVING and ORDER BY
SELECT a.name,
COUNT(*) AS number_views,
AVG(r.rating) AS avg_rating
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id
WHERE c.gender = 'male'
GROUP BY a.name
HAVING AVG(r.rating) IS NOT NULL
ORDER BY avg_rating DESC, number_views DESC;

***Add HAVING and ORDER BY
| name | number_views | avg_rating |
|--------------------|--------------|------------|
| Ray Romano | 3 | 10.00 |
| Sean Bean | 2 | 10.00 |
| Leonardo DiCaprio | 3 | 9.33 |
| Christoph Waltz | 3 | 9.33 |

#---------------------------------------------------------------------
Identify favorite movies for a group of customers
Which is the favorite movie on MovieNow? Answer this question for a specific group of customers: for all customers born in the 70s.

step01
SELECT *
FROM renting AS r
LEFT JOIN customers AS c   -- Add customer information
ON r.customer_id = c.customer_id
LEFT JOIN movies AS m  -- Add movie information
ON r.movie_id = m.movie_id;

step02
SELECT *
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'; -- Select customers born in the 70s

step03
SELECT m.title, 
COUNT(*), -- Report number of views per movie
AVG(r.rating) -- Report the average rating per movie
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
GROUP BY m.title;

step04
SELECT m.title, 
COUNT(*),
AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
GROUP BY m.title
HAVING COUNT(*) > 1 -- Remove movies with only one rental
ORDER BY AVG DESC; -- Order with highest rating first

#---------------------------------------------------------------------
Identify favorite actors for Spain
You're now going to explore actor popularity in Spain. Use as alias the first letter of the table, except for the table actsin use ai instead.

step01
SELECT *
FROM renting AS r 
LEFT JOIN customers AS c  -- Augment table renting with information about customers 
ON r.customer_id = c.customer_id
LEFT JOIN actsin AS ai  -- Augment the table renting with the table actsin
ON r.movie_id = ai.movie_id
LEFT JOIN actors AS a  -- Augment table renting with information about actors
ON ai.actor_id = a.actor_id;

step02
SELECT a.name,  c.gender,
       COUNT(*) AS number_views, 
       AVG(r.rating) AS avg_rating
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id

GROUP BY a.name, c.gender -- For each actor, separately for male and female customers
HAVING AVG(r.rating) IS NOT NULL 
AND COUNT(*) > 5 -- Report only actors with more than 5 movie rentals
ORDER BY avg_rating DESC, number_views DESC;

step03
SELECT a.name,  c.gender,
       COUNT(*) AS number_views, 
       AVG(r.rating) AS avg_rating
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id
WHERE c.country = 'Spain' -- Select only customers from Spain
GROUP BY a.name, c.gender
HAVING AVG(r.rating) IS NOT NULL 
  AND COUNT(*) > 5 
ORDER BY avg_rating DESC, number_views DESC;

#---------------------------------------------------------------------
KPIs per country
In chapter 1 you were asked to provide a report about the development of the company. This time you have to prepare a similar report with KPIs for each country separately. Your manager is interested in the total number of movie rentals, the average rating of all movies and the total revenue for each country since the beginning of 2019.

step01
SELECT *
FROM renting as r -- Augment the table renting with information about customers
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN movies AS m -- Augment the table renting with information about movies
ON m.movie_id = r.movie_id
WHERE date_renting >= '2019-01-01'; -- Select only records about rentals since the beginning of 2019

step02
SELECT 
	c.country,                    -- For each country report
	COUNT(*) AS number_renting, -- The number of movie rentals
	AVG(r.rating) AS average_rating, -- The average rating
	SUM(renting_price) AS revenue         -- The revenue from movie rentals
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE date_renting >= '2019-01-01'
GROUP BY c.country;

######################################################################
######################################################################
######################################################################

######## Data Driven Decision Making with advanced SQL queries (Module 03-027)
######################################################################
video
Nested query

***Nested query
SELECT block in WHERE or HAVING clauses
Inner query returns single or multiple values
Use result from the inner query to select speci

***The inner query
Step 1: The inner query
SELECT DISTINCT customer_id
FROM renting
WHERE rating <= 3CO

***Result in the WHERE clause
SELECT name
FROM customers
WHERE customer_id IN (28, 41, 86, 120);

***The outer query
Step 2: The outer query
SELECT name
FROM customers
WHERE customer_id IN
(SELECT DISTINCT customer_id
FROM renting
WHERE rating <= 3);

***Nested query in the HAVING clause
Step 1: The inner query
SELECT MIN(date_account_start)
FROM customers
WHERE country = 'Austria';

***Nested query in the HAVING clause
Step 2: The outer query
SELECT country, MIN(date_account_start)
FROM customers
GROUP BY country
HAVING MIN(date_account_start) <
(SELECT MIN(date_account_start)
FROM customers
WHERE country = 'Austria');

***Who are the actors in the movie Ray?
SELECT name
FROM actors
WHERE actor_id IN
(SELECT actor_id
FROM actsin
WHERE movie_id =
(SELECT movie_id
FROM movies
WHERE title='Ray'));

#---------------------------------------------------------------------
Often rented movies
Your manager wants you to make a list of movies excluding those which are hardly ever watched. This list of movies will be used for advertising. List all movies with more than 5 views using a nested query which is a powerful tool to implement selection conditions.

step01
SELECT movie_id -- Select movie IDs with more than 5 views
FROM renting
GROUP BY movie_id
HAVING COUNT(*) > 5

step02
SELECT *
FROM movies
WHERE movie_id IN  -- Select movie IDs from the inner query
	(SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(*) > 5)

#---------------------------------------------------------------------
Frequent customers
Report a list of customers who frequently rent movies on MovieNow.

SELECT *
FROM customers
WHERE customer_id IN            -- Select all customers with more than 10 movie rentals
	(SELECT customer_id
	FROM renting
	GROUP BY customer_id
	HAVING COUNT(*) > 10);

#---------------------------------------------------------------------
Movies with rating above average
For the advertising campaign your manager also needs a list of popular movies with high ratings. Report a list of movies with rating above average.

STEP01
SELECT AVG(rating) -- Calculate the total average rating
FROM renting

STEP02
SELECT movie_id, -- Select movie IDs and calculate the average rating 
       AVG(rating)
FROM renting
GROUP BY movie_id
HAVING AVG(rating) >        -- Of movies with rating above average
	(SELECT AVG(rating)
	FROM renting);

STEP03
SELECT title -- Report the movie titles of all movies with average rating higher than the total average
FROM movies
WHERE movie_id IN
	(SELECT movie_id
	 FROM renting
     GROUP BY movie_id
     HAVING AVG(rating) > 
		(SELECT AVG(rating)
		 FROM renting));

#---------------------------------------------------------------------
video
Correlated nested
queries

***Correlated queries
Condition in the WHERE clause of the inner query.
References some column of a table in the outer query.

***Example correlated query
Number of movie rentals more than 5
SELECT *
FROM movies as m
WHERE 5 <
(SELECT COUNT(*)
FROM renting as r
WHERE r.movie_id=m.movie_id);

***Evaluate inner query
SELECT COUNT(*)
FROM renting as r
WHERE r.movie_id = 1;
| count |
|-------|
| 8 |

***Evaluate outer query
Number of movie rentals larger than 5
SELECT *
FROM movies as m
WHERE 5 <
(SELECT COUNT(*)
FROM renting as r
WHERE r.movie_id = m.movie_id);

***Less than 5 movie rentals
Select movies with less than 5 movie rentals.
SELECT *
FROM movies as m
WHERE 5 >
(SELECT COUNT(*)
FROM renting as r
WHERE r.movie_id = m.movie_id);


#---------------------------------------------------------------------
Analyzing customer behavior
A new advertising campaign is going to focus on customers who rented fewer than 5 movies. Use a correlated query to extract all customer information for the customers of interest.

step01
-- Count movie rentals of customer 45
SELECT COUNT(*)
FROM renting AS r
WHERE customer_id=45;

step02
-- Select customers with less than 5 movie rentals
SELECT *
FROM customers as c
WHERE 5 >
	(SELECT count(*)
	FROM renting as r
	WHERE r.customer_id = c.customer_id);

#---------------------------------------------------------------------
Customers who gave low ratings
Identify customers who were not satisfied with movies they watched on MovieNow. Report a list of customers with minimum rating smaller than 4.

step01
-- Calculate the minimum rating of customer with ID 7
SELECT MIN(rating)
FROM renting
WHERE customer_id = 7;

step02
SELECT *
FROM customers AS c
WHERE 4 > -- Select all customers with a minimum rating smaller than 4 
	(SELECT MIN(rating)
	FROM renting AS r
	WHERE r.customer_id = c.customer_id);

#---------------------------------------------------------------------
Movies and ratings with correlated queries
Report a list of movies that received the most attention on the movie platform, (i.e. report all movies with more than 5 ratings and all movies with an average rating higher than 8).

STEP01
SELECT *
FROM movies AS m
WHERE 5 < -- Select all movies with more than 5 ratings
	(SELECT COUNT(rating)
	FROM renting AS r
	WHERE r.movie_id = m.movie_id);

STEP02
SELECT *
FROM movies AS m
WHERE 8 < -- Select all movies with an average rating higher than 8
	(SELECT AVG(rating)
	FROM renting AS r
	WHERE r.movie_id = m.movie_id);


#---------------------------------------------------------------------
VIDEO
Queries with EXISTS

EXISTS
Special case of a correlated nested query.
Used to check if result of a correlated nested query is empty.
It returns: TRUE or FALSE
TRUE = not empty -> row of the outer query is selected.
FALSE = empty
Columns specified in SELECT component not considered - use SELECT *

Movies with at least one rating
SELECT *
FROM movies AS m
WHERE EXISTS
(SELECT *
FROM renting AS r
WHERE rating IS NOT NULL
AND r.movie_id = m.movie_id);

Movies with at least one rating
SELECT *
FROM renting AS r
WHERE rating IS NOT NULL
AND r.movie_id = 11;
| renting_id | customer_id | movie_id | rating | renting_price |
|------- ----|-------------|----------|--------|---------------|

Movies with at least one rating
SELECT *
FROM renting AS r
WHERE rating IS NOT NULL
AND r.movie_id = 1;
| renting_id | customer_id | movie_id | rating | renting_price |
|------------|-------------|----------|--------|---------------|
| 71 | 111 | 1 | 5 | 2018-07-21 |
| 170 | 36 | 1 | 10 | 2018-10-18 |

EXISTS query with result
SELECT *
FROM movies AS m
WHERE EXISTS
(SELECT *
FROM renting AS r
WHERE rating IS NOT NULL
AND r.movie_id = m.movie_id);
| movie_id | title | genre | runtime | year_of_release | renting_price
|----------|-----------------------|--------|---------|-----------------|---------------
| 1 | One Night at McCool's | Comedy | 93 | 2001 | 2.09
| 2 | Swordfish | Drama | 99 | 2001 | 2.19

NOT EXISTS
TRUE = table is empty -> row of the outer query is selected.
SELECT *
FROM movies AS m
WHERE NOT EXISTS
(SELECT *
FROM renting AS r
WHERE rating IS NOT NULL
AND r.movie_id = m.movie_id);
| movie_id | title | genre | runtime | year_of_release | renting_price |
|----------|----------|--------|---------|-----------------|---------------|
| 11 | Showtime | Comedy | 95 | 2002 | 1.79 |

#---------------------------------------------------------------------

Customers with at least one rating
Having active customers is a key performance indicator for MovieNow. Make a list of customers who gave at least one rating.

step01
-- Select all records of movie rentals from customer with ID 115
SELECT *
FROM renting
WHERE customer_id = 115;

step02
SELECT *
FROM renting
WHERE rating IS NOT NULL -- Exclude those with null ratings
AND customer_id = 115;

step03
SELECT *
FROM renting
WHERE rating IS NOT NULL -- Exclude null ratings
AND customer_id = 1; -- Select all ratings from customer with ID 1

step04
SELECT *
FROM customers AS c -- Select all customers with at least one rating
WHERE EXISTS
	(SELECT *
	FROM renting AS r
	WHERE rating IS NOT NULL 
	AND r.customer_id = c.customer_id);

#---------------------------------------------------------------------
Actors in comedies
In order to analyze the diversity of actors in comedies, first, report a list of actors who play in comedies and then, the number of actors for each nationality playing in comedies.

step01
SELECT *  -- Select the records of all actors who play in a Comedy
FROM actsin AS ai
LEFT JOIN movies AS m
ON ai.movie_id = m.movie_id
WHERE m.genre = 'Comedy';

step02
SELECT *
FROM actsin AS ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
WHERE m.genre = 'Comedy'
AND ai.actor_id = 1; -- Select only the actor with ID 1

step03
SELECT *
FROM actors AS a
WHERE EXISTS
	(SELECT *
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id);

step04
SELECT a.nationality, COUNT(*) -- Report the nationality and the number of actors for each nationality
FROM actors AS a
WHERE EXISTS
	(SELECT ai.actor_id
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id)
GROUP BY a.nationality;

#---------------------------------------------------------------------
Queries with UNION
and INTERSECT

***UNION

Example - UNION
SELECT title,
genre,
renting_price
FROM movies
WHERE renting_price > 2.8
UNION
SELECT title,
genre,
renting_price
FROM movies
WHERE genre = 'Action & Adventure';

SELECT title,
genre,
renting_price
FROM movies
WHERE renting_price > 2.8
UNION
SELECT title,
genre,
renting_price
FROM movies
WHERE genre = 'Action & Adventure';
| title | genre | renting_price |
|------------|--------------------|---------------|
|Fool's Gold | Action & Adventure | 2.69 |
|Astro Boy | Action & Adventure | 2.89 |
|Fair Game | Drama | 2.89 |

***INTERSECT
Example - INTERSECT
SELECT title,
genre,
renting_price
FROM movies
WHERE renting_price > 2.8
INTERSECT
SELECT title,
genre,
renting_price
FROM movies
WHERE genre = 'Action & Adventure';
| title | genre | renting_price |
|-----------|--------------------|---------------|
| Astro Boy | Action & Adventure | 2.89 |

#---------------------------------------------------------------------
Young actors not coming from the USA
As you've just seen, the operators UNION and INTERSECT are powerful tools when you work with two or more tables. Identify actors who are not from the USA and actors who were born after 1990.

step01
SELECT name,  -- Report the name, nationality and the year of birth
       nationality, 
       year_of_birth
FROM actors
WHERE nationality != 'USA'; -- Of all actors who are not from the USA

step02
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990; -- Born after 1990

step03
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
UNION -- Select all actors who are not from the USA and all actors who are born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;

step04
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
INTERSECT -- Select all actors who are not from the USA and who are also born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;

#---------------------------------------------------------------------
Dramas with high ratings
The advertising team has a new focus. They want to draw the attention of the customers to dramas. Make a list of all movies that are in the drama genre and have an average rating higher than 9.

step01
SELECT movie_id -- Select the IDs of all dramas
FROM movies
WHERE genre = 'Drama';

step02
SELECT movie_id, AVG(rating) -- Select the IDs of all movies with average rating higher than 9
FROM renting
GROUP BY movie_id
HAVING AVG(rating) > 9;

step03
SELECT movie_id
FROM movies
WHERE genre = 'Drama'
INTERSECT  -- Select the IDs of all dramas with average rating higher than 9
SELECT movie_id
FROM renting
GROUP BY movie_id
HAVING AVG(rating)>9;

step04
SELECT *
FROM movies
WHERE movie_id IN  -- Select all movies of genre drama with average rating higher than 9
   (SELECT movie_id
    FROM movies
    WHERE genre = 'Drama'
    INTERSECT
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING AVG(rating)>9);

######################################################################
######################################################################
######################################################################

######## Data Driven Decision Making with OLAP SQL queries (Module 04-027)
######################################################################

OLAP: CUBE operator

***Introduction to OLAP
OLAP: on-line analytical processing
Aggregate data for a better overview
Count number of rentings for each customer.
Average rating of movies for each genre and each country.
Produce pivot tables to present aggregation results

***Table rentings_extended
| renting_id | country | genre | rating |
|------------|---------|--------|--------|
| 2 | Belgium | Drama | 10 |
| 32 | Belgium | Drama | 10 |
| 203 | Austria | Drama | 6 |
| 292 | Austria | Comedy | 8 |
| 363 | Belgium | Drama | 7 |
| .......... | ....... | ..... | ...... |

***Pivot table - number of movie rentals

***Pivot table and SQL output

***GROUP BY CUBE
SELECT country,
genre,
COUNT(*)
FROM renting_extended
GROUP BY CUBE (country, genre);

country | genre | count |
|----------|--------|-------|
| Austria | Comedy | 2 |
| Belgium | Drama | 15 |
| Austria | Drama | 4 |
| Belgium | Comedy | 1 |
| Belgium | null | 16 |
| Austria | null | 6 |
| null | Comedy | 3 |
| null | Drama | 19 |
| null | null | 22 |

Number of ratings
SELECT country,
genre,
COUNT(rating)
FROM renting_extended
GROUP BY CUBE (country, genre);

country | genre | count |
|----------|--------|-------|
| Austria | Comedy | 1 |
| Belgium | Drama | 6 |
| Austria | Drama | 2 |
| Belgium | Comedy | 0 |
| Belgium | null | 6 |
| Austria | null | 3 |
| null | Comedy | 1 |
| null | Drama | 8 |
| null | null | 9 |

#---------------------------------------------------------------------
Groups of customers
Use the CUBE operator to extract the content of a pivot table from the database. Create a table with the total number of male and female customers from each country.

SELECT gender, -- Extract information of a pivot table of gender and country for the number of customers
	   country,
	   COUNT(*)
FROM customers
GROUP BY CUBE (gender, country)
ORDER BY country;

#---------------------------------------------------------------------
Categories of movies
Give an overview on the movies available on MovieNow. List the number of movies for different genres and release years.

step01
SELECT genre,
       year_of_release,
       COUNT(*)
FROM movies
GROUP BY CUBE (genre, year_of_release)
ORDER BY year_of_release;

step02
Well observed! Only one movie from 2014 is available on MovieNow. The highest number of movies is from 2003 with 8 movies.

#---------------------------------------------------------------------
Analyzing average ratings
Prepare a table for a report about the national preferences of the customers from MovieNow comparing the average rating of movies across countries and genres.

step01
-- Augment the records of movie rentals with information about movies and customers
SELECT *
FROM movies AS m
LEFT JOIN renting AS r
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id;

step02
-- Calculate the average rating for each country
SELECT 
       c.country,
       AVG(r.rating)
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY c.country;

step03
SELECT 
	c.country, 
	m.genre, 
	AVG(r.rating) AS avg_rating -- Calculate the average rating 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY CUBE(c.country, m.genre); -- For all aggregation levels of country and genre

#---------------------------------------------------------------------
video

ROLLUP
Table renting_extended
The 
| renting_id | country | genre | rating |
|------------|----------|--------|--------|
| 2 | Belgium | Drama | 10 |
| 32 | Belgium | Drama | 10 |
| 203 | Austria | Drama | 6 |
| 292 | Austria | Comedy | 8 |
| 363 | Belgium | Drama | 7 |
| .......... | ........ | ...... | ...... |

***Query with ROLLUP
SELECT country,
genre,
COUNT(*)
FROM renting_extended
GROUP BY ROLLUP (country, genre);
Levels of aggregation
Aggregation of each combination of country and genre
Aggregation of country alone
Total aggregation

| country | genre | count |
|---------|--------|-------|
| null | null | 22 |
| Austria | Comedy | 2 |
| Belgium | Drama | 15 |
| Austria | Drama | 4 |
| Belgium | Comedy | 1 |
| Belgium | null | 16 |
| Austria | null | 6 |

***Order in ROLLUP
SELECT country,
genre,
COUNT(*)
FROM renting_extended
GROUP BY ROLLUP (genre, country);

| country | genre | count |
|---------|--------|-------|
| null | null | 22 |
| Austria | Comedy | 2 |
| Belgium | Drama | 15 |
| Austria | Drama | 4 |
| Belgium | Comedy | 1 |
| null | Comedy | 3 |
| null | Drama | 19 |

***Summary ROLLUP
Returns aggregates for a hierarchy of values, e.g. ROLLUP (country, genre)
Movie rentals for each country and each genre
Movie rentals for each country
Total number of movie rentals
In each step, one level of detail is dropped
Order of column names is important for ROLLUP


***Number of rentals and ratings
SELECT country,
genre,
COUNT(*) AS n_rentals,
COUNT(rating) AS n_ratings
FROM renting_extended
GROUP BY ROLLUP (genre, country);
| country | genre | n_rentals | n_ratings |
|----------|--------|-----------|-----------|
| null | null | 22 | 9 |
| Belgium | Drama | 15 | 6 |
| Austria | Comedy | 2 | 1 |
| Belgium | Comedy | 1 | 0 |
| Austria | Drama | 4 | 2 |
| null | Comedy | 3 | 1 |
| null | Drama | 19 | 8 |


#---------------------------------------------------------------------
Number of customers
You have to give an overview of the number of customers for a presentation.

-- Count the total number of customers, the number of customers for each country, and the number of female and male customers for each country
SELECT country,
       gender,
	   COUNT(*)
FROM customers
GROUP BY ROLLUP  (country, gender)
ORDER BY country, gender; -- Order the result by country and gender

#---------------------------------------------------------------------
Analyzing preferences of genres across countries
You are asked to study the preferences of genres across countries. Are there particular genres which are more popular in specific countries? Evaluate the preferences of customers by averaging their ratings and counting the number of movies rented from each genre.

step01
-- Join the tables
SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id;

step02
SELECT 
	c.country, -- Select country
	m.genre, -- Select genre
	AVG(r.rating), -- Average ratings
	COUNT(*)  -- Count number of movie rentals
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY c.country, m.genre-- Aggregate for each country and each genre
ORDER BY c.country, m.genre;

step03
-- Group by each county and genre with OLAP extension
SELECT 
	c.country, 
	m.genre, 
	AVG(r.rating) AS avg_rating, 
	COUNT(*) AS num_rating
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY ROLLUP  (c.country, m.genre)
ORDER BY c.country, m.genre;

#---------------------------------------------------------------------
video

GROUPING SETS

***Overview of OLAP operators in SQL
Extensions in SQL to facilitate OLAP operations
GROUP BY CUBE
GROUP BY ROLLUP
GROUP BY GROUPING SETS

***Table renting_extended

***GROUP BY GROUPING SETS
Example of a query with GROUPING SETS operator:
SELECT country,
genre,
COUNT(*)
FROM rentings_extended
GROUP BY GROUPING SETS ((country, genre), (country), (genre), ());
Column names surrounded by parentheses represent one level of aggregation.
GROUP BY GROUPING SETS returns a UNION over several GROUP BY queries.

***GROUPING SETS and GROUP BY queries

1.

country,
genre,
COUNT(*)
FROM renting_extended
GROUP BY GROUPING SETS (country, genre);
Count movie rentals for each unique
combination of country and genre.
Expression in GROUPING SETS :
(country, genre)

vs

SELECT country,
genre,
COUNT(*)
FROM renting_extended
GROUP BY country, genre;
| country | genre | count |
|---------|--------|--------|
| Austria | Comedy | 2 |
| Belgium | Drama | 15 |
| Austria | Drama | 4 |
| Belgium | Comedy | 1 |


2.
SELECT country, COUNT(*)
FROM renting_extended
GROUP BY GROUPING SETS (country);
Count movie rentals for each country.
Expression in GROUPING SETS :
(country)

vs.

SELECT country, COUNT(*)
FROM renting_extended
GROUP BY country;
| country | count |
|---------|-------|
| Austria | 16 |
| Belgium | 6 |

3.

SELECT genre, COUNT(*)
FROM renting_extended
GROUP BY GROUPING SETS (genre);
Count movie rentals for each genre.
Expression in GROUPING SETS :
(genre)

vs.

SELECT genre, COUNT(*)
FROM renting_extended
GROUP BY genre;
| country | count |
|---------|-------|
| Comedy | 3 |
| Drama | 19 |

4.

SELECT COUNT(*)
FROM renting_extended
GROUP BY GROUPING SETS ();
Total aggregation - count all movie rentals.
Expression in GROUPING SETS : ()

vs. 

SELECT COUNT(*)
FROM renting_extended;
| count |
|-------|
| 22 |

***Notation for GROUP BY GROUPING SETS
GROUP BY GROUPING SETS (...)
SELECT country, genre, COUNT(*)
FROM renting_extended
GROUP BY GROUPING SETS ((country, genre), (country), (genre), ());
UNION over 4 previous queries.
Combine all information of a pivot table in one query.
This query is equivalent to GROUP BY CUBE (country, genre) .

***Result with GROUPING SETS operator
SELECT country, genre, COUNT(*)
FROM renting_extended
GROUP BY GROUPING SETS ((country, genre), (country), (genre), ());
| country | genre |count|
|---------|--------|-----|
| NULL | NULL | 22 |
| Austria | Comedy | 2 |
| Belgium | Drama | 15 |
| Austria | Drama | 4 |
| Belgium | Comedy | 1 |
| Belgium | NULL | 16 |
| Austria | NULL | 6 |
| NULL | Comedy | 3 |
| NULL | Drama | 19 |

***Calculate number of rentals and average rating
Combine only selected aggregations:
country and genre
genre
Use the number of movie rentals and the average ratings for aggregation.
SELECT country,
genre,
COUNT(*),
AVG(rating) AS avg_rating
FROM renting_extended
GROUP BY GROUPING SETS ((country, genre), (genre));

***Calculate number of rentals and average rating
SELECT country, genre, COUNT(*), AVG(rating) AS avg_rating
FROM renting_extended
GROUP BY GROUPING SETS ((country, genre), (genre));
| country | genre | count| avg_rating |
|---------|--------|------|------------|
| Austria | Comedy | 2 | 8.00 |
| Belgium | Drama | 15 | 9.17 |
| Austria | Drama | 4 | 6.00 |
| Belgium | Comedy | 1 | NULL |
| NULL | Comedy | 3 | 8.00 |
| NULL | Drama | 19 | 8.38 |

#---------------------------------------------------------------------
Queries with GROUPING SETS
What question CANNOT be answered by the following query?

SELECT 
  r.customer_id, 
  m.genre, 
  AVG(r.rating), 
  COUNT(*)
FROM renting AS r
LEFT JOIN movies AS m
ON r.movie_id = m.movie_id
GROUP BY GROUPING SETS ((r.customer_id, m.genre), (r.customer_id), ());

#---------------------------------------------------------------------
Exploring nationality and gender of actors
For each movie in the database, the three most important actors are identified and listed in the table actors. This table includes the nationality and gender of the actors. We are interested in how much diversity there is in the nationalities of the actors and how many actors and actresses are in the list.

SELECT 
	nationality, -- Select nationality of the actors
    gender, -- Select gender of the actors
    COUNT(*) -- Count the number of actors
FROM actors
GROUP BY GROUPING SETS ((nationality), (gender), ()); -- Use the correct GROUPING SETS operation

#---------------------------------------------------------------------
Exploring rating by country and gender
Now you will investigate the average rating of customers aggregated by country and gender.

step01
SELECT 
	c.country, -- Select country, gender and rating
    c.gender,
    r.rating
FROM renting AS r
LEFT JOIN customers AS c -- Use the correct join
ON r.customer_id = c.customer_id;

step02
SELECT 
	c.country, 
    c.gender,
	AVG(r.rating) -- Calculate average rating
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY c.country, c.gender -- Order and group by country and gender
ORDER BY c.country, c.gender;

step03
SELECT 
	c.country, 
    c.gender,
	AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY GROUPING SETS ((country, gender)) ; -- Group by country and gender with GROUPING SETS

step04
SELECT 
	c.country, 
    c.gender,
	AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
-- Report all info from a Pivot table for country and gender
GROUP BY GROUPING SETS ((country, gender), (country), (gender), ());

#---------------------------------------------------------------------
video
Bringing it all together

Final example

Business Case
MovieNow considers to invest money in new movies.
It is more expensive for MovieNow to make movies available which were recently produced than
older ones.
First step of data analysis:
Do customers give better ratings to movies which were recently produced than to older ones?
Is there a difference across countries?

1. Join data
Information needed:
renting records of movie rentals with ratings
customers information about country of the customer
movies year of release of the movie
SELECT *
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id;

2. Select relevant records
Use only records of movies with at least 4 ratings
Use only records of movie rentals since 2018-04-01
SELECT *
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN (
SELECT movie_id
FROM renting
GROUP BY movie_id
HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01';

3. Aggregation
Type of aggregation:
       Count the number of movie rentals
       Count the number of different movies
       Calculate the average rating
Levels of aggregation:
       Total aggregation
       For movies by year of release
       For movies by year of release separately for the country of the customers

3. Aggregation
SELECT c.country,
m.year_of_release,
COUNT(*) AS n_rentals,
COUNT(DISTINCT r.movie_id) AS n_movies,
AVG(rating) AS avg_rating
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN (
SELECT movie_id
FROM renting
GROUP BY movie_id
HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01'
GROUP BY ROLLUP (m.year_of_release, c.country)
ORDER BY c.country, m.year_of_release;

4.Resulting table
| year_of_release | country | n_rentals | n_movies | avg_rating |
|-----------------|---------|-----------|----------|--------------------|
| 2009 | null | 10 | 1 | 8.7500000000000000 |
| 2010 | null | 41 | 5 | 7.9629629629629630 |
| 2011 | null | 14 | 2 | 8.2222222222222222 |
| 2012 | null | 28 | 5 | 8.1111111111111111 |
| 2013 | null | 10 | 2 | 7.6000000000000000 |
| 2014 | null | 5 | 1 | 8.0000000000000000 |
| null | null | 333 | 50 | 7.9024390243902439 |

#---------------------------------------------------------------------

Customer preference for genres
You just saw that customers have no clear preference for more recent movies over older ones. Now the management considers investing money in movies of the best rated genres.

step01
SELECT *
FROM renting AS r
LEFT JOIN movies AS m -- Augment the table with information about movies
ON r.movie_id = m.movie_id;

step02
SELECT *
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( -- Select records of movies with at least 4 ratings
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01';; -- Select records of movie rentals since 2018-04-01

step03
SELECT m.genre, -- For each genre, calculate:
	   AVG(r.rating) AS avg_rating, -- The average rating and use the alias avg_rating
	   COUNT(r.rating) AS n_rating, -- The number of ratings and use the alias n_rating
	   COUNT(*) AS n_rentals,     -- The number of movie rentals and use the alias n_rentals
	   COUNT(DISTINCT m.movie_id) AS n_movies -- The number of distinct movies and use the alias n_movies
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3)
AND r.date_renting >= '2018-01-01'
GROUP BY m.genre;

step04
SELECT genre,
	   AVG(rating) AS avg_rating,
	   COUNT(rating) AS n_rating,
       COUNT(*) AS n_rentals,     
	   COUNT(DISTINCT m.movie_id) AS n_movies 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 3 )
AND r.date_renting >= '2018-01-01'
GROUP BY genre
ORDER BY avg_rating DESC; -- Order the table by decreasing average rating

#---------------------------------------------------------------------
Customer preference for actors
The last aspect you have to analyze are customer preferences for certain actors.

step01
-- Join the tables
SELECT *
FROM renting AS r
LEFT JOIN actsin AS ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id;

step02
SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating, -- The average rating
	   COUNT(r.rating) AS n_rating, -- The number of ratings
	   COUNT(*) AS n_rentals, -- The number of movie rentals
	   COUNT(DISTINCT a.actor_id) AS n_actors -- The number of actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >=4 )
AND r.date_renting >= '2018-04-01'
GROUP BY (a.nationality, a.gender); -- Report results for each combination of the actors' nationality and gender

step03
SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating,
	   COUNT(r.rating) AS n_rating,
	   COUNT(*) AS n_rentals,
	   COUNT(DISTINCT a.actor_id) AS n_actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01'
GROUP BY CUBE (a.nationality, a.gender); -- Provide results for all aggregation levels represented in a pivot table


END

*/