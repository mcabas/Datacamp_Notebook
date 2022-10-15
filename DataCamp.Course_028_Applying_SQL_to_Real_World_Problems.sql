/*


-.-------------------------------------------------------------------------------------------------------------------
DATACAMP
Video. Store your data

Three ways to store your data 
1. Create a TABLE using new data 
2. Create a TABLE using existing data 
3. Create a VIEWusing existing data

Create a TABLE using new data
Columns in address table 
address_id 
address 
district 
city postal_
code 
phone
Create a TABLE using new data 
postal_code 	distance 
53182 		3.4 
15540 		10.2 
67912 		1.9 
81766 		21

Create a TABLE using new data 
1) Create a new table 
CREATE TABLE zip_distance ( 
postal_code INT, 
distance FLOAT 
); 
2) Insert data into table 
INSERT INTO zip_distance (postal_code, distance) 
VALUES 
(53182, 3.4), 
(15540, 10.2), 
(67912, 1.9);

Create a TABLE using existing data
SELECT film_id, title 
FROM film 
WHERE rating = 'G';

Create a TABLE using existing data
CREATE TABLE family_films AS 
SELECT film_id, title 
FROM film 
WHERE rating = 'G';

Create a VIEWusing existing data
CREATE VIEW family_films AS 
SELECT film_id, title 
FROM film 
WHERE rating = 'G';

TABLE vs VIEW 
TABLE 
Data is stored (static) 
Data can be modied directly 
VIEW 
Query is stored (dynamic) 
Underlying data must be modied in originaltables

-.-------------------------------------------------------------------------------------------------------------------
Storing new data
You're planing to run a promotion on movies that won a best film academy award in the last 5 years. To do this you need to add a table in your database containing the movies which won an Oscar for best film.
The data you need for this exercise is provided in the table below:
title	award
'TRANSLATION SUMMER'	'Best Film'
'DORADO NOTTING'	'Best Film'
'MARS ROMAN'	'Best Film'
'CUPBOARD SINNERS'	'Best Film'
'LONELY ELEPHANT'	'Best Film'

Step01
-- Create a new table called oscars
CREATE TABLE oscars (
    title VARCHAR,
    award VARCHAR
);

Step02
-- Create a new table called oscars
CREATE TABLE oscars (
    title VARCHAR,
    award VARCHAR
);

-- Insert the data into the oscars table
INSERT INTO oscars (title, award)
VALUES
('TRANSLATION SUMMER', 'Best Film'),
('DORADO NOTTING', 'Best Film'),
('MARS ROMAN', 'Best Film'),
('CUPBOARD SINNERS', 'Best Film'),
('LONELY ELEPHANT', 'Best Film');

Step03
-- Create a new table called oscars
CREATE TABLE oscars (
    title VARCHAR,
    award VARCHAR
);

-- Insert the data into the oscars table
INSERT INTO oscars (title, award)
VALUES
('TRANSLATION SUMMER', 'Best Film'),
('DORADO NOTTING', 'Best Film'),
('MARS ROMAN', 'Best Film'),
('CUPBOARD SINNERS', 'Best Film'),
('LONELY ELEPHANT', 'Best Film');

-- Confirm the table was created and is populated
SELECT * 
FROM oscars;
-.-------------------------------------------------------------------------------------------------------------------
Using existing data
You are interested in identifying and storing information about films that are family-friendly. To do this, you will create a new table family_films using the data from the film table. This new table will contain a subset of films that have either the rating G or PG.
STEP 01
SELECT *
FROM film 
WHERE rating = 'G' OR rating = 'PG';
STEP 02
-- Create a new table named family_films using this query
CREATE TABLE family_films AS 
SELECT *
FROM film
WHERE rating IN ('G', 'PG');
-.-------------------------------------------------------------------------------------------------------------------
Video. Update your data

UPDATE syntax
UPDATE table_name 
SET column1 = value1, column2 = value2, ...;

UPDATE a column
Desired Update: Emails of customers must be lowercase. 
UPDATE customer 
SET email = LOWER(email);

UPDATE & WHERE 
Desired Update: Emails of customers must be lowercase for customers who are still active. 
UPDATE customer 
SET email = LOWER(email) 
WHERE active = TRUE;

UPDATE using subqueries 
Desired Update: Emails of customers must be lowercase for customers reside in city ofWoodridge. 
UPDATE customer 
SET email = LOWER(email) 
WHERE address_id IN 
(SELECT address_id 
FROM address 
WHERE city = 'Woodridge');

Be careful when modifying tables
	Ensure you CAN modify the table. 
Ensure you know how this table is used and how your changes will impact those who use it. 
Test a modication by using a SELECT statement FIrst.

-.-------------------------------------------------------------------------------------------------------------------

Update the price of rentals
You just learned that there have been some updates for the rental pricing of your films. In this exercise you will leverage the UPDATE command to modify the rental prices by increasing the rental_rate with the following logic.
•	All films now cost 50 cents more to rent.
•	R Rated films will go up by an additional 1 dollar.
STEP 01
-- Increase rental_rate by 0.5 in the film table
UPDATE film
SET rental_rate = rental_rate + 0.5;

STEP 02
-- Increase rental_rate by one dollar for R-rated movies
UPDATE film
SET rental_rate = rental_rate + 1
WHERE rating = ('R');

-.-------------------------------------------------------------------------------------------------------------------
Updated based on other tables
The rental company is running a promotion and needs you to lower the rental costs by 1 dollar of films who star the actors/actresses with the following last names: WILLIS, CHASE, WINSLET, GUINESS, HUDSON.
To UPDATE this data in the film table you will need to identify the film_id for these actors.

STEP 01

SELECT film_id 
FROM actor AS a
INNER JOIN film_actor AS f
   ON a.actor_id = f.actor_id
WHERE last_name IN ('WILLIS', 'CHASE', 'WINSLET', 'GUINESS', 'HUDSON');

STEP02

UPDATE film
SET rental_rate = rental_rate - 1
WHERE film_id IN
  (SELECT film_id from actor AS a
   INNER JOIN film_actor AS f
      ON a.actor_id = f.actor_id
   WHERE last_name IN ('WILLIS', 'CHASE', 'WINSLET', 'GUINESS', 'HUDSON'));

-.-------------------------------------------------------------------------------------------------------------------

VIDEO
Delete your data 

DROP, TRUNCATE, DELETE
Remove a table 
DROP TABLE table_name; 
Clear table of ALL records 
TRUNCATE TABLE table_name; 
Clear table of SOME records 
DELETE FROM table_name WHERE condition;

DELETE inactive customers
Desired Modication: Remove customers who are no longer active 
DELETE FROM customer 
WHERE active = FALSE;

DELETE using a subquery
Desired Modication: Removing all customers who live in the city ofWoodridge. 
DELETE FROM customer 
WHERE address_id IN 
(SELECT address_id 
FROM address 
WHERE city = 'Woodridge');

-.-------------------------------------------------------------------------------------------------------------------

Delete selected records
You've discovered that some films are just not worth keeping your inventory, for cases where the replacement_cost is greater than 25 dollars. As such you'd like to remove them from you film table.

-- Delete films that cost most than 25 dollars
DELETE FROM film 
WHERE replacement_cost > 25;

A family friendly video store
Your company has decided to become a family friendly store. As such, all R & NC-17 movies will be cleared from the inventory. You will take the steps necessary to clear these films from both the inventory and the film tables.

Step01
-- Identify the film_id of all films that have a rating of R or NC-17
SELECT film_id
FROM film
WHERE rating IN ('R', 'NC-17');
Step02
-- Use the list of film_id values to DELETE all R & NC-17 rated films from inventory.
DELETE FROM inventory 
WHERE film_id IN (
  SELECT film_id FROM film
  WHERE rating IN ('R', 'NC-17')
);
-- Delete records from the `film` table that are either rated as R or NC-17.
DELETE FROM film 
WHERE rating IN ('R', 'NC-17');

-.-------------------------------------------------------------------------------------------------------------------

Convey your intent

***Why is this important?
" ...if my code does what I designed it to do, who cares how its written... "
…six months from now

***Always use AS
Original 
SELECT title film_title 
FROM film;
Improved
SELECT title AS film_title 
FROM film;



***What kind of JOIN?
	Original
		SELECT category, length 
FROM film AS f 
JOIN category AS c 
ON f.film_id = c.film_id;
Improved
SELECT category, length 
FROM film AS f 
INNER JOIN category AS c 
ON f.film_id = c.film_id;

***Good use of aliases
	Original
SELECT category, length 
FROM film AS x1 
INNER JOIN category AS x2 
ON x1.film_id = x2.film_id;

Improved
	SELECT category, length 
FROM film AS f 
INNER JOIN category AS c 
ON f.film_id = c.film_id;

*** Good use of aliases 2

Original
SELECT category, length 
FROM film AS x1 
INNER JOIN category AS x2 
ON x1.film_id = x2.film_id;

Improved
SELECT category, length 
FROM film AS f 
INNER JOIN category AS c 
ON f.film_id = c.film_id; 

SELECT category, length 
FROM film AS fil 
INNER JOIN category AS cat 
ON fil.film_id = cat.film_id;

***Use comments 
/* Use the system table, information_schema.columns to generate a comma-separated list of columns for each table */ 
SELECT table_name, STRING_AGG(column_name, ' , ') AS columns 
FROM information_schema.columns 
-- All our data is stored in the public schema. 
WHERE table_schema = 'public' 
GROUP BY table_name; 
/* Multi-line comment */ 
-- Single-line comment
/*
What was your intent?
-------------------------------------------------------------------------------------------------------------------
Fix this query - intent
Using the four opportunities you've identified you will now clarify the intent of this query, one step at a time.
SELECT x1.customer_id, x1.rental_date, x1.return_date 
FROM rental x1
JOIN inventory x2
    ON x1.inventory_id = x2.inventory_id
JOIN film x3
    ON x2.film_id = x3.film_id
WHERE x3.length < 90;

Step01
SELECT r.customer_id, r.rental_date, r.return_date 
FROM rental r
JOIN inventory i
  ON r.inventory_id = i.inventory_id
JOIN film f
  ON i.film_id = f.film_id
WHERE f.length < 90;

Step02
SELECT r.customer_id, r.rental_date, r.return_date 
FROM rental AS r
JOIN inventory AS i
  ON r.inventory_id = i.inventory_id
JOIN film AS f
  ON i.film_id = f.film_id
WHERE f.length < 90;

Step03
SELECT r.customer_id, r.rental_date, r.return_date 
FROM rental AS r
INNER JOIN inventory AS i
  ON r.inventory_id = i.inventory_id
INNER JOIN film AS f
  ON i.film_id = f.film_id
WHERE f.length < 90;

Step04
SELECT r.customer_id, r.rental_date, r.return_date 
FROM rental AS r
/* inventory table is used to unite the rental and film tables. */ 

