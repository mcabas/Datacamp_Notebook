--USE sakila;

-- SELECT *
-- FROM actor
-- WHERE actor_id > 10
-- ORDER BY first_name
-- WHERE actor_id = 10

-- ################################################################
-- ################################################################
-- ################################################################

-- next is going to be the infor from the video course 
-- https://www.youtube.com/watch?v=7S_tz1z_5bA&t=2313s
-- cause DATACAMP was a little bit confusing at beggining of MySQL course

-- ###### 1. SELECT clause
-- SELECT last_name, first_name
-- SELECT 	actor_id, 
--		(actor_id + 10) * 100 AS 'new id',
--        last_name,
--        first_name
-- FROM actor

-- SELECT DISTINCT first_name
-- FROM actor

-- ###### 2. WHERE clause
-- SELECT *
-- FROM actor
-- WHERE actor_id < 15
-- equality operators: >, >=, <, <=, =, != and <> 
-- (!= and <> are the same and it means not equal operatprs)
-- WHERE first_name = 'KENNETH'
-- Textual characters we can put on "text" or 'text'
-- by convenction it is recomended to use single quotes 'text'
-- WHERE first_name <> 'KENNETH
-- WHERE last_update > '2006-02-15'

-- ###### 3. The AND, OR, and NOT Operators 
-- SELECT *
-- FROM actor
-- WHERE actor_id < 100 AND first_name = 'KENNETH'
-- WHERE actor_id < 10 OR first_name = 'KENNETH' AND actor_id > 100
-- notice the order: AND operator is evaluate first, OR is second
-- you can always organize your code using parentesis, this makes
-- your code cleaner
-- WHERE 	actor_id < 10 OR 
--		(first_name = 'KENNETH' AND actor_id > 100)
-- WHERE NOT 	(actor_id < 10 )
-- NOT operator give you contrary of logics and AND/OR operators

-- ###### 4. The IN Operator
-- SELECT *
-- FROM actor
-- WHERE first_name = 'KENNETH' 
-- OR first_name = 'CHRISTIAN' 
-- OR first_name = 'JOHNNY'
-- We can use other option
-- SELECT *
-- FROM actor 
-- WHERE first_name IN ('KENNETH', 'CHRISTIAN', 'JOHNNY', 'MICHAEL')
-- we got the exact same result
-- WHERE first_name NOT IN ('KENNETH', 'CHRISTIAN', 'JOHNNY', 'MICHAEL')

-- ###### 5. The BETWEEN Operator
-- SELECT *
-- FROM actor 
-- WHERE actor_id >= 10 AND actor_id <= 20
-- WHERE actor_id BETWEEN 10 AND 20

-- ###### 6. The LIKE Operator
-- SELECT *
-- FROM actor 
-- 'word%' it means that is going to filter by the word at beggining
-- WHERE first_name LIKE 'm%'
-- '%word%' it means that is going to filter any result with the word
-- And doesn't matter if it's at beggining, middle of end.
-- WHERE first_name LIKE '%m%'
-- '%word' it means that is going to filter by the word at beggining
-- WHERE first_name LIKE '%m'
-- we use word_ for an exactly
-- WHERE first_name LIKE '_____Y'
-- WHERE first_name LIKE 'A____Y'

-- ###### 7. The REGEXP Operator
-- SELECT *
-- FROM actor 
-- WHERE last_name LIKE '%SON%'
-- WHERE last_name REGEXP 'SON'
-- if we add ^ we could indicate initial of string
-- WHERE last_name REGEXP '^SON'
-- if we add $ we could indicate end of string
-- WHERE last_name REGEXP 'SON$'
-- if we add | too look for multiple search patrons
-- WHERE last_name REGEXP 'SON|MC|AL'
-- WHERE last_name REGEXP '[gim]e'
-- the squere braquets indicate g, i, m, and before e
-- WHERE last_name REGEXP 'e[gim]'
-- the squere braquets indicate g, i, m, and after e
-- ^ beginning
-- $ end
-- | logical or
-- [abcd]
-- [a-f]

-- ###### 8. The IS NULL Operator-
-- SELECT *
-- FROM address
-- WHERE postal_code IS NULL
-- WHERE postal_code IS NOT NULL

-- ###### 9. The ORDER BY Operator
-- SELECT *
-- FROM actor 
-- ORDER BY first_name
-- ORDER BY first_name DESC
-- ORDER BY first_name DESC, last_name

