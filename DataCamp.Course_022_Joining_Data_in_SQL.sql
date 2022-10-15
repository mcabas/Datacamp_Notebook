/*
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

-- COURSE Joining Data in SQL_022

----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

For this course i decided to learn Posgresql in addition to mysql
I learn some new commands that I like to remember here.
https://www.youtube.com/watch?v=qw--VYLpxG4


Posgresql
	-SQL SHELL (psql)
	-pgAdmin 4
	-Visual Studio Code (También sirve para python)
	https://code.visualstudio.com/docs/?dv=win
	-Mockaroo (página generadora de dummy data)
	https://mockaroo.com/

Estoy prácticando con un set de datos creado con mockaroo
	- mock_perrenque
	- car_perrenque

posgresql password is 'perrenque'

Comandos de PosgreSQL

	\? [consulta informaciónd de todos los comandos]
	\c[onnect] [BASE-DE-DATOS|- USUARIO|- ANFITRIËN|- PUERTO|- | conninfo]
                  conectar a una nueva base de datos (actual: perrenque+)
	\password [USUARIO]
                  cambiar la contrase±a para un usuario en forma segura
	\d            listar tablas, vistas y secuencias
	\d [+Nombre de tabla,secuencia o lista] muestra los detalles
  	\q              salir de psql
	\l   Lista de bases de datos

	help (AYUDA BÁSICA)

	help
	Está usando psql, la interfaz de línea de órdenes de PostgreSQL.
	Digite:  
	\copyright para ver los términos de distribución
       	\h para ayuda de órdenes SQL
       	\? para ayuda de órdenes psql
       	\g o punto y coma («;») para ejecutar la consulta
       	\q para salir

Comandos de manipulación de base de tados y de elementos

	--BASE DE DATOS--
	\l  					-- Lista de base de datos
	CREATE DATABASE name_of_database; 	-- crear base de datos
	\c name_of_database; 			-- conectar a base de datos
	DROP DATABASE name_of_database;		-- borrar base de datos (!!!)

	--Tablas--
	CREATE TABLE table_name ( 
		column name + data type + constraints if any
	);
	EJ:
	CREATE TABLE person (
		id INT,
		first_name VARCHAR(50),
		last_name VARCHAR(50),
		gender VARCHAR(6),
		date_of_birth DATE,
	);
	-- table info --
	\d table_name -- information of table

	-- create table with constrains --
	EJ:
	CREATE TABLE person (
		id BIGSERIAL NOT NULL PRIMARY KEY,
		first_name VARCHAR(50) NOT NULL,
		last_name VARCHAR(50) NOT NULL,
		gender VARCHAR(6) NOT NULL,
		date_of_birth DATE NOT NULL
	);
	-- BIGSERIAL is a sequence and is created like an objet in \d --	
	-- drop table --
	DROP TABLE table_name;
	-- insert records in a table--
	INSERT INTO table_name (
		first_name,
		last_name,
		gender,
		date_of_birth)
	VALUES ('Michael', 'Cabas', 'MALE', DATE '1991-10-18');
	-- insert another person -- repeat again-- id has autoincrement
	-- no es necesario ingresarla

Algunos comandos útiles del curso anterior

SELECT FROM
	SELECT * FROM table_name;
	SELECT column1, column2 FROM table_name;
ORDER BY & DISTINCT
	SELECT * FROM table_name ORDER BY column1;
	SELECT DISTINCT column1 FROM table_name ORDER BY column1; 
	SELECT DISTINCT column1 FROM table_name ORDER BY column1 DESC;
WHERE, AND & OR
	SELECT * FROM table_name WHERE column1 = 'condition';
	SELECT * FROM table_name WHERE column2 > 'condition2';
	SELECT * FROM table_name WHERE column2 = 'condition1' AND 				       column2 = 'condition2';
	SELECT * FROM table_name WHERE column2 = 'condition1' AND 				                      (column2 = 'condition2' OR 
                               column2 = 'condition3');
COMPARISON OPERATORS
	=	EQUAL
	<	LESS TO
	>	GREAT TO
	<=	LESS OR EQUAL TO
	>=	GREAT OR EQUAL TO
	<>	NOT EQUAL
LIMIT, OFFSET & FETCH
	SELECT * FROM table_name LIMIT number_value; 
	SELECT * FROM table_name LIMIT 10; -- show first 10 values --
	SELECT * FROM table_name OFFSET 10; -- start at 11 value --
	SELECT * FROM table_name OFFSET 5 LIMIT 5; -- show 6 to 10 --
	SELECT * FROM table_name FETCH FIRST 5 ROW ONLY; -- show first 5--
IN & BETWEEN
	SELECT * FROM table_name WHERE column1 IN ('value1', 'value2', 'value3');
	SELECT * FROM table_name WHERE number_or_date_column 
	BETWEEN 'value1' AND 'value2';
LIKE AND iLIKE
	SELECT * FROM table_name WHERE column1 LIKE '%string'
 	SELECT * FROM table_name WHERE column1 LIKE '%.com'
	SELECT * FROM table_name WHERE column1 LIKE '%string%'
	SELECT * FROM table_name WHERE column1 LIKE '________@%'
	SELECT * FROM table_name WHERE column1 iLIKE 'string%' -- ignores de case Mn
GROUP BY, COUNT(*) & GROUP BY HAVING
	SELECT column1, COUNT(*) FROM table_name GROUP BY column1;
	SELECT column1, COUNT(*) FROM table_name GROUP BY column1 ORDER BY column1;
	SELECT column1, COUNT(*) FROM table_name GROUP BY column1 HAVING COUNT(*) > condition ORDER BY column1;
	SELECT column1, COUNT(*) FROM table_name GROUP BY column1 HAVING COUNT(*) > 5 ORDER BY column1;	
MIN, MAX & AVG
	SELECT MAX(numericcolumn) FROM table_name;
	SELECT MIN(numericcolumn) FROM table_name;
	SELECT AVG(numericcolumn) FROM table_name;
	SELECT ROUND(AVG(numericcolumn)) FROM table_name;
	SELECT column1, column2, MIN(numericcolumn) FROM table_name  GROUP BY column1, column 2;
SUM
	SELECT SUM(numericcolumn) FROM table_name;
	SELECT column1, SUM(numericcolumn) FROM table_name GROUP BY column1;
ARITHMETIC OPERATORS & ROUND
	SELECT 10 * 2;
	*, +, -, ^, %, / (...)
	SELECT make, model, price, ROUND(price * .10, 2), ROUND(price - (price * 0,19), 2) FROM car;
ALIAS
	SELECT make, model, price AS original_price, ROUND(price * .10, 2) AS ten_percent, ROUND(price - (price * 0,19), 2) AS price_discount FROM car;

comandos nuevos SQL no cubiertos en el curso anterior
	
COALESCE
	SELECT COALESCE(1);
	SELECT COALESCE(1) AS number;
	SELECT COALESCE(null, 1) AS number;
	SELECT COALESCE(null, null, 1) AS number;
	SELECT COALESCE(null, null, 1, 10) AS number;
	SELECT email FROM person; -- we have people without email
	SELECT COALESCE(email, 'Email not provided') FROM person;
	-- reepleace null values --	
NULLIF
	SELECT 10 / 0; -- ERROR!
	SELECT NULLIF(10, 10);
	nullif
	SELECT NULLIF(10, 1);
	10
	SELECT NULLIF(100, 19);
	100
	SELECT 10 / NULLIF(2, 5);
	5
	SELECT 10 / NULLIF(0, 0);
	---
	SELECT COALESCE(10 / NULLIF(0, 0), 0);
	0 -- this is how you handle division by 0
TIMESTAMPS AND DATES WITH SQL
	SELECT NOW() - give us the actual timestamp (date + time)
	SELECT NOW()::DATE; -- give us just the actual date
	SELECT NOW()::TIME; -- give us just the actual time
	SELECT NOW() - INTERVAL '1 YEAR';
	SELECT NOW() - INTERVAL '10 YEARS';
	SELECT NOW() - INTERVAL '10 DAYS';
	SELECT NOW() + INTERVAL '10 MONTHS';
	SELECT (NOW() + INTERVAL '10 MONTHS')::DATE;
	SELECT EXTRACT(YEAR FROM NOW())
	SELECT EXTRACT(DOW FROM NOW()) -- day of the week
	SELECT EXTRACT(DAY FROM NOW())
	SELECT EXTRACT(CENTURY FROM NOW())
	-- AGE FUNCTION -- AGE(,)
	SELECT first_name, last_name, gender, country_of_birth, day_of_birth, AGE(NOW(), date_of_birth) AS age FROM person;
PRIMARY KEY MANIPULATION 
	--Unique number of document to identify your records
	--PRIMERY KEYS CAN BE ID DOCUMENT
	--If you insert a new person with the same ID, after you define ID 		-- as primary Key it return you an error
	-- HOW TO DROP PRIMARY KEY -------------------------
	ALTER TABLE table_name DROP CONSTRAINT table_name_pkey;
	\d table_name -- no primary key
	-- now you can insert two records with the same ID
	-- to add a primary Key--
	ALTER TABLE table_name ADD PRIMARY KEY (column1, column 2);
	ALTER TABLE person ADD PRIMARY KEY (id);
	--recieve an arrange of values because you can set more than one
	-- primary key, it had the rule than can not have repeat values in
	-- the arrange
UNIQUE CONSTRAINTS 
	-- set a condition in wich a value can not repeat in a column --
	ALTER TABLE table_name ADD CONSTRAINT unique_column1 UNIQUE(column1);
	ALTER TABLE person ADD CONSTRAINT unique_email_address UNIQUE(email);
	ALTER TABLE table_name ADD UNIQUE (column1) -- another way to do it
	-- the second way left postgress in charge to put the name of it
CHECK CONSTRAINTS
	SELECT * FROM person;
	-- gender = 'MALE' and 'FEMALE'
	-- we can create a constrains that only allowd to put male of female in 
	-- gender category
	-- ALTER TABLE person ADD CONSTRAINT gender_constraint CHECK (gender = 'Female' OR gender = 'Male');
RECORD MANIPULATION
	-- Delete records
	DELETE FROM table_name WHERE 'set a condition';
	DELETE FROM person WHERE id = 1;
	DELETE FROM person WHERE id > 1000;
	DELETE FROM person WHERE gender = 'Female' AND country_of_birth = 'Nigeria';
	DELETE FROM person WHERE gender = 'Male';
	DELETE FROM person; -- It's a bad IDEA because you can delete everyone--
	-- Update records
	UPDATE table_name SET column = 'new value' WHERE 'condition';
	UPDATE person SET email = 'newemail@gmail.com' WHERE id = 1000;
	UPDATE person SET first_name = 'Omar', last_name = 'Montana' 
	WHERE id = 1000;
	-- On conflict do nothing --
	ON CONFLICT (id) DO NOTHING;
	ON CONFLICT (email) DO NOTHING;
	-- this is how you handle errors or duplicate whitout broken the command
	-- make sure you column is unique or have any constrainst
	-- sometimes you want to do sometimes else instead of nothing, upsert , update.
	ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email;
	ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email,
				  first_name = EXCLUDED.first_name,
				   last_name = EXCLUDED.last_name;

RELATIONSHIPS , JOINS & FOREING KEYS
"A foreing key is a column that reference a primary key in another column"
	- they have to be the same type for this to work -
	Ex: car_id
	--- set a value that correspond to a key in another table
	UNIQUE(car_id)
	\d person
	UPDATE person SET car_id = 2 WHERE id = 1;
	UPDATE person SET car_id = 1 WHERE id = 2;
	SELEC * FROM person;
	SELEC * FROM car;
	--- inner joins
	Combine two tables. Inner joins take whatever is common in the two 	tables. they create a new record that is the join in between two 	tables.
	SELECT * FROM first_table JOIN second_table ON foreing_key
	Ex:
	SELECT * FROM person
	JOIN car ON person.car_id = car.id;
	--- 
	\x expanded display ON/OFF command
	--- select few columns
	SELECT person.first_name, car.male, car.model, car.price
	FROM person
	JOIN car ON person.car_id = car.id; 
	--- Left joins
	SELECT * FROM first_table LEFT JOIN second_table ON foreing_key
	Ex:
	SELECT * FROM person
	LEFT JOIN car ON person.car_id = car.id;
	-- deleting records with foreing key --
	ERROR: update or delete on table "second_table" violates foreign 	key contraint "foreign key" on table "first_table".
	DELETE FROM person WHERE id = 9000
	DELETE FROM car WHERE id = 13
	-- id = 13 estaba relacionado con id = 9000 --
	-- id join column has the same name --
	SELECT * FROM person JOIN car USING (car_id);
	SELECT * FROM person LEFT JOIN car USING (car_id);

Exporting Query Results to CSV
	SELECT * FROM person
	LEFT JOIN car ON person.car_id = car.id;
	\copy (SELECT * FROM person LEFT JOIN car ON person.car_id = car.id;) TO '/User/amigoscode/Desktop/results.csv' DELIMITER ',' CSV HEADER;

Serial & Sequences
	SELECT * FROM person_id_seq;
	SELECT * nextval('person_id_seq'::regclass);
	-- RESTART a SEQUENCE
	ALTER SEQUENCE person_id_seq RESTART WITH 10;
Extensions
	SELECT * FROM pg_available_extensions;
UUID
	universally unique identifier
	SELECT * FROM pg_available_extensions;
	CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
	\?
	\df
	-- references is used to show foreign jey --

	create table car_perrenque (
	car_uid UUID NOT NULL PRIMARY KEY,
	make VARCHAR(100) NOT NULL,
	model VARCHAR(100) NOT NULL,
	price NUMERIC(19, 1) NOT NULL
	);

	create table mock_perrenque (
	perrenque_uid UUID NOT NULL PRIMARY KEY,
	perrenque_name VARCHAR(50) NOT NULL,
	perrenque_lastname VARCHAR(50) NOT NULL,
	perrenque_sex VARCHAR(7) NOT NULL,
	perrenque_date DATE NOT NULL,
	perrenque_email VARCHAR(150),
	perrenque_country VARCHAR(50) NOT NULL
	car_uid UUID REFERENCES car(car_uid),
	UNIQUE(car_uid)
	UNIQUE(perrenque_email)
	);
----insert person

	insert into mock_perrenque (person_ uid, perrenque_name, perrenque_lastname, perrenque_sex, perrenque_date, perrenque_email, perrenque_country) 
	values (uuid_generate_v4(), 'Niki', 'Tales', 'Male', '1997/10/04', 'ntales0@blog.com', 'Yemen');
	insert into mock_perrenque (person_ uid, perrenque_name, perrenque_lastname, perrenque_sex, perrenque_date, perrenque_email, perrenque_country) 
	values (uuid_generate_v4(), 'Noooooooo', 'dddeTales', 'Male', '1997/10/04', 'ntales0@blog.com', 'Yemen');
----insert cars


-------- Introduction to joins (Module 01-022)
----------------------------------------------------------------------

--presidents table
SELECT * 
FROM presidents;

--INNER JOIN in SQL
SELECT p1.country, p1.continent,
       prime_minister, president 
FROM prime_ministers AS p1 
INNER JOIN presidents AS p2 
ON p1.country = p2.country; 

COMANDOS PARA IMPORTAR DATOS

---MOSTRAR CARPETA DONDE SE TOMAN LOS DATOS
SHOW data_directory;
---TE MUESTRA TODO
show all;
--- meter informacion
\copy countries_plus FROM 'C:\Users\Pura Cepa\Documents\countries_plus.csv' DELIMITER ',' CSV HEADER;


----------------------------------------------------------------------

Inner join

PostgreSQL was mentioned in the slides but you'll find that these joins and the material here applies to different forms of SQL as well.

Throughout this course, you'll be working with the countries database containing information about the most populous world cities as well as country-level economic data, population data, and geographic data. This countries database also contains information on languages spoken in each country.

You can see the different tables in this database by clicking on the tabs on the bottom right below query.sql. Click through them to get a sense for the types of data that each table contains before you continue with the course! Take note of the fields that appear to be shared across the tables.

Recall from the video the basic syntax for an INNER JOIN, here including all columns in both tables:

SELECT *
FROM left_table
INNER JOIN right_table
ON left_table.id = right_table.id;

You'll start off with a SELECT statement and then build up to an inner join with the cities and countries tables. Let's get to it!

STEP 1

SELECT * FROM cities;

STEP 2

SELECT * 
FROM cities
  -- 1. Inner join to countries
  INNER JOIN countries
    -- 2. Match on the country codes
    ON cities.country_code = countries.code;

STEP 3

-- 1. Select name fields (with alias) and region 
SELECT cities.name AS city, countries.name AS country, countries.region
FROM cities
  INNER JOIN countries
    ON cities.country_code = countries.code;
----------------------------------------------------------------------

Inner join (2)

Instead of writing the full table name, you can use table aliasing as a shortcut. For tables you also use AS to add the alias immediately after the table name with a space. Check out the aliasing of cities and countries below.

SELECT c1.name AS city, c2.name AS country
FROM cities AS c1
INNER JOIN countries AS c2
ON c1.country_code = c2.code;

Notice that to select a field in your query that appears in multiple tables, you'll need to identify which table/table alias you're referring to by using a . in your SELECT statement.

You'll now explore a way to get data from both the countries and economies tables to examine the inflation rate for both 2010 and 2015.

Sometimes it's easier to write SQL code out of order: you write the SELECT statement after you've done the JOIN.

-- 3. Select fields with aliases
SELECT c.code AS country_code, name, year, inflation_rate
FROM countries AS c
  -- 1. Join to economies (alias e)
  INNER JOIN economies AS e
    -- 2. Match on code
    ON c.code = e.code;

----------------------------------------------------------------------

Inner join (3)

The ability to combine multiple joins in a single query is a powerful feature of SQL, e.g:

SELECT *
FROM left_table
  INNER JOIN right_table
    ON left_table.id = right_table.id
  INNER JOIN another_table
    ON left_table.id = another_table.id;

As you can see here it becomes tedious to continually write long table names in joins. This is when it becomes useful to alias each table using the first letter of its name (e.g. countries AS c)! It is standard practice to alias in this way and, if you choose to alias tables or are asked to specifically for an exercise in this course, you should follow this protocol.

Now, for each country, you want to get the country name, its region, and the fertility rate and unemployment rate for both 2010 and 2015.

Note that results should work throughout this course with or without table aliasing unless specified differently.

STEP 01

-- 4. Select fields
SELECT code, name, region, year, fertility_rate
  -- 1. From countries (alias as c)
  FROM countries AS c
  -- 2. Join with populations (as p)
  INNER JOIN populations AS p
    -- 3. Match on country code
    ON c.code = p.country_code

STEP 02

-- 6. Select fields
SELECT c.code, name, region, e.year, fertility_rate, unemployment_rate
  -- 1. From countries (alias as c)
  FROM countries AS c
  -- 2. Join to populations (as p)
  INNER JOIN populations AS p
    -- 3. Match on country code
    ON c.code = p.country_code
  -- 4. Join to economies (as e)
  INNER JOIN economies AS e
    -- 5. Match on country code
    ON c.code = e.code;

STEP 03

-- 6. Select fields
SELECT c.code, name, region, e.year, fertility_rate, unemployment_rate
  -- 1. From countries (alias as c)
  FROM countries AS c
  -- 2. Join to populations (as p)
  INNER JOIN populations AS p
    -- 3. Match on country code
    ON c.code = p.country_code
  -- 4. Join to economies (as e)
  INNER JOIN economies AS e
    -- 5. Match on country code and year
    ON c.code = e.code AND e.year = p.year;

----------------------------------------------------------------------

VIDEO

INNER JOIN via USING 

SELECT p1.country, p1.continent, prime_minister, president 
FROM presidents AS p1 
INNER JOIN prime_ministers AS p2 
USING (country);

----------------------------------------------------------------------

Inner join with using

When joining tables with a common field name, e.g.

SELECT *
FROM countries
  INNER JOIN economies
    ON countries.code = economies.code

You can use USING as a shortcut:

SELECT *
FROM countries
  INNER JOIN economies
    USING(code)

You'll now explore how this can be done with the countries and languages tables.

-- 4. Select fields
SELECT c.name AS country, continent, l.name AS language, official
  -- 1. From countries (alias as c)
  FROM countries AS c
  -- 2. Join to languages (as l)
  INNER JOIN languages AS l
    -- 3. Match using code
    USING(code);

----------------------------------------------------------------------

VIDEO

Self-ish joins, just in CASE 

SELECT p1.country AS country1, p2.country AS country2, p1.continent 
FROM prime_ministers AS p1 
INNER JOIN prime_ministers AS p2 
ON p1.continent = p2.continent 
LIMIT 14; 

-- Finishing off the self-join on prime_ministers
SELECT p1.country AS country1, p2.country AS country2, p1.continent 
FROM prime_ministers AS p1 
INNER JOIN prime_ministers AS p2 
ON p1.continent = p2.continent AND p1.country <> p2.country 
LIMIT 13; 

-- CASE WHEN and THEN
--Preparing indep_year_group in states
SELECT name, continent, indep_year,
     CASE WHEN ___ < ___  THEN 'before 1900'
         WHEN indep_year <= 1930 THEN '___'
         ELSE '___' END
         AS indep_year_group 
FROM states 
ORDER BY indep_year_group; 

-- Creating indep_year_group in states
SELECT name, continent, indep_year,
    CASE WHEN indep_year < 1900 THEN 'before 1900'
         WHEN indep_year <= 1930 THEN 'between 1900 and 1930'
         ELSE 'after 1930' END
         AS indep_year_group 
FROM states 
ORDER BY indep_year_group; 

----------------------------------------------------------------------

Self-join

In this exercise, you'll use the populations table to perform a self-join to calculate the percentage increase in population from 2010 to 2015 for each country code!

Since you'll be joining the populations table to itself, you can alias populations as p1 and also populations as p2. This is good practice whenever you are aliasing and your tables have the same first letter. Note that you are required to alias the tables with self-joins.

STEP 01

-- 4. Select fields with aliases
SELECT p1.country_code,
p1.size AS size2010,
p2.size AS size2015
-- 1. From populations (alias as p1)
FROM populations AS p1 
  -- 2. Join to itself (alias as p2)
  INNER JOIN populations AS p2 
    -- 3. Match on country code
    USING(country_code)

STEP 02

-- 5. Select fields with aliases
SELECT p1.country_code,
       p1.size AS size2010,
       p2.size AS size2015
-- 1. From populations (alias as p1)
FROM populations as p1
  -- 2. Join to itself (alias as p2)
  INNER JOIN populations as p2
    -- 3. Match on country code
    ON p1.country_code = p2.country_code
        -- 4. and year (with calculation)
        AND p1.year = p2.year - 5

STEP 03

SELECT p1.country_code,
       p1.size AS size2010, 
       p2.size AS size2015,
       -- 1. calculate growth_perc
       ((p2.size - p1.size)/p1.size * 100.0) AS growth_perc
-- 2. From populations (alias as p1)
FROM populations AS p1
  -- 3. Join to itself (alias as p2)
  INNER JOIN populations AS p2
    -- 4. Match on country code
    ON p1.country_code = p2.country_code
        -- 5. and year (with calculation)
        AND p1.year = p2.year - 5;

----------------------------------------------------------------------

Case when and then

Often it's useful to look at a numerical field not as raw data, but instead as being in different categories or groups.

You can use CASE with WHEN, THEN, ELSE, and END to define a new grouping field.

SELECT name, continent, code, surface_area,
    -- 1. First case
    CASE WHEN surface_area > 2000000 THEN 'large'
        -- 2. Second case
        WHEN  surface_area > 350000 THEN 'medium'
        -- 3. Else clause + end
        ELSE 'small' END
        -- 4. Alias name
        AS geosize_group
-- 5. From table
FROM countries;

----------------------------------------------------------------------

Inner challenge

The table you created with the added geosize_group field has been loaded for you here with the name countries_plus. Observe the use of (and the placement of) the INTO command to create this countries_plus table:

SELECT name, continent, code, surface_area,
    CASE WHEN surface_area > 2000000
            THEN 'large'
       WHEN surface_area > 350000
            THEN 'medium'
       ELSE 'small' END
       AS geosize_group
INTO countries_plus
FROM countries;

You will now explore the relationship between the size of a country in terms of surface area and in terms of population using grouping fields created with CASE.

By the end of this exercise, you'll be writing two queries back-to-back in a single script. You got this!

STEP 01

SELECT country_code, size,
    -- 1. First case
    CASE WHEN size > 50000000 THEN 'large'
        -- 2. Second case
       WHEN size > 1000000 THEN 'medium'
        -- 3. Else clause + end
        ELSE 'small' END
        -- 4. Alias name (popsize_group)
        AS popsize_group
-- 5. From table
FROM populations
-- 6. Focus on 2015
WHERE year = 2015;

STEP 02

SELECT country_code, size,
    CASE WHEN size > 50000000 THEN 'large'
        WHEN size > 1000000 THEN 'medium'
        ELSE 'small' END
        AS popsize_group
-- 1. Into table
INTO pop_plus
FROM populations
WHERE year = 2015;

-- 2. Select all columns of pop_plus
SELECT * FROM pop_plus;

STEP 03

SELECT country_code, size,
  CASE WHEN size > 50000000
            THEN 'large'
       WHEN size > 1000000
            THEN 'medium'
       ELSE 'small' END
       AS popsize_group
INTO pop_plus       
FROM populations
WHERE year = 2015;

-- 5. Select fields
SELECT name, continent, geosize_group, popsize_group
-- 1. From countries_plus (alias as c)
FROM countries_plus AS c
  -- 2. Join to pop_plus (alias as p)
  INNER JOIN pop_plus AS p
    -- 3. Match on country code
    ON c.code = p.country_code
-- 4. Order the table    
ORDER BY geosize_group;

-------- Outer joins and cross joins (Module 02-022)
----------------------------------------------------------------------

VIDEO

--The syntax of a LEFT JOIN
SELECT p1.country, prime_minister, president 
FROM prime_ministers AS p1 
LEFT JOIN presidents AS p2 
ON p1.country = p2.country; 

--RIGHT JOIN
SELECT right_table.id AS R_id,
         left_table.val AS L_val,
         right_table.val AS R_val 
FROM left_table 
RIGHT JOIN right_table 
ON left_table.id = right_table.id; 

----------------------------------------------------------------------

Left Join

Now you'll explore the differences between performing an inner join and a left join using the cities and countries tables.

You'll begin by performing an inner join with the cities table on the left and the countries table on the right. Remember to alias the name of the city field as city and the name of the country field as country.

You will then change the query to a left join. Take note of how many records are in each query here!

STEP 01

-- Select the city name (with alias), the country code,
-- the country name (with alias), the region,
-- and the city proper population
SELECT c1.name AS city, code, c2.name AS country,
       region, city_proper_pop
-- From left table (with alias)
FROM cities AS c1
  -- Join to right table (with alias)
  INNER JOIN countries AS c2
    -- Match on country code
    ON c1.country_code = c2.code
-- Order by descending country code
ORDER BY code DESC;

STEP 02

SELECT c1.name AS city, code, c2.name AS country,
       region, city_proper_pop
FROM cities AS c1
  -- 1. Join right table (with alias)
  LEFT JOIN countries AS c2
    -- 2. Match on country code
    ON c1.country_code = c2.code
-- 3. Order by descending country code
ORDER BY code DESC;

----------------------------------------------------------------------

Left join (2)

Next, you'll try out another example comparing an inner join to its corresponding left join. Before you begin though, take note of how many records are in both the countries and languages tables below.

You will begin with an inner join on the countries table on the left with the languages table on the right. Then you'll change the code to a left join in the next bullet.

Note the use of multi-line comments here using /* and */.