/*
INNER JOIN inventory AS i
  ON r.inventory_id = i.inventory_id
INNER JOIN film AS f
  ON i.film_id = f.film_id
WHERE f.length < 90;

-.-------------------------------------------------------------------------------------------------------------------
Make this query easier to read - Part I
In this exercise you will work on making the query below easier to read.
SELECT title, rating FROM film 
WHERE rating = 'G' OR rating = 'PG' OR rating = 'R';

SELECT title, 
    rating 
FROM film 
WHERE rating  IN ('G', 'PG', 'R')
-.-------------------------------------------------------------------------------------------------------------------
Make this query easier to read - Part II
In this exercise you will work on making the query below easier to read.
select 
  category as FILMCATEGORY, 
  avg(length) as AverageLength
from film as f
inner join category as c
  on f.film_id = c.film_id
where release_year >= 2005
  and release_year <= 2010
group by category;

STEP01
SELECT category AS filmcategory, 
  	   AVG(length) AS AverageLength
FROM film AS f
INNER JOIN category AS c
  ON f.film_id = c.film_id
WHERE release_year >= 2005
  AND release_year <= 2010
GROUP BY category;

STEP02
SELECT category AS FILM_CATEGORY, 
	   AVG(length) AS Average_Length
FROM film AS f
INNER JOIN category AS c
  ON f.film_id = c.film_id
WHERE release_year >= 2005
  AND release_year <= 2010
GROUP BY category;

STEP03
SELECT category AS film_category, 
       AVG(length) AS average_length
FROM film AS f
INNER JOIN category AS c
  ON f.film_id = c.film_id
WHERE release_year BETWEEN 2005
  AND 2010
GROUP BY category;

-.-------------------------------------------------------------------------------------------------------------------
***Avoid common
mistakes
***Don't misuse comments
/* When selecting category and length
from films we need to use f, after this
I had a sandwich, it was a
good sandwich ...*/
SELECT category, length
-- FROM actor as a
FROM film AS f
/* Inner join the table category
with the film table */
/*
INNER JOIN category AS c
ON f.film_id = c.film_id;
Do not
Write an essay in your comments.
Leave old comments in _nished code.
Make comments redundant with code.

CORRECT WAY
SELECT category, length
FROM film AS f
INNER JOIN category AS c
ON f.film_id = c.film_id;

***Don't SELECT everything
SELECT *
FROM film AS f
INNER JOIN category AS c
ON f.film_id = c.film_id;

***Don't use SQL for programming
DO $$
BEGIN
FOR counter IN 1..5 LOOP
IF (counter = 2) THEN
RAISE NOTICE 'BINGO!';
ELSE
RAISE NOTICE 'Not BINGO :-(';
END IF;
END LOOP;
END; $$

-.-------------------------------------------------------------------------------------------------------------------

Apply best practices to your code
In this exercise you will update the code below to adhere to the best practices you learned in this chapter.
SELECT first_name, last_name, email FROM rental AS r 
-- FROM address AS a JOIN r.address_id = a.address_id
JOIN customer AS c ON r.customer_id = c.customer_id;

Step01
SELECT first_name, last_name, email FROM rental AS r 
JOIN customer AS c ON r.customer_id = c.customer_id;
Step02
SELECT first_name,
       last_name, 
       email 
FROM rental AS r 
JOIN customer AS c 
    ON r.customer_id = c.customer_id;
STEP03
SELECT first_name, 
       last_name, 
       email 
FROM rental AS r 
INNER JOIN customer AS c 
   ON r.customer_id = c.customer_id;

END


END
*/