-- you also can sort DATA by some item that is not selected
-- SELECT first_name, last_name
-- FROM actor 
-- ORDER BY actor_id DESC
-- it also could be an alias, like: data*10 AS EXAMPLE_ALIAS

-- sort by numbers of columns selected
-- SELECT first_name, last_name
-- FROM actor 
-- ORDER BY 1, 2
-- sorting DATA by columns positions is something that should be avoid
-- cause you may change the columns selected, and sometimes generates confsion

-- ###### 10. The LIMIT Operator
-- SELECT *
-- FROM actor 
-- LIMIT 15
-- skip the first 15 actors, and then show the next 15 ones
-- LIMIT 15, 15

-- ################################################################
-- ################################################################
-- ################################################################

-- MODULO 01 .  Selecting columns

-- ################################################################
-- NOW I HAVE MORE FAMILIARITY WITH MYSQL SERVER IS THE DATACAMP COURSE 011
-- Beginning your SQL journey
-- Now that you're familiar with the interface, let's get straight into it.
-- SQL, which stands for Structured Query Language, is a language for interacting with data stored in something called a relational database.
-- You can think of a relational database as a collection of tables. A table is just a set of rows and columns, like a spreadsheet, which represents exactly one type of entity. For example, a table might represent employees in a company or purchases made, but not both.
-- Each row, or record, of a table contains information about a single entity. For example, in a table representing employees, each row represents a single person. Each column, or field, of a table contains a single attribute for all rows in the table. For example, in a table representing employees, we might have a column containing first and last names for all employees.

-- SELECTing single columns
-- While SQL can be used to create and modify databases, the focus of this course will be querying databases. A query is a request for data from a database table (or combination of tables). Querying is an essential skill for a data scientist, since the data you need for your analyses will often live in databases.
-- In SQL, you can select data from a table using a SELECT statement. For example, the following query selects the name column from the people table:

-- SELECT name
-- FROM people;

-- In this query, SELECT and FROM are called keywords. In SQL, keywords are not case-sensitive, which means you can write the same query as:

-- select name
-- from people;

-- That said, it's good practice to make SQL keywords uppercase to distinguish them from other parts of your query, like column and table names.
-- It's also good practice (but not necessary for the exercises in this course) to include a semicolon at the end of your query. This tells SQL where the end of your query is!
-- Remember, you can see the results of executing your query in the query result tab to the right!

-- SELECT title
-- FROM film

-- SELECT release_year
-- FROM film

-- #####
-- SELECTing multiple columns
-- Well done! Now you know how to select single columns.
-- In the real world, you will often want to select multiple columns. Luckily, SQL makes this really easy. To select multiple columns from a table, simply separate the column names with commas!
-- For example, this query selects two columns, name and birthdate, from the people table:

-- SELECT name, birthdate
-- FROM people;

-- Sometimes, you may want to select all columns from a table. Typing out every column name would be a pain, so there's a handy shortcut:

-- SELECT *
-- FROM people;

-- If you only want to return a certain number of results, you can use the LIMIT keyword to limit the number of rows returned:

-- SELECT *
-- FROM people
-- LIMIT 10;

-- Before getting started with the instructions below, check out the column names in the films table by clicking on the films tab to the right!
-- SELECT  title
-- FROM film;

-- SELECT title, release_year
-- FROM films;

-- SELECT title, release_year, country
-- FROM film;

-- SELECT *
-- FROM film;

-- #####
-- SELECT DISTINCT
-- Often your results will include many duplicate values. If you want to select all the unique values from a column, you can use the DISTINCT keyword.
-- This might be useful if, for example, you're interested in knowing which languages are represented in the films table:

-- SELECT DISTINCT language
-- FROM films;

-- Remember, you can check out the data in the tables by clicking on the tabs to the right under the editor!

-- SELECT DISTINCT country
-- FROM film;

-- SELECT DISTINCT certification
-- FROM film;

-- SELECT DISTINCT role
-- FROM roles;

-- #####
-- ##### this was not in YT video
-- #####

-- Learning to COUNT
-- What if you want to count the number of employees in your employees table? The COUNT statement lets you do this by returning the number of rows in one or more columns.
-- For example, this code gives the number of rows in the people table:

-- SELECT COUNT(*)
-- FROM actor;

-- ####
-- Practice with COUNT
-- As you've seen, COUNT(*) tells you how many rows are in a table. However, if you want to count the number of non-missing values in a particular column, you can call COUNT on just that column.
-- For example, to count the number of birth dates present in the people table:

-- SELECT COUNT(birthdate)
-- FROM people;

-- It's also common to combine COUNT with DISTINCT to count the number of distinct values in a column.
-- For example, this query counts the number of distinct birth dates contained in the people table:

-- SELECT COUNT(DISTINCT birthdate)
-- FROM people;

-- Let's get some practice with COUNT!

-- SELECT COUNT(*)
-- FROM people;

-- SELECT COUNT(birthdate)
-- FROM people;

-- SELECT COUNT(DISTINCT birthdate)
-- FROM people;

-- SELECT COUNT(DISTINCT language)
-- FROM films;

-- SELECT COUNT(DISTINCT country)
-- FROM films;

-- ################################################################

-- MODULO 02 .  Filtering rows 

-- ################################################################

-- Filtering results
-- Congrats on finishing the first chapter! You now know how to select columns and perform basic counts. This chapter will focus on filtering your results.
-- In SQL, the WHERE keyword allows you to filter based on both text and numeric values in a table. There are a few different comparison operators you can use:

--    = equal
--    <> not equal
--    < less than
--    > greater than
--    <= less than or equal to
--    >= greater than or equal to

-- For example, you can filter text records such as title. The following code returns all films with the title 'Metropolis':

-- SELECT title
-- FROM films
-- WHERE title = 'Metropolis';

-- Notice that the WHERE clause always comes after the FROM statement!
-- Note that in this course we will use <> and not != for the not equal operator, as per the SQL standard.
-- What does the following query return?

-- SELECT title
-- FROM films
-- WHERE release_year > 2000;

-- #####
-- Simple filtering of numeric values
-- As you learned in the previous exercise, the WHERE clause can also be used to filter numeric records, such as years or ages.
-- For example, the following query selects all details for films with a budget over ten thousand dollars:

-- SELECT *
-- FROM films
-- WHERE budget > 10000;

-- Now it's your turn to use the WHERE clause to filter numeric values!

-- SELECT *
-- FROM films
-- WHERE release_year = 2016

-- SELECT COUNT(*)
-- FROM films
-- WHERE release_year < 2000

-- SELECT title, release_year	
-- FROM films
-- WHERE release_year > 2000

-- #####
-- Simple filtering of text
-- Remember, the WHERE clause can also be used to filter text results, such as names or countries.
-- For example, this query gets the titles of all films which were filmed in China:

-- SELECT title
-- FROM films
-- WHERE country = 'China';