STEP 01

/*
5. Select country name AS country, the country's local name,
the language name AS language, and
the percent of the language spoken in the country
*/

SELECT c.name AS country, local_name, l.name AS language, percent
-- 1. From left table (alias as c)
FROM countries AS c
  -- 2. Join to right table (alias as l)
  INNER JOIN languages AS l
    -- 3. Match on fields
    ON c.code = l.code
-- 4. Order by descending country
ORDER BY country DESC;

STEP 02

/*
5. Select country name AS country, the country's local name,
the language name AS language, and
the percent of the language spoken in the country
*/
SELECT c.name AS country, local_name, l.name AS language, percent
-- 1. From left table (alias as c)
FROM countries AS c
  -- 2. Join to right table (alias as l)
  LEFT JOIN languages AS l
    -- 3. Match on fields
    ON c.code = l.code
-- 4. Order by descending country
ORDER BY country DESC;

----------------------------------------------------------------------
/*

Left join (3)

You'll now revisit the use of the AVG() function introduced in our Intro to SQL for Data Science course. You will use it in combination with left join to determine the average gross domestic product (GDP) per capita by region in 2010.

STEP 01

-- 5. Select name, region, and gdp_percapita
SELECT name, region, gdp_percapita
-- 1. From countries (alias as c)
FROM countries AS c
  -- 2. Left join with economies (alias as e)
  LEFT JOIN economies AS e
    -- 3. Match on code fields
    ON c.code = e.code
-- 4. Focus on 2010
WHERE year = 2010;

STEP 02

-- Select fields
SELECT region, AVG(gdp_percapita) AS avg_gdp
-- From countries (alias as c)
FROM countries AS c
  -- Left join with economies (alias as e)
  LEFT JOIN economies AS e
    -- Match on code fields
    ON c.code = e.code
-- Focus on 2010
WHERE year = 2010
-- Group by region
GROUP BY region;

STEP 03

-- Select fields
SELECT region, AVG(gdp_percapita) AS avg_gdp
-- From countries (alias as c)
FROM countries AS c
  -- Left join with economies (alias as e)
  LEFT JOIN economies AS e
    -- Match on code fields
    ON c.code = e.code
-- Focus on 2010
WHERE year = 2010
-- Group by region
GROUP BY region
-- Order by descending avg_gdp
ORDER BY avg_gdp DESC;

----------------------------------------------------------------------

Right join

Right joins aren't as common as left joins. One reason why is that you can always write a right join as a left join.

-- convert this code to use RIGHT JOINs instead of LEFT JOINs
/*
SELECT cities.name AS city, urbanarea_pop, countries.name AS country,
       indep_year, languages.name AS language, percent
FROM cities
  LEFT JOIN countries
    ON cities.country_code = countries.code
  LEFT JOIN languages
    ON countries.code = languages.code
ORDER BY city, language;
*/
/*
SELECT cities.name AS city, urbanarea_pop, countries.name AS country,
       indep_year, languages.name AS language, percent
FROM languages
  RIGHT JOIN countries
    ON languages.code = countries.code
  RIGHT JOIN cities
    ON countries.code = cities.country_code
ORDER BY city, language;

----------------------------------------------------------------------

VIDEO

FULL JOINs 

SELECT left_table.id AS L_id,
       right_table.id AS R_id,
       left_table.val AS L_val,
       right_table.val AS R_val 
FROM left_table 
FULL JOIN right_table 
USING (id);

Ex:

SELECT p1.country AS pm_co, p2.country AS pres_co,
     prime_minister, president 
FROM prime_ministers AS p1 
FULL JOIN presidents AS p2 
ON p1.country = p2.country; 

----------------------------------------------------------------------

Full join

In this exercise, you'll examine how your results differ when using a full join versus using a left join versus using an inner join with the countries and currencies tables.

You will focus on the North American region and also where the name of the country is missing. Dig in to see what we mean!

Begin with a full join with countries on the left and currencies on the right. The fields of interest have been SELECTed for you throughout this exercise.

Then complete a similar left join and conclude with an inner join.

STEP 01

SELECT name AS country, code, region, basic_unit
-- 3. From countries
FROM countries
  -- 4. Join to currencies
  FULL JOIN currencies
    -- 5. Match on code
    USING (code)
-- 1. Where region is North America or null
WHERE region = 'North America' OR region IS NULL
-- 2. Order by region
ORDER BY region;

STEP 02

SELECT name AS country, code, region, basic_unit
-- 1. From countries
FROM countries
  -- 2. Join to currencies
  LEFT JOIN currencies
    -- 3. Match on code
    USING (code)
-- 4. Where region is North America or null
WHERE region = 'North America' OR region IS NULL
-- 5. Order by region
ORDER BY region;

STEP 03

SELECT name AS country, code, region, basic_unit
FROM countries
  -- 1. Join to currencies
  INNER JOIN currencies
    USING (code)
-- 2. Where region is North America or null
WHERE region = 'North America' OR region IS NULL
-- 3. Order by region
ORDER BY region;

----------------------------------------------------------------------

Full join (2)

You'll now investigate a similar exercise to the last one, but this time focused on using a table with more records on the left than the right. You'll work with the languages and countries tables.

Begin with a full join with languages on the left and countries on the right. Appropriate fields have been selected for you again here.

STEP 01

SELECT countries.name, code, languages.name AS language
-- 3. From languages
FROM languages
  -- 4. Join to countries
  FULL JOIN countries
    -- 5. Match on code
    USING (code)
-- 1. Where countries.name starts with V or is null
WHERE countries.name LIKE 'V%' OR countries.name IS NULL
-- 2. Order by ascending countries.name
ORDER BY countries.name;

STEP 02

SELECT countries.name, code, languages.name AS language
FROM languages
  -- 1. Join to countries
  LEFT JOIN countries
    -- 2. Match using code
    USING (code)
-- 3. Where countries.name starts with V or is null
WHERE countries.name LIKE 'V%' OR countries.name IS NULL
ORDER BY countries.name;

STEP 03

SELECT countries.name, code, languages.name AS language
FROM languages
  -- 1. Join to countries
  INNER JOIN countries
    USING (code)
-- 2. Where countries.name starts with V or is null
WHERE countries.name LIKE 'V%' OR countries.name IS NULL
ORDER BY countries.name;

----------------------------------------------------------------------

Full join (3)

You'll now explore using two consecutive full joins on the three tables you worked with in the previous two exercises.

-- 7. Select fields (with aliases)
SELECT c1.name AS country, region, l.name AS language,
       	basic_unit, frac_unit
-- 1. From countries (alias as c1)
FROM countries AS c1
  -- 2. Join with languages (alias as l)
  FULL JOIN languages AS l
    -- 3. Match on code
    USING (code)
  -- 4. Join with currencies (alias as c2)
  FULL JOIN currencies AS c2
    -- 5. Match on code
    USING (code)
-- 6. Where region like Melanesia and Micronesia
WHERE region LIKE 'M%esia';

----------------------------------------------------------------------

CROSSing the Rubicon 

SELECT prime_minister, president 
FROM prime_ministers AS p1 
CROSS JOIN presidents AS p2 
WHERE p1.continent IN ('North America', 'Oceania');

----------------------------------------------------------------------

A table of two cities

This exercise looks to explore languages potentially and most frequently spoken in the cities of Hyderabad, India and Hyderabad, Pakistan.

You will begin with a cross join with cities AS c on the left and languages AS l on the right. Then you will modify the query using an inner join in the next tab.

STEP 01

-- 4. Select fields
SELECT c.name AS city, l.name AS language
-- 1. From cities (alias as c)
FROM cities AS c        
  -- 2. Join to languages (alias as l)
  CROSS JOIN languages AS l
-- 3. Where c.name like Hyderabad
WHERE c.name LIKE 'Hyder%';

STEP 02

-- 5. Select fields
SELECT c.name AS city, l.name AS language
-- 1. From cities (alias as c)
FROM cities AS c
  -- 2. Join to languages (alias as l)
  INNER JOIN languages AS l
    -- 3. Match on country code
    ON c.country_code = l.code
-- 4. Where c.name like Hyderabad
WHERE c.name LIKE 'Hyder%';

----------------------------------------------------------------------

Outer challenge

Now that you're fully equipped to use outer joins, try a challenge problem to test your knowledge!

In terms of life expectancy for 2010, determine the names of the lowest five countries and their regions.

-- Select fields
SELECT c.name AS country, region, p.life_expectancy AS life_exp
-- From countries (alias as c)
FROM countries AS c
  -- Join to populations (alias as p)
  LEFT JOIN populations AS p
    -- Match on country code
    ON c.code = p.country_code
-- Focus on 2010
WHERE year = 2010
-- Order by life_exp
ORDER BY life_exp
-- Limit to 5 records
LIMIT 5;

-------- Set theory clauses  (Module 03-022)
----------------------------------------------------------------------

--State of the UNION 

--Set Theory Venn Diagrams
--UNION, UNION ALL, INTERSEXT, EXCEPT

-- All prime ministers and monarchs
SELECT prime_minister AS leader, country 
FROM prime_ministers 
UNION 
SELECT monarch, country 
FROM monarchs 
ORDER BY country;

-- UNION ALL with leaders
SELECT prime_minister AS leader, country 
FROM prime_ministers 
UNION ALL
SELECT monarch, country 
FROM monarchs 
ORDER BY country
LIMIT 10;

----------------------------------------------------------------------

Union

Near query result to the right, you will see two new tables with names economies2010 and economies2015.

-- Select fields from 2010 table
SELECT *
  -- From 2010 table
  FROM economies2010
	-- Set theory clause
	UNION
-- Select fields from 2015 table
SELECT *
  -- From 2015 table
  FROM economies2015
-- Order by code and year
ORDER BY code, year;

----------------------------------------------------------------------

Union (2)

UNION can also be used to determine all occurrences of a field across multiple tables. Try out this exercise with no starter code.

-- Select field
SELECT country_code
  -- From cities
  FROM cities
	-- Set theory clause
	UNION
-- Select field
SELECT code
  -- From currencies
  FROM currencies
-- Order by country_code
ORDER BY country_code;

----------------------------------------------------------------------

Union all

As you saw, duplicates were removed from the previous two exercises by using UNION.

To include duplicates, you can use UNION ALL.

-- Select fields
SELECT code, year
  -- From economies
  FROM economies
	-- Set theory clause
	UNION ALL
-- Select fields
SELECT country_code, year
  -- From populations
  FROM populations
-- Order by code, year
ORDER BY code, year;

----------------------------------------------------------------------

-- INTERSECTional data science 

-- INTERSECT diagram and SQL code

SELECT id 
FROM left_one 
INTERSECT 
SELECT id 
FROM right_one; 

Prime minister and president countries

SELECT country 
FROM prime_ministers 
INTERSECT 
SELECT country 
FROM presidents;

INTERSECT on two elds

SELECT country, prime_minister AS leader 
FROM prime_ministers 
INTERSECT 
SELECT country, president 
FROM presidents; 

----------------------------------------------------------------------

Intersect

Repeat the previous UNION ALL exercise, this time looking at the records in common for country code and year for the economies and populations tables.

-- Select fields
SELECT code, year
  -- From economies
  FROM economies
	-- Set theory clause
	INTERSECT
-- Select fields
SELECT country_code, year
  -- From populations
  FROM populations
-- Order by code and year
ORDER BY code, year;

----------------------------------------------------------------------

Intersect (2)

As you think about major world cities and their corresponding country, you may ask which countries also have a city with the same name as their country name?

-- Select fields
SELECT name
  -- From countries
  FROM countries
	-- Set theory clause
	INTERSECT
-- Select fields
SELECT name
  -- From cities
  FROM cities;

----------------------------------------------------------------------

EXCEPTional

SELECT monarch, country 
FROM monarchs 
EXCEPT 
SELECT prime_minister, country 
FROM prime_ministers; 

----------------------------------------------------------------------

Except

Get the names of cities in cities which are not noted as capital cities in countries as a single field result.

Note that there are some countries in the world that are not included in the countries table, which will result in some cities not being labeled as capital cities when in fact they are.

-- Select field
SELECT name
  -- From cities
  FROM cities
	-- Set theory clause
	EXCEPT
-- Select field
SELECT capital
  -- From countries
  FROM countries
-- Order by result
ORDER BY name;

----------------------------------------------------------------------

Except (2)

Now you will complete the previous query in reverse!

Determine the names of capital cities that are not listed in the cities table.

-- Select field
SELECT capital
  -- From countries
  FROM countries
	-- Set theory clause
	EXCEPT
-- Select field
SELECT name
  -- From cities
  FROM cities
-- Order by ascending capital
ORDER BY capital;

----------------------------------------------------------------------

-- Semi-joins and Antijoins 

--The semi-join chooses records in the first table where a condition IS met in a second table

	--Finish the semi-join (an intro to subqueries)
	SELECT president, country, continent 
	FROM presidents 
	WHERE country IN    
		(SELECT name     
		 FROM states     
		 WHERE indep_year < 1800); 


An anti-join choose records in the first table where a condition IS NOT met in the second table.

	SELECT president, country, continent 
	FROM presidents 
	WHERE ___ LIKE '___'
	      AND country ___ IN
	         (SELECT name
	          FROM states
	          WHERE indep_year < 1800); 

	SELECT president, country, continent 
	FROM presidents 
	WHERE continent LIKE '%America'
	      AND country NOT IN
	         (SELECT name
	          FROM states
	          WHERE indep_year < 1800);

----------------------------------------------------------------------

Semi-join

You are now going to use the concept of a semi-join to identify languages spoken in the Middle East.

STEP 01

-- Select code
SELECT code
  -- From countries
  FROM countries
-- Where region is Middle East
WHERE region = 'Middle East';

STEP 02

/*
SELECT code
  FROM countries
WHERE region = 'Middle East';
*/
/*
-- Select field
SELECT DISTINCT name
  -- From languages
  FROM languages
-- Order by name
ORDER BY name;

STEP 03
-- Select distinct fields
SELECT DISTINCT name
  -- From languages
  FROM languages
-- Where in statement
WHERE code IN
  -- Subquery
  (SELECT code
   FROM countries
   WHERE region = 'Middle East')
-- Order by name
ORDER BY name;

----------------------------------------------------------------------

Relating semi-join to a tweaked inner join

Let's revisit the code from the previous exercise, which retrieves languages spoken in the Middle East.

SELECT DISTINCT name
FROM languages
WHERE code IN
  (SELECT code
   FROM countries
   WHERE region = 'Middle East')
ORDER BY name;

Sometimes problems solved with semi-joins can also be solved using an inner join.

SELECT languages.name AS language
FROM languages
INNER JOIN countries
ON languages.code = countries.code
WHERE region = 'Middle East'
ORDER BY language;

This inner join isn't quite right. What is missing from this second code block to get it to match with the correct answer produced by the first block?

r: NOT DE SAME THERE IS NOT DISTINC CLAUSE, SO THE SAME LANGUAGE IS REPEATED MULTIPLE TIMES
----------------------------------------------------------------------

Diagnosing problems using anti-join

Another powerful join in SQL is the anti-join. It is particularly useful in identifying which records are causing an incorrect number of records to appear in join queries.

You will also see another example of a subquery here, as you saw in the first exercise on semi-joins. Your goal is to identify the currencies used in Oceanian countries!

STEP 01

-- Select statement
SELECT COUNT(name)
  -- From countries
  FROM countries
-- Where continent is Oceania
WHERE continent = 'Oceania';

STEP 02

-- 5. Select fields (with aliases)
SELECT c1.code, c1.name, basic_unit AS currency
  -- 1. From countries (alias as c1)
  FROM countries AS c1
  	-- 2. Join with currencies (alias as c2)
  	INNER JOIN currencies AS c2
    -- 3. Match on code
    ON c1.code = c2.code
-- 4. Where continent is Oceania
WHERE c1.continent = 'Oceania';

STEP 03

-- 3. Select fields
SELECT code, name
  -- 4. From Countries
  FROM countries
  -- 5. Where continent is Oceania
  WHERE continent = 'Oceania'
  	-- 1. And code not in
  	AND code NOT IN
  	-- 2. Subquery
  	(SELECT code
  	 FROM currencies);

----------------------------------------------------------------------

Set theory challenge

Congratulations! You've now made your way to the challenge problem for this third chapter. Your task here will be to incorporate two of UNION/UNION ALL/INTERSECT/EXCEPT to solve a challenge involving three tables.

In addition, you will use a subquery as you have in the last two exercises! This will be great practice as you hop into subqueries more in Chapter 4!

-- Select the city name
SELECT name
  -- Alias the table where city name resides
  FROM cities AS c1
  -- Choose only records matching the result of multiple set theory clauses
  WHERE country_code IN
(
    -- Select appropriate field from economies AS e
    SELECT e.code
    FROM economies AS e
    -- Get all additional (unique) values of the field from currencies AS c2  
    UNION
    SELECT c2.code
    FROM currencies AS c2
    -- Exclude those appearing in populations AS p
    EXCEPT
    SELECT p.country_code
    FROM populations AS p
);

----------------------------------------------------------------------

-------- Case Study: Subqueries  (Module 04-022)
----------------------------------------------------------------------

--Subqueries inside WHERE and SELECT clauses 

--Subquery inside WHERE clause set-up
---Average fert_rate
SELECT AVG(fert_rate) 
FROM states; 
---Asian countries below average `fert_rate`
SELECT name, fert_rate 
FROM states 
WHERE continent = 'Asia'
      AND fert_rate <
         (SELECT AVG(fert_rate)
          FROM states); 

---Subqueries inside SELECT clauses - setup
SELECT DISTINCT continent 
FROM prime_ministers; 
---Subquery inside SELECT clause - complete
SELECT DISTINCT continent,
    (SELECT COUNT(*)
     FROM states
     WHERE prime_ministers.continent = states.continent) AS countries_num 
FROM prime_ministers; 

----------------------------------------------------------------------

Subquery inside where

You'll now try to figure out which countries had high average life expectancies (at the country level) in 2015.

STEP 01

-- Select average life_expectancy
SELECT AVG(life_expectancy)
  -- From populations
  FROM populations
-- Where year is 2015
WHERE year = 2015;

STEP 02

-- Select fields
SELECT *
  -- From populations
  FROM populations
-- Where life_expectancy is greater than
WHERE life_expectancy > 1.15 *
  -- 1.15 * subquery
  (SELECT AVG(life_expectancy)
   FROM populations
   WHERE year = 2015)
   AND year = 2015;

----------------------------------------------------------------------

Subquery inside where (2)

Use your knowledge of subqueries in WHERE to get the urban area population for only capital cities.

-- 2. Select fields
SELECT name, country_code, urbanarea_pop
  -- 3. From cities
  FROM cities
-- 4. Where city name in the field of capital cities
WHERE name IN
  -- 1. Subquery
  (SELECT capital
   FROM countries)
ORDER BY urbanarea_pop DESC;

----------------------------------------------------------------------

Subquery inside select

In this exercise, you'll see how some queries can be written using either a join or a subquery.

You have seen previously how to use GROUP BY with aggregate functions and an inner join to get summarized information from multiple tables.

The code given in query.sql selects the top nine countries in terms of number of cities appearing in the cities table. Recall that this corresponds to the most populous cities in the world. Your task will be to convert the commented out code to get the same result as the code shown.

STEP 01

SELECT countries.name AS country, COUNT(*) AS cities_num
  FROM cities
    INNER JOIN countries
    ON countries.code = cities.country_code
GROUP BY country
ORDER BY cities_num DESC, country
LIMIT 9;

/* 
SELECT ___ AS ___,
  (SELECT ___
   FROM ___
   WHERE countries.code = cities.country_code) AS cities_num
FROM ___
ORDER BY ___ ___, ___
LIMIT 9;
*/