-- Now it's your turn to practice using WHERE with text values!
-- Important: in PostgreSQL (the version of SQL we're using), you must use single quotes with WHERE.

-- SELECT *
-- FROM films
-- WHERE language = 'French';

-- SELECT name, birthdate
-- FROM people
-- WHERE birthdate = '1974-11-11';

-- SELECT COUNT(*)
-- FROM films
-- WHERE language = 'Hindi';

-- SELECT *
-- FROM films
-- WHERE certification = 'R';

-- WHERE AND
-- Often, you'll want to select data based on multiple conditions. You can build up your WHERE queries by combining multiple conditions with the AND keyword.
-- For example,

-- SELECT title
-- FROM films
-- WHERE release_year > 1994
-- AND release_year < 2000;

-- gives you the titles of films released between 1994 and 2000.
-- Note that you need to specify the column name separately for every AND condition, so the following would be invalid:

-- SELECT title
-- FROM films
-- WHERE release_year > 1994 AND < 2000;

-- You can add as many AND conditions as you need!

-- SELECT title, release_year
-- FROM films
-- WHERE release_year < 2000 AND language = 'Spanish';

-- SELECT *
-- FROM films
-- WHERE release_year > 2000 AND release_year < 2010 AND language = 'Spanish';

-- #####
-- WHERE AND OR
-- What if you want to select rows based on multiple conditions where some but not all of the conditions need to be met? For this, SQL has the OR operator.
-- For example, the following returns all films released in either 1994 or 2000:

-- SELECT title
-- FROM films
-- WHERE release_year = 1994
-- OR release_year = 2000;

-- Note that you need to specify the column for every OR condition, so the following is invalid:

-- SELECT title
-- FROM films
-- WHERE release_year = 1994 OR 2000;

-- When combining AND and OR, be sure to enclose the individual clauses in parentheses, like so:

-- SELECT title
-- FROM films
-- WHERE (release_year = 1994 OR release_year = 1995)
-- AND (certification = 'PG' OR certification = 'R');

-- Otherwise, due to SQL's precedence rules, you may not get the results you're expecting!

-- #####
-- WHERE AND OR (2)
-- You now know how to select rows that meet some but not all conditions by combining AND and OR.
-- For example, the following query selects all films that were released in 1994 or 1995 which had a rating of PG or R.

-- SELECT title
-- FROM films
-- WHERE (release_year = 1994 OR release_year = 1995)
-- AND (certification = 'PG' OR certification = 'R');

-- Now you'll write a query to get the title and release year of films released in the 90s which were in French or Spanish and which took in more than $2M gross.
-- It looks like a lot, but you can build the query up one step at a time to get comfortable with the underlying concept in each step. Let's go!

-- SELECT title, release_year
-- FROM films
-- WHERE (release_year >= 1990 AND release_year < 2000)
-- AND (language = 'French' OR language = 'Spanish')
-- AND gross > 2000000;


-- #####
-- BETWEEN
-- As you've learned, you can use the following query to get titles of all films released in and between 1994 and 2000:

-- SELECT title
-- FROM films
-- WHERE release_year >= 1994
-- AND release_year <= 2000;

-- Checking for ranges like this is very common, so in SQL the BETWEEN keyword provides a useful shorthand for filtering values within a specified range. This query is equivalent to the one above:

-- SELECT title
-- FROM films
-- WHERE release_year
-- BETWEEN 1994 AND 2000;

-- It's important to remember that BETWEEN is inclusive, meaning the beginning and end values are included in the results!

-- #####
-- BETWEEN (2)
-- Similar to the WHERE clause, the BETWEEN clause can be used with multiple AND and OR operators, so you can build up your queries and make them even more powerful!
-- For example, suppose we have a table called kids. We can get the names of all kids between the ages of 2 and 12 from the United States:

-- SELECT name
-- FROM kids
-- WHERE age BETWEEN 2 AND 12
-- AND nationality = 'USA';

-- Take a go at using BETWEEN with AND on the films data to get the title and release year of all Spanish language films released between 1990 and 2000 (inclusive) with budgets over $100 million. We have broken the problem into smaller steps so that you can build the query as you go along!

-- SELECT title, release_year
-- FROM films
-- WHERE (release_year BETWEEN 1990 AND 2000)
-- AND (budget > 100000000)
-- AND (language = 'Spanish' OR language = 'French')

-- #####
-- WHERE IN
-- As you've seen, WHERE is very useful for filtering results. However, if you want to filter based on many conditions, WHERE can get unwieldy. For example:

-- SELECT name
-- FROM kids
-- WHERE age = 2
-- OR age = 4
-- OR age = 6
-- OR age = 8
-- OR age = 10;

-- Enter the IN operator! The IN operator allows you to specify multiple values in a WHERE clause, making it easier and quicker to specify multiple OR conditions! Neat, right?

-- So, the above example would become simply:

-- SELECT name
-- FROM kids
-- WHERE age IN (2, 4, 6, 8, 10);

-- Try using the IN operator yourself!

-- SELECT title, release_year
-- FROM films
-- WHERE (release_year IN (1990, 2000))
-- AND (duration > 120)

-- SELECT title, language
-- FROM films
-- WHERE (language IN ('English','Spanish','French'))

-- SELECT title, certification
-- FROM films
-- WHERE (certification IN ('NC-17','R'))

-- #####
-- Introduction to NULL and IS NULL
-- In SQL, NULL represents a missing or unknown value. You can check for NULL values using the expression IS NULL. For example, to count the number of missing birth dates in the people table:

-- SELECT COUNT(*)
-- FROM people
-- WHERE birthdate IS NULL;

-- As you can see, IS NULL is useful when combined with WHERE to figure out what data you're missing.
-- Sometimes, you'll want to filter out missing values so you only get results which are not NULL. To do this, you can use the IS NOT NULL operator.
-- For example, this query gives the names of all people whose birth dates are not missing in the people table.

-- SELECT name
-- FROM people
-- WHERE birthdate IS NOT NULL;

-- NULL and IS NULL
-- Now that you know what NULL is and what it's used for, it's time for some practice!

-- SELECT name
-- FROM people
-- WHERE deathdate IS NULL;

-- SELECT title
-- FROM films
-- WHERE budget IS NULL;

-- SELECT COUNT(*)
-- FROM films
-- WHERE language IS NULL;

-- #####
-- LIKE and NOT LIKE
-- As you've seen, the WHERE clause can be used to filter text data. However, so far you've only been able to filter by specifying the exact text you're interested in. In the real world, often you'll want to search for a pattern rather than a specific text string.
-- In SQL, the LIKE operator can be used in a WHERE clause to search for a pattern in a column. To accomplish this, you use something called a wildcard as a placeholder for some other values. There are two wildcards you can use with LIKE:
-- The % wildcard will match zero, one, or many characters in text. For example, the following query matches companies like 'Data', 'DataC' 'DataCamp', 'DataMind', and so on:

-- SELECT name
-- FROM companies
-- WHERE name LIKE 'Data%';

-- The _ wildcard will match a single character. For example, the following query matches companies like 'DataCamp', 'DataComp', and so on:

-- SELECT name
-- FROM companies
-- WHERE name LIKE 'DataC_mp';

-- You can also use the NOT LIKE operator to find records that don't match the pattern you specify.
-- Got it? Let's practice!

-- SELECT name
-- FROM people
-- WHERE name LIKE 'B%';

-- SELECT name
-- FROM people
-- WHERE name NOT LIKE 'A%';

-- ################################################################

-- MODULO 03 .  Aggregate Functions 

-- ################################################################

-- Aggregate functions
-- Often, you will want to perform some calculation on the data in a database. SQL provides a few functions, called aggregate functions, to help you out with this.
-- For example,

-- SELECT AVG(budget)
-- FROM films;

-- gives you the average value from the budget column of the films table. Similarly, the MAX function returns the highest budget:

-- SELECT MAX(budget)
-- FROM films;

-- The SUM function returns the result of adding up the numeric values in a column:

-- SELECT SUM(budget)
-- FROM films;

-- You can probably guess what the MIN function does! Now it's your turn to try out some SQL functions.

-- SELECT SUM(duration)
-- FROM films;

-- SELECT AVG(duration)
-- FROM films;

-- SELECT MIN(duration)
-- FROM films;

-- SELECT MAX(duration)
-- FROM films;

-- ######
-- Aggregate functions practice
-- Good work. Aggregate functions are important to understand, so let's get some more practice!

-- SELECT SUM(gross)
-- FROM films;

-- SELECT AVG(gross)
-- FROM films;

-- SELECT MIN(gross)
-- FROM films;

-- SELECT MAX(gross)
-- FROM films;

-- Combining aggregate functions with WHERE
-- Aggregate functions can be combined with the WHERE clause to gain further insights from your data.
-- For example, to get the total budget of movies made in the year 2010 or later:

-- SELECT SUM(budget)
-- FROM films
-- WHERE release_year >= 2010;

-- Now it's your turn!

-- SELECT SUM(gross)
-- FROM films
-- WHERE release_year >= 2000;

-- SELECT AVG(gross)
-- FROM films
-- WHERE title LIKE 'A%'

-- SELECT MIN(gross)
-- FROM films
-- WHERE release_year = 1994

-- SELECT MAX(gross)
-- FROM films
-- WHERE release_year BETWEEN 2000 AND 2012

-- #####
-- A note on arithmetic
-- In addition to using aggregate functions, you can perform basic arithmetic with symbols like +, -, *, and /.
-- So, for example, this gives a result of 12:

-- SELECT (4 * 3);

-- However, the following gives a result of 1:

-- SELECT (4 / 3);

-- What's going on here?
-- SQL assumes that if you divide an integer by an integer, you want to get an integer back. So be careful when dividing!
-- If you want more precision when dividing, you can add decimal places to your numbers. For example,

-- SELECT (4.0 / 3.0) AS result;

-- gives you the result you would expect: 1.333.

-- #####
-- It's AS simple AS aliasing
-- You may have noticed in the first exercise of this chapter that the column name of your result was just the name of the function you used. For example,

-- SELECT MAX(budget)
-- FROM films;

-- gives you a result with one column, named max. But what if you use two functions like this?

-- SELECT MAX(budget), MAX(duration)
-- FROM films;

-- Well, then you'd have two columns named max, which isn't very useful!
-- To avoid situations like this, SQL allows you to do something called aliasing. Aliasing simply means you assign a temporary name to something. To alias, you use the AS keyword, which you've already seen earlier in this course.
-- For example, in the above example we could use aliases to make the result clearer:

-- SELECT MAX(budget) AS max_budget,
--        MAX(duration) AS max_duration
-- FROM films;

-- Aliases are helpful for making results more readable!

-- SELECT title, (gross - budget) AS net_profit
-- FROM films

-- SELECT title, (duration/60.0) AS duration_hours
-- FROM films

-- SELECT AVG(duration)/ 60.0 AS avg_duration_hours
-- FROM films

-- #####
-- Even more aliasing
-- Let's practice your newfound aliasing skills some more before moving on!
-- Recall: SQL assumes that if you divide an integer by an integer, you want to get an integer back.
-- This means that the following will erroneously result in 400.0:

-- SELECT 45 / 10 * 100.0;

-- This is because 45 / 10 evaluates to an integer (4), and not a decimal number like we would expect.
-- So when you're dividing make sure at least one of your numbers has a decimal place:

-- SELECT 45 * 100.0 / 10;

-- The above now gives the correct answer of 450.0 since the numerator (45 * 100.0) of the division is now a decimal!

-- get the count(deathdate) and multiply by 100.0
-- then divide by count(*)

-- SELECT COUNT(deathdate) * 100.0 / COUNT(*) AS percentage_dead
-- FROM people

-- SELECT (MAX(release_year)-MIN(release_year)) AS difference
-- FROM films

-- SELECT ((MAX(release_year)-MIN(release_year))/10) AS number_of_decades
-- FROM films

-- ################################################################

-- MODULO 04 .  Sorting and grouping 

-- ################################################################

-- ORDER BY
-- Congratulations on making it this far! You now know how to select and filter your results.
-- In this chapter you'll learn how to sort and group your results to gain further insight. Let's go!
-- In SQL, the ORDER BY keyword is used to sort results in ascending or descending order according to the values of one or more columns.
-- By default ORDER BY will sort in ascending order. If you want to sort the results in descending order, you can use the DESC keyword. For example,

-- SELECT title
-- FROM films
-- ORDER BY release_year DESC;

-- gives you the titles of films sorted by release year, from newest to oldest.

-- Sorting single columns
-- Now that you understand how ORDER BY works, give these exercises a go!

-- SELECT name
-- FROM people
-- ORDER BY name

-- SELECT name
-- FROM people
-- ORDER BY birthdate

-- SELECT birthdate, name
-- FROM people
-- ORDER BY birthdate

-- SELECT title
-- FROM films
-- WHERE release_year IN (2000, 2012)
-- ORDER BY release_year

-- SELECT *
-- FROM films
-- WHERE NOT release_year = 2015
-- ORDER BY duration	

-- SELECT title, gross
-- FROM films
-- WHERE title LIKE 'M%'
-- ORDER BY title	

-- ####
-- Sorting single columns (DESC)

-- To order results in descending order, you can put the keyword DESC after your ORDER BY. For example, to get all the names in the people table, in reverse alphabetical order:

-- SELECT name
-- FROM people
-- ORDER BY name DESC;

-- Now practice using ORDER BY with DESC to sort single columns in descending order!

-- SELECT imdb_score, film_id
-- FROM reviews
-- ORDER BY imdb_score DESC;

-- SELECT title
-- FROM films
-- ORDER BY title DESC;

-- SELECT title, duration
-- FROM films
-- ORDER BY duration DESC;

-- ####
-- Sorting multiple columns
-- ORDER BY can also be used to sort on multiple columns. It will sort by the first column specified, then sort by the next, then the next, and so on. For example,

-- SELECT birthdate, name
-- FROM people
-- ORDER BY birthdate, name;

-- sorts on birth dates first (oldest to newest) and then sorts on the names in alphabetical order. The order of columns is important!
-- Try using ORDER BY to sort multiple columns! Remember, to specify multiple columns you separate the column names with a comma.

-- SELECT release_year, duration, title
-- FROM films
-- ORDER BY release_year, duration;

-- SELECT certification, release_year, title
-- FROM films
-- ORDER BY certification, release_year;

-- SELECT name, birthdate
-- FROM people
-- ORDER BY name, birthdate;

-- ####-- ####-- ####
-- ####-- ####-- ####
-- GROUP BY
-- Now you know how to sort results! Often you'll need to aggregate results. For example, you might want to count the number of male and female employees in your company. Here, what you want is to group all the males together and count them, and group all the females together and count them. In SQL, GROUP BY allows you to group a result by one or more columns, like so:

-- SELECT sex, count(*)
-- FROM employees
-- GROUP BY sex;

-- This might give, for example:
-- sex 	count
-- male 	15
-- female 	19

-- Commonly, GROUP BY is used with aggregate functions like COUNT() or MAX(). Note that GROUP BY always goes after the FROM clause!

-- GROUP BY practice
-- As you've just seen, combining aggregate functions with GROUP BY can yield some powerful results!
-- A word of warning: SQL will return an error if you try to SELECT a field that is not in your GROUP BY clause without using it to calculate some kind of value about the entire group.
-- Note that you can combine GROUP BY with ORDER BY to group your results, calculate something about them, and then order your results. For example,

-- SELECT sex, count(*)
-- FROM employees
-- GROUP BY sex
-- ORDER BY count DESC;

-- might return something like
-- sex 	count
-- female 	19
-- male 	15

-- because there are more females at our company than males. Note also that ORDER BY always goes after GROUP BY. Let's try some exercises!

-- SELECT release_year, count(*)
-- FROM films
-- GROUP BY release_year

-- SELECT release_year, AVG(duration)
-- FROM films
-- GROUP BY release_year

-- SELECT release_year, MAX(budget)
-- FROM films
-- GROUP BY release_year

-- SELECT imdb_score, COUNT(*)
-- FROM reviews
-- GROUP BY imdb_score

-- SELECT release_year, MIN(gross)
-- FROM films
-- GROUP BY release_year

-- SELECT language, SUM(gross)
-- FROM films
-- GROUP BY language

-- SELECT country, SUM(budget)
-- FROM films
-- GROUP BY country

-- SELECT release_year, country, MAX(budget)
-- FROM films
-- GROUP BY release_year, country
-- ORDER BY release_year, country;

-- SELECT country, release_year, MIN(gross)
-- FROM films
-- GROUP BY release_year, country
-- ORDER BY country, release_year;

-- ####
-- HAVING a great time
-- In SQL, aggregate functions can't be used in WHERE clauses. For example, the following query is invalid:

-- SELECT release_year
-- FROM films
-- GROUP BY release_year
-- WHERE COUNT(title) > 10;

-- This means that if you want to filter based on the result of an aggregate function, you need another way! That's where the HAVING clause comes in. For example,

-- SELECT release_year
-- FROM films
-- GROUP BY release_year
-- HAVING COUNT(title) > 10;

-- shows only those years in which more than 10 films were released.
-- In how many different years were more than 200 movies released?

-- SELECT release_year
-- FROM films
-- GROUP BY release_year
-- HAVING COUNT(title) > 200;

-- ####
-- All together now
-- Time to practice using ORDER BY, GROUP BY and HAVING together.
-- Now you're going to write a query that returns the average budget and average gross earnings for films in each year after 1990, if the average budget is greater than $60 million.
-- This is going to be a big query, but you can handle it!

-- SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
-- FROM films
-- WHERE (release_year > 1990)
-- GROUP BY release_year
-- HAVING AVG(budget) > 60000000
-- ORDER BY avg_gross DESC

-- select country, average budget, average gross
-- SELECT country, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
-- from the films table
-- FROM films
-- group by country 
-- GROUP BY country
-- where the country has more than 10 titles
-- HAVING COUNT(title) > 10
-- order by country
-- ORDER BY country
-- limit to only show 5 results
-- LIMIT 5

-- #############################################################

-- A taste of things to come
-- Congrats on making it to the end of the course! By now you should have a good understanding of the basics of SQL.
-- There's one more concept we're going to introduce. You may have noticed that all your results so far have been from just one table, e.g. films or people.
-- In the real world however, you will often want to query multiple tables. For example, what if you want to see the IMDB score for a particular movie?
-- In this case, you'd want to get the ID of the movie from the films table and then use it to get IMDB information from the reviews table. In SQL, this concept is known as a join, and a basic join is shown in the editor to the right.
-- The query in the editor gets the IMDB score for the film To Kill a Mockingbird! Cool right?
-- As you can see, joins are incredibly useful and important to understand for anyone using SQL.
-- We have a whole follow-up course dedicated to them called Joining Data in PostgreSQL for you to hone your database skills further!

-- SELECT title, imdb_score
-- FROM films
-- JOIN reviews
-- ON films.id = reviews.film_id
-- WHERE title = 'To Kill a Mockingbird';

-- END