STEP 02

/* 
SELECT countries.name AS country, COUNT(*) AS cities_num
  FROM cities
    INNER JOIN countries
    ON countries.code = cities.country_code
GROUP BY country
ORDER BY cities_num DESC, country
LIMIT 9;
*/
/*
SELECT countries.name AS country,
  (SELECT COUNT(*)
   FROM cities
   WHERE countries.code = cities.country_code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9;

----------------------------------------------------------------------

--Subquery inside the FROM clause 

---Build-up
SELECT continent, MAX(women_parli_perc) AS max_perc 
FROM states 
GROUP BY continent 
ORDER BY continent; 
---Focusing on records in monarchs
SELECT monarchs.continent 
FROM monarchs, states    
WHERE monarchs.continent = states.continent
 ORDER BY continent; 
---Finishing off the subquery
SELECT DISTINCT monarchs.continent, subquery.max_perc 
FROM monarchs,
    (SELECT continent, MAX(women_parli_perc) AS max_perc
     FROM states
     GROUP BY continent) AS subquery
WHERE monarchs.continent = subquery.continent 
ORDER BY continent; 

----------------------------------------------------------------------

Subquery inside from

The last type of subquery you will work with is one inside of FROM.

You will use this to determine the number of languages spoken for each country, identified by the country's local name! (Note this may be different than the name field and is stored in the local_name field.)

STEP 01

-- Select fields (with aliases)
SELECT code, COUNT(*) AS lang_num
  -- From languages
  FROM languages
-- Group by code
GROUP BY code;

STEP 02

-- Select fields
SELECT local_name, subquery.lang_num
  -- From countries
  FROM countries,
  	-- Subquery (alias as subquery)
  	(SELECT code, COUNT(*) AS lang_num
  	 FROM languages
  	 GROUP BY code) AS subquery
  -- Where codes match
  WHERE countries.code = subquery.code
-- Order by descending number of languages
ORDER BY lang_num DESC;

----------------------------------------------------------------------

Advanced subquery

You can also nest multiple subqueries to answer even more specific questions.

In this exercise, for each of the six continents listed in 2015, you'll identify which country had the maximum inflation rate (and how high it was) using multiple subqueries. The table result of your query in Task 3 should look something like the following, where anything between < > will be filled in with appropriate values:

+------------+---------------+-------------------+
| name       | continent     | inflation_rate    |
|------------+---------------+-------------------|
| <country1> | North America | <max_inflation1>  |
| <country2> | Africa        | <max_inflation2>  |
| <country3> | Oceania       | <max_inflation3>  |
| <country4> | Europe        | <max_inflation4>  |
| <country5> | South America | <max_inflation5>  |
| <country6> | Asia          | <max_inflation6>  |
+------------+---------------+-------------------+

Again, there are multiple ways to get to this solution using only joins, but the focus here is on showing you an introduction into advanced subqueries.

STEP 01

-- Select fields
SELECT name, continent, inflation_rate
  -- From countries
  FROM countries
  	-- Join to economies
  	INNER JOIN economies
    -- Match on code
    USING(code)
-- Where year is 2015
WHERE year = 2015;

STEP 02

-- Select fields
SELECT MAX(inflation_rate) AS max_inf
  -- Subquery using FROM (alias as subquery)
  FROM (
      SELECT name, continent, inflation_rate
      FROM countries
      INNER JOIN economies
      USING(code)
      WHERE year = 2015) AS subquery
-- Group by continent
GROUP BY continent;

STEP 03

-- Select fields
SELECT name, continent, inflation_rate
  -- From countries
  FROM countries
	-- Join to economies
	INNER JOIN economies
	-- Match on code
	ON countries.code = economies.code
  -- Where year is 2015
   WHERE year = 2015
    -- And inflation rate in subquery (alias as subquery)
    AND inflation_rate IN (
        SELECT MAX(inflation_rate) AS max_inf
        FROM  (
             SELECT name, continent, inflation_rate
             FROM countries
             INNER JOIN economies
             ON countries.code = economies.code
             WHERE year = 2015) AS subquery
        GROUP BY continent);

----------------------------------------------------------------------

Subquery challenge

Let's test your understanding of the subqueries with a challenge problem! Use a subquery to get 2015 economic data for countries that do not have

    gov_form of 'Constitutional Monarchy' or
    'Republic' in their gov_form.

Here, gov_form stands for the form of the government for each country. Review the different entries for gov_form in the countries table.

-- Select fields
SELECT code, inflation_rate, unemployment_rate
  -- From economies
  FROM economies
  -- Where year is 2015 and code is not in
  WHERE year = 2015 AND code NOT IN
  	-- Subquery
  	(SELECT code
  	 FROM countries
  	 WHERE (gov_form = 'Constitutional Monarchy' OR gov_form LIKE '%Republic%'))
-- Order by inflation rate
ORDER BY inflation_rate;

----------------------------------------------------------------------

Final challenge

Welcome to the end of the course! The next three exercises will test your knowledge of the content covered in this course and apply many of the ideas you've seen to difficult problems. Good luck!

Read carefully over the instructions and solve them step-by-step, thinking about how the different clauses work together.

In this exercise, you'll need to get the country names and other 2015 data in the economies table and the countries table for Central American countries with an official language.

-- Select fields
SELECT DISTINCT name, total_investment, imports
  -- From table (with alias)
  FROM countries AS c
    -- Join with table (with alias)
    LEFT JOIN economies AS e
      -- Match on code
      ON (c.code = e.code
      -- and code in Subquery
        AND c.code IN (
          SELECT l.code
          FROM languages AS l
          WHERE official = 'true'
        ) )
  -- Where region and year are correct
  WHERE region = 'Central America' AND year = 2015
-- Order by field
ORDER BY name;

----------------------------------------------------------------------

Final challenge (2)

Whoofta! That was challenging, huh?

Let's ease up a bit and calculate the average fertility rate for each region in 2015.

-- Select fields
SELECT region, continent, AVG(fertility_rate) AS avg_fert_rate
  -- From left table
  FROM countries AS c
    -- Join to right table
    INNER JOIN populations AS p
      -- Match on join condition
      ON c.code = p.country_code
  -- Where specific records matching some condition
  WHERE year = 2015
-- Group appropriately
GROUP BY region, continent
-- Order appropriately
ORDER BY avg_fert_rate;

----------------------------------------------------------------------

Final challenge (3)

Welcome to the last challenge problem. By now you're a query warrior! Remember that these challenges are designed to take you to the limit to solidify your SQL knowledge! Take a deep breath and solve this step-by-step.

You are now tasked with determining the top 10 capital cities in Europe and the Americas in terms of a calculated percentage using city_proper_pop and metroarea_pop in cities.

Do not use table aliasing in this exercise.

-- Select fields
SELECT cities.name, country_code, city_proper_pop, metroarea_pop,  
      -- Calculate city_perc
      city_proper_pop / metroarea_pop * 100 AS city_perc
  -- From appropriate table
  FROM cities
  -- Where 
  WHERE name IN
    -- Subquery
    (SELECT capital
     FROM countries
     WHERE (continent = 'Europe'
        OR continent LIKE '%America'))
       AND metroarea_pop IS NOT NULL
-- Order appropriately
ORDER BY city_perc DESC
-- Limit amount
LIMIT 10;

----------------------------------------------------------------------

-- END

*/

