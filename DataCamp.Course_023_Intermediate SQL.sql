/*
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------

-- COURSE 23 Intermediate SQL_023

######################################################################
######################################################################
######################################################################

######## We'll take the CASE (Module 01-023)
######################################################################

CASE statements
Contains a WHEN , THEN , and ELSE statement, nished with END

CASE WHEN x = 1 THEN 'a'       
WHEN x = 2 THEN 'b'     
ELSE 'c' END AS new_column 

CASE WHEN
SELECT
   id,
    home_goal,
    away_goal,
    CASE WHEN home_goal > away_goal THEN 'Home Team Win'
    WHEN home_goal < away_goal THEN 'Away Team Win'
    ELSE 'Tie' END AS outcome 
FROM match 
WHERE season = '2013/2014';

#---------------------------------------------------------------------

Basic CASE statements
What is your favorite team?

The European Soccer Database contains data about 12,800 matches from 11 countries played between 2011-2015! Throughout this course, you will be shown filtered versions of the tables in this database in order to better explore their contents.

In this exercise, you will identify matches played between FC Schalke 04 and FC Bayern Munich. There are 2 teams identified in each match in the hometeam_id and awayteam_id columns, available to you in the filtered matches_germany table. ID can join to the team_api_id column in the teams_germany table, but you cannot perform a join on both at the same time.

However, you can perform this operation using a CASE statement once you've identified the team_api_id associated with each team!

Please note that you can reference the slides from the video on the TOP RIGHT of your screen!

STEP 01

SELECT
	-- Select the team long name and team API id
	team_long_name,
	team_api_id
FROM teams_germany
-- Only include FC Schalke 04 and FC Bayern Munich
WHERE team_long_name IN ('FC Schalke 04', 'FC Bayern Munich');

STEP 02

-- Identify the home team as Bayern Munich, Schalke 04, or neither
SELECT 
	CASE WHEN hometeam_id = 10189 THEN 'FC Schalke 04'
        WHEN hometeam_id = 9823 THEN 'FC Bayern Munich'
         ELSE 'Other' END AS home_team,
	COUNT(id) AS total_matches
FROM matches_germany
-- Group by the CASE statement alias
GROUP BY home_team;

#---------------------------------------------------------------------

CASE statements comparing column values

Barcelona is considered one of the strongest teams in Spain's soccer league.

In this exercise, you will be creating a list of matches in the 2011/2012 season where Barcelona was the home team. You will do this using a CASE statement that compares the values of two columns to create a new group -- wins, losses, and ties.

In 3 steps, you will build a query that identifies a match's winner, identifies the identity of the opponent, and finally filters for Barcelona as the home team. Completing a query in this order will allow you to watch your results take shape with each new piece of information.

The matches_spain table currently contains Barcelona's matches from the 2011/2012 season, and has two key columns, hometeam_id and awayteam_id, that can be joined with the teams

STEP 01

SELECT 
	-- Select the date of the match
	date,
	-- Identify home wins, losses, or ties
	CASE WHEN home_goal > away_goal THEN 'Home win!'
        WHEN home_goal < away_goal THEN 'Home loss :(' 
        ELSE 'Tie' END AS outcome
FROM matches_spain;

STEP 02

SELECT 
	m.date,
	--Select the team long name column and call it 'opponent'
	t.team_long_name AS opponent, 
	-- Complete the CASE statement with an alias
	CASE WHEN m.home_goal > m.away_goal THEN 'Home win!'
        WHEN m.home_goal < m.away_goal THEN 'Home loss :('
        ELSE 'Tie' END AS outcome
FROM matches_spain AS m
-- Left join teams_spain onto matches_spain
LEFT JOIN teams_spain AS t
ON m.awayteam_id = t.team_api_id;

STEP 03

SELECT 
	m.date,
	t.team_long_name AS opponent,
    -- Complete the CASE statement with an alias
	CASE WHEN m.home_goal > m.away_goal THEN 'Barcelona win!'
        WHEN m.home_goal < m.away_goal THEN 'Barcelona loss :(' 
        ELSE 'Tie' END AS outcome 
FROM matches_spain AS m
LEFT JOIN teams_spain AS t 
ON m.awayteam_id = t.team_api_id
-- Filter for Barcelona as the home team
WHERE m.hometeam_id = 8634; 

#---------------------------------------------------------------------

CASE statements comparing two column values part 2
Similar to the previous exercise, you will construct a query to determine the outcome of Barcelona's matches where they played as the away team. You will learn how to combine these two queries in chapters 2 and 3.

Did their performance differ from the matches where they were the home team?

-- Select matches where Barcelona was the away team
SELECT  
	m.date,
	t.team_long_name AS opponent,
	CASE WHEN m.home_goal < m.away_goal THEN 'Barcelona win!'
	WHEN m.home_goal > m.away_goal THEN 'Barcelona loss :(' 
        ELSE 'Tie' END AS outcome
FROM matches_spain AS m
-- Join teams_spain to matches_spain
LEFT JOIN teams_spain AS t 
ON m.hometeam_id = t.team_api_id
WHERE m.awayteam_id = 8634;

#---------------------------------------------------------------------

Video:In CASE things get more complex

CASE WHEN ... AND then some (it means adding logical operators)

SELECT date, hometeam_id, awayteam_id,
CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
THEN 'Chelsea home win!'
WHEN awayteam_id = 8455 AND home_goal < away_goal
THEN 'Chelsea away win!'
ELSE 'Loss or tie :(' END AS outcome
FROM match
WHERE hometeam_id = 8455 OR awayteam_id = 8455;

--->

SELECT date, hometeam_id, awayteam_id,
CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
THEN 'Chelsea home win!'
WHEN awayteam_id = 8455 AND home_goal < away_goal
THEN 'Chelsea away win!'
ELSE 'Loss or tie :(' END AS outcome
FROM match;

____
NULL

SELECT date,
CASE WHEN date > '2015-01-01' THEN 'More Recently'
WHEN date < '2012-01-01' THEN 'Older'
END AS date_category
FROM match;
SELECT date,
CASE WHEN date > '2015-01-01' THEN 'More Recently'
WHEN date < '2012-01-01' THEN 'Older'
ELSE NULL END AS date_category
FROM match;

___
What are your NULL values doing?

SELECT date, season,
CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
THEN 'Chelsea home win!'
WHEN awayteam_id = 8455 AND home_goal < away_goal
THEN 'Chelsea away win!'
END AS outcome
FROM match
WHERE hometeam_id = 8455 OR awayteam_id = 8455;

____
Where to place your CASE?

SELECT date, season,
CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
THEN 'Chelsea home win!'
WHEN awayteam_id = 8455 AND home_goal < away_goal
THEN 'Chelsea away win!' END AS outcome
FROM match;

SELECT date, season,
CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
THEN 'Chelsea home win!'
WHEN awayteam_id = 8455 AND home_goal < away_goal
THEN 'Chelsea away win!' END AS outcome
FROM match
WHERE CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
THEN 'Chelsea home win!'
WHEN awayteam_id = 8455 AND home_goal < away_goal
THEN 'Chelsea away win!' END IS NOT NULL;

#---------------------------------------------------------------------

In CASE of rivalry
Barcelona and Real Madrid have been rival teams for more than 80 years. Matches between these two teams are given the name El Clásico (The Classic). In this exercise, you will query a list of matches played between these two rivals.

You will notice in Step 2 that when you have multiple logical conditions in a CASE statement, you may quickly end up with a large number of WHEN clauses to logically test every outcome you are interested in. It's important to make sure you don't accidentally exclude key information in your ELSE clause.

In this exercise, you will retrieve information about matches played between Barcelona (id = 8634) and Real Madrid (id = 8633). Note that the query you are provided with already identifies the Clásico matches using a filter in the WHERE clause.

STEP01

SELECT 
	date,
	-- Identify the home team as Barcelona or Real Madrid
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
        ELSE 'Real Madrid CF' END AS home,
    -- Identify the away team as Barcelona or Real Madrid
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
        ELSE 'Real Madrid CF' END AS away
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);

STEP02

SELECT 
	date,
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END AS home,
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END AS away,
	-- Identify all possible match outcomes
	CASE WHEN home_goal > away_goal AND hometeam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal > away_goal AND hometeam_id = 8633 THEN 'Real Madrid win!'
        WHEN home_goal < away_goal AND awayteam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal < away_goal AND awayteam_id = 8633 THEN 'Real Madrid win!'
        ELSE 'Tie!' END AS outcome
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);


#---------------------------------------------------------------------

Filtering your CASE statement
Let's generate a list of matches won by Italy's Bologna team! There are quite a few additional teams in the two tables, so a key part of generating a usable query will be using your CASE statement as a filter in the WHERE clause.

CASE statements allow you to categorize data that you're interested in -- and exclude data you're not interested in. In order to do this, you can use a CASE statement as a filter in the WHERE statement to remove output you don't want to see.

Here is how you might set that up:

SELECT *
FROM table
WHERE 
    CASE WHEN a > 5 THEN 'Keep'
         WHEN a <= 5 THEN 'Exclude' END = 'Keep';
In essence, you can use the CASE statement as a filtering column like any other column in your database. The only difference is that you don't alias the statement in WHERE.

STEP01

-- Select team_long_name and team_api_id from team
SELECT
	team_long_name,
	team_api_id
FROM teams_italy
-- Filter for team name
WHERE team_long_name = 'Bologna';

STEP02

-- Select the season and date columns
SELECT 
	season,
	date,
    -- Identify when Bologna won a match
	CASE WHEN hometeam_id = 9857 AND home_goal > away_goal THEN 'Bologna Win'
		WHEN awayteam_id = 9857 AND away_goal > home_goal THEN 'Bologna Win' 
		END AS outcome
FROM matches_italy;

STEP03

-- Select the season, date, home_goal, and away_goal columns
SELECT 
	season,
    date,
	home_goal,
	away_goal
FROM matches_italy
WHERE 
-- Exclude games not won by Bologna
	CASE WHEN hometeam_id = 9857 AND home_goal > away_goal THEN 'Bologna Win'
		WHEN awayteam_id = 9857 AND away_goal > home_goal THEN 'Bologna Win' 
		END IS NOT NULL;

#---------------------------------------------------------------------

VIDEO: CASE WHEN with aggregate functions

In CASE you need to aggregate
CASE statements are great for
1. Categorizing data
2. Filtering data
3. Aggregating data

SELECT
	season,
	COUNT(CASE WHEN hometeam_id = 8650
		AND home_goal > away_goal
		THEN id END) AS home_wins
FROM match
GROUP BY season;

CASE WHEN with COUNT

SELECT
	season,
	COUNT(CASE WHEN hometeam_id = 8650 AND home_goal > away_goal
		THEN id END) AS home_wins,
	COUNT(CASE WHEN awayteam_id = 8650 AND away_goal > home_goal
		THEN id END) AS away_wins
FROM match
GROUP BY season;

SELECT
	season,
	COUNT(CASE WHEN hometeam_id = 8650 AND home_goal > away_goal
		THEN 54321 END) AS home_wins,
	COUNT(CASE WHEN awayteam_id = 8650 AND away_goal > home_goal
		THEN 'Some random text' END) AS away_wins
FROM match
GROUP BY season;

CASE WHEN with SUM

SELECT
	season,
	SUM(CASE WHEN hometeam_id = 8650
		THEN home_goal END) AS home_goals,
	SUM(CASE WHEN awayteam_id = 8650
		THEN away_goal END) AS away_goals
FROM match
GROUP BY season;

The CASE is fairly AVG...
SELECT
	season,
	AVG(CASE WHEN hometeam_id = 8650
		THEN home_goal END) AS home_goals,
	AVG(CASE WHEN awayteam_id = 8650
		THEN away_goal END) AS away_goals
FROM match
GROUP BY season;

A ROUNDed AVG
ROUND(3.141592653589,2)

SELECT
	season,
	ROUND(AVG(CASE WHEN hometeam_id = 8650
		THEN home_goal END),2) AS home_goals,
	ROUND(AVG(CASE WHEN awayteam_id = 8650
		THEN away_goal END),2) AS away_goals
FROM match
GROUP BY season;

Percentages with CASE and AVG

SELECT
	season,
		AVG(CASE WHEN hometeam_id = 8455 AND home_goal > away_goal THEN 1
			WHEN hometeam_id = 8455 AND home_goal < away_goal THEN 0
			END) AS pct_homewins,
		AVG(CASE WHEN awayteam_id = 8455 AND away_goal > home_goal THEN 1
			WHEN awayteam_id = 8455 AND away_goal < home_goal THEN 0
			END) AS pct_awaywins
FROM match
GROUP BY season;

SELECT
	season,
	ROUND(AVG(CASE WHEN hometeam_id = 8455 AND home_goal > away_goal THEN 1
		WHEN hometeam_id = 8455 AND home_goal < away_goal THEN 0
		END),2) AS pct_homewins,
	ROUND(AVG(CASE WHEN awayteam_id = 8455 AND away_goal > home_goal THEN 1
		WHEN awayteam_id = 8455 AND away_goal < home_goal THEN 0
		END),2) AS pct_awaywins
FROM match
GROUP BY season;

#---------------------------------------------------------------------

COUNT using CASE WHEN
Do the number of soccer matches played in a given European country differ across seasons? We will use the European Soccer Database to answer this question.

You will examine the number of matches played in 3 seasons within each country listed in the database. This is much easier to explore with each season's matches in separate columns. Using the country and unfiltered match table, you will count the number of matches played in each country during the 2012/2013, 2013/2014, and 2014/2015 match seasons.

step 01

SELECT 
	c.name AS country,
    -- Count games from the 2012/2013 season
	COUNT(CASE WHEN m.season = '2012/2013' 
          	   THEN m.id ELSE NULL END) AS matches_2012_2013
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY country;

step 02

SELECT 
	c.name AS country,
    -- Count matches in each of the 3 seasons
	COUNT(CASE WHEN m.season = '2012/2013' THEN m.id ELSE NULL END) AS matches_2012_2013,
	COUNT(CASE WHEN m.season = '2013/2014' THEN m.id ELSE NULL END) AS matches_2013_2014,
	COUNT(CASE WHEN m.season = '2014/2015' THEN m.id ELSE NULL END) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY country;

#---------------------------------------------------------------------

COUNT and CASE WHEN with multiple conditions
In R or Python, you have the ability to calculate a SUM of logical values (i.e., TRUE/FALSE) directly. In SQL, you have to convert these values into 1 and 0 before calculating a sum. This can be done using a CASE statement.

There's one key difference when using SUM to aggregate logical values compared to using COUNT in the previous exercise --

Your goal here is to use the country and match table to determine the total number of matches won by the home team in each country during the 2012/2013, 2013/2014, and 2014/2015 seasons.

SELECT 
	c.name AS country,
    -- Sum the total records in each season where the home team won
	SUM(CASE WHEN m.season = '2012/2013' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 END) AS matches_2012_2013,
 	SUM(CASE WHEN m.season = '2013/2014' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 END) AS matches_2013_2014,
	SUM(CASE WHEN m.season = '2014/2015' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 END) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY country;

#---------------------------------------------------------------------

Calculating percent with CASE and AVG
CASE statements will return any value you specify in your THEN clause. This is an incredibly powerful tool for robust calculations and data manipulation when used in conjunction with an aggregate statement. One key task you can perform is using CASE inside an AVG function to calculate a percentage of information in your database.

Here's an example of how you set that up:

AVG(CASE WHEN condition_is_met THEN 1
         WHEN condition_is_not_met THEN 0 END)
With this approach, it's important to accurately specify which records count as 0, otherwise your calculations may not be correct!

Your task is to examine the number of wins, losses, and ties in each country. The matches table is filtered to include all matches from the 2013/2014 and 2014/2015 seasons.

step 01

SELECT 
    c.name AS country,
    -- Count the home wins, away wins, and ties in each country
	COUNT(CASE  WHEN m.home_goal > m.away_goal THEN m.id 
        END) AS home_wins,
	COUNT(CASE  WHEN m.home_goal < m.away_goal THEN m.id 
        END) AS away_wins,
	COUNT(CASE  WHEN m.home_goal = m.away_goal THEN m.id 
        END) AS ties
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;

step 02

SELECT 
	c.name AS country,
    -- Calculate the percentage of tied games in each season
	AVG(CASE WHEN m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
			WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
			END) AS ties_2013_2014,
	AVG(CASE WHEN m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
			WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
			END) AS ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;

step 03

SELECT 
	c.name AS country,
    -- Round the percentage of tied games to 2 decimal points
	ROUND(AVG(CASE WHEN m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2013_2014,
	ROUND(AVG(CASE WHEN m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;


######################################################################
######################################################################
######################################################################

######## Short and Simple Subqueries (Module 02-023)
######################################################################

What is a subquery?
A query nested inside another query

SELECT column
FROM (SELECT column
FROM table) AS subquery;

Can be in any part of a query
SELECT , FROM , WHERE , GROUP BY
Can return a variety of information
Scalar quantities ( 3.14159 , -2 , 0.001 )
A list ( id = (12, 25, 392, 401, 939) )
A table

Simple Subqueries

SELECT home_goal
FROM match
WHERE home_goal > (
SELECT AVG(home_goal)
FROM match);
SELECT AVG(home_goal) FROM match;

Subqueries in the WHERE clause

JOB*********************************************************

SELECT *
FROM [dbo].[ActivitesDay_Employer]
WHERE Activities > (SELECT AVG(Activities)
					FROM [dbo].[ActivitesDay_Employer]);


ej:
SELECT date, hometeam_id, awayteam_id, home_goal, away_goal
FROM match
WHERE season = '2012/2013'
AND home_goal > (SELECT AVG(home_goal)
FROM match);

Subquery -IN

SELECT
team_long_name,
team_short_name AS abbr
FROM team
WHERE
team_api_id IN
(SELECT hometeam_id
FROM match
WHERE country_id = 15722);

#---------------------------------------------------------------------
Filtering using scalar subqueries
Subqueries are incredibly powerful for performing complex filters and transformations. You can filter data based on single, scalar values using a subquery in ways you cannot by using WHERE statements or joins. Subqueries can also be used for more advanced manipulation of your data set. You will likely encounter subqueries in any real-world setting that uses relational databases.

In this exercise, you will generate a list of matches where the total goals scored (for both teams in total) is more than 3 times the average for games in the matches_2013_2014 table, which includes all games played in the 2013/2014 season.

step01

-- Select the average of home + away goals, multiplied by 3
SELECT 
	3 * AVG(home_goal + away_goal)
FROM matches_2013_2014;

step02

SELECT 
	-- Select the date, home goals, and away goals scored
    date,
	home_goal,
	away_goal
FROM  matches_2013_2014
-- Filter for matches where total goals exceeds 3x the average
WHERE (home_goal + away_goal) > 
       (SELECT 3 * AVG(home_goal + away_goal)
        FROM matches_2013_2014); 

#---------------------------------------------------------------------
Filtering using a subquery with a list
Your goal in this exercise is to generate a list of teams that never played a game in their home city. Using a subquery, you will generate a list of unique hometeam_ID values from the unfiltered match table to exclude in the team table's team_api_ID column.

In addition to filtering using a single-value (scalar) subquery, you can create a list of values in a subquery to filter data based on a complex set of conditions. This type of subquery generates a one column reference list for the main query. As long as the values in your list match a column in your main query's table, you don't need to use a join -- even if the list is from a separate table.

SELECT 
	-- Select the team long and short names
	team_long_name,
	team_short_name
FROM team 
-- Exclude all values from the subquery
WHERE team_api_id NOT IN
     (SELECT DISTINCT hometeam_ID  FROM match);

#---------------------------------------------------------------------
Filtering with more complex subquery conditions
In the previous exercise, you generated a list of teams that have no home matches listed in the soccer database using a subquery in WHERE. Let's do some further exploration in this database by creating a list of teams that scored 8 or more goals in a home match.

In order to do this, you will construct a subquery in the WHERE statement with its own filtering condition.

SELECT
	-- Select the team long and short names
	team_long_name,
	team_short_name
FROM team
-- Filter for teams with 8 or more home goals
WHERE team_api_id IN
	  (SELECT hometeam_ID 
       FROM match
       WHERE home_goal >= 8);

#---------------------------------------------------------------------
video
Subqueries in the
FROM statement

Restructure and transform your data
	Transforming data from long to wide before selecting
	Prefiltering data

Calculating aggregates of aggregates
Which 3 teams has the highest average of home goals scored?
1. Calculate the AVG for each team
2. Get the 3 highest of the AVG values

1st with no suquery

FROM subqueries...

step 01
SELECT
t.team_long_name AS team,
AVG(m.home_goal) AS home_avg
FROM match AS m
LEFT JOIN team AS t
ON m.hometeam_id = t.team_api_id
WHERE season = '2011/2012'
GROUP BY team;

NOW::::...to main queries!

step02
FROM (SELECT
t.team_long_name AS team,
AVG(m.home_goal) AS home_avg
FROM match AS m
LEFT JOIN team AS t
ON m.hometeam_id = t.team_api_id
WHERE season = '2011/2012'
GROUP BY team) AS subquery

step 03
SELECT team, home_avg
FROM (SELECT
t.team_long_name AS team,
AVG(m.home_goal) AS home_avg
FROM match AS m
LEFT JOIN team AS t
ON m.hometeam_id = t.team_api_id
WHERE season = '2011/2012'
GROUP BY team) AS subquery

step04
SELECT team, home_avg
FROM (SELECT
t.team_long_name AS team,
AVG(m.home_goal) AS home_avg
FROM match AS m
LEFT JOIN team AS t
ON m.hometeam_id = t.team_api_id
WHERE season = '2011/2012'
GROUP BY team) AS subquery
ORDER BY home_avg DESC
LIMIT 3;

Things to remember
You can create multiple subqueries in one FROM statement
	Alias them!
	Join them!
You can join a subquery to a table in FROM
	Include a joining columns in both tables!

#---------------------------------------------------------------------

Joining Subqueries in FROM
The match table in the European Soccer Database does not contain country or team names. You can get this information by joining it to the country table, and use this to aggregate information, such as the number of matches played in each country.

If you're interested in filtering data from one of these tables, you can also create a subquery from one of the tables, and then join it to an existing table in the database. A subquery in FROM is an effective way of answering detailed questions that requires filtering or transforming data before including it in your final results.

Your goal in this exercise is to generate a subquery using the match table, and then join that subquery to the country table to calculate information about matches with 10 or more goals in total!

step01
SELECT 
	-- Select the country ID and match ID
	country_id, 
    id 
FROM match
-- Filter for matches with 10 or more goals in total
WHERE (home_goal + away_goal) >= 10;

step02
SELECT
	-- Select country name and the count match IDs
    c.name AS country_name,
    COUNT(sub.id) AS matches
FROM country AS c
-- Inner join the subquery onto country
-- Select the country id and match id columns
INNER JOIN (SELECT country_id, id 
           FROM match
           -- Filter the subquery by matches with 10+ goals
           WHERE (home_goal + away_goal) >= 10) AS sub
ON c.id = sub.country_id
GROUP BY country_name;

#---------------------------------------------------------------------
Building on Subqueries in FROM
In the previous exercise, you found that England, Netherlands, Germany and Spain were the only countries that had matches in the database where 10 or more goals were scored overall. Let's find out some more details about those matches -- when they were played, during which seasons, and how many of the goals were home vs. away goals.

You'll notice that in this exercise, the table alias is excluded for every column selected in the main query. This is because the main query is extracting data from the subquery, which is treated as a single table.

SELECT
	-- Select country, date, home, and away goals from the subquery
    country,
    date,
    home_goal,
    away_goal
FROM 
	-- Select country name, date, and total goals in the subquery
	(SELECT c.name AS country, 
     	    m.date, 
     		m.home_goal, 
     		m.away_goal,
           (m.home_goal + m.away_goal) AS total_goals
    FROM match AS m
    LEFT JOIN country AS c
    ON m.country_id = c.id) AS subq
-- Filter by total goals scored in the main query
WHERE total_goals >= 10;

#---------------------------------------------------------------------
video

SELECTing what?
Returns a single value
Include aggregate values to compare to individual values
Used in mathematical calculations
Deviation from the average

step01
SELECT COUNT(id) FROM match;

step02
SELECT
season,
COUNT(id) AS matches,
12837 as total_matches
FROM match
GROUP BY season;

step03 skip that step
SELECT
season,
COUNT(id) AS matches,
(SELECT COUNT(id) FROM match) as total_matches
FROM match
GROUP BY season;

SELECT subqueries for mathematical calculations

step01
SELECT AVG(home_goal + away_goal)
FROM match
WHERE season = '2011/2012';
-> 2,72

step02
SELECT
date,
(home_goal + away_goal) AS goals,
(home_goal + away_goal) - 2.72 AS diff
FROM match
WHERE season = '2011/2012';

step03 Subqueries in SELECT
SELECT
date,
(home_goal + away_goal) AS goals,
(home_goal + away_goal) -
(SELECT AVG(home_goal + away_goal)
FROM match
WHERE season = '2011/2012') AS diff
FROM match
WHERE season = '2011/2012';

SELECT subqueries -- things to keep in mind
Need to return a SINGLE value
	Will generate an error otherwise

Make sure you have all filters in rightplaces
	properly filter both the main and the subquery!

SELECT
date,
(home_goal + away_goal) AS goals,
(home_goal + away_goal) -
(SELECT AVG(home_goal + away_goal)
FROM match
WHERE season = '2011/2012') AS diff
FROM match
WHERE season = '2011/2012';

#---------------------------------------------------------------------

Add a subquery to the SELECT clause
Subqueries in SELECT statements generate a single value that allow you to pass an aggregate value down a data frame. This is useful for performing calculations on data within your database.

In the following exercise, you will construct a query that calculates the average number of goals per match in each country's league.

SELECT 
	l.name AS league,
    -- Select and round the league's total goals
    ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_goals,
    -- Select & round the average total goals for the season
    (SELECT ROUND(AVG(home_goal + away_goal), 2) 
     FROM match
     WHERE season = '2013/2014') AS overall_avg
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
-- Filter for the 2013/2014 season
WHERE season = '2013/2014'
GROUP BY league;

#---------------------------------------------------------------------

Subqueries in Select for Calculations
Subqueries in SELECT are a useful way to create calculated columns in a query. A subquery in SELECT can be treated as a single numeric value to use in your calculations. When writing queries in SELECT, it's important to remember that filtering the main query does not filter the subquery -- and vice versa.

In the previous exercise, you created a column to compare each league's average total goals to the overall average goals in the 2013/2014 season. In this exercise, you will add a column that directly compares these values by subtracting the overall average from the subquery.

SELECT
	-- Select the league name and average goals scored
	l.name AS league,
	ROUND(AVG(m.home_goal + m.away_goal),2) AS avg_goals,
    -- Subtract the overall average from the league average
	ROUND(AVG(home_goal + m.away_goal) - 
		(SELECT AVG(home_goal + away_goal)
		 FROM match 
         WHERE season = '2013/2014'),2) AS diff
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
-- Only include 2013/2014 results
WHERE season = '2013/2014'
GROUP BY l.name;

#---------------------------------------------------------------------
video
Subqueries
everywhere! And
best practices!

Can include multiple subqueries in SELECT , FROM , WHERE
SELECT
	country_id,
	ROUND(AVG(matches.home_goal + matches.away_goal),2) AS avg_goals,
	(SELECT ROUND(AVG(home_goal + away_goal),2)
	FROM match WHERE season = '2013/2014') AS overall_avg
FROM (SELECT
	id,
	home_goal,
	away_goal,
	season
	FROM match
	WHERE home_goal > 5) AS matches
WHERE matches.season = '2013/2014'
	AND (AVG(matches.home_goal + matches.away_goal) >
		(SELECT AVG(home_goal + away_goal)
		FROM match WHERE season = '2013/2014')
GROUP BY country_id;


Format your queries
Line up SELECT , FROM , WHERE , and GROUP BY
#Indent
SELECT
	col1,
	col2,
	col3
FROM table1
WHERE col1 = 2;

Annotate your queries
/* This query filters for col1 = 2
and only selects data from table1 */
/*
SELECT
	col1,
	col2,
	col3
FROM table1
WHERE col1 = 2;

SELECT
col1,
col2,
col3
FROM table1 -- this table has 10,000 rows
WHERE col1 = 2; -- Filter WHERE value 2

Indent your subqueries!
SELECT
	col1,
	col2,
	col3
FROM table1
WHERE col1 IN
		(SELECT id
		FROM table2
		WHERE year = 1991);

Is that subquery necessary?
-Subqueries require computing power
	How big is your database?
	How big is the table you're querying from?
-Is the subquery actually necessary?
-Watch your FILTERS!!°!

SELECT
	country_id,
	ROUND(AVG(m.home_goal + m.away_goal),2) AS avg_goals,
	(SELECT ROUND(AVG(home_goal + away_goal),2)
	FROM match WHERE season = '2013/2014') AS overall_avg
FROM match AS m
WHERE
	m.season = '2013/2014'
	AND (AVG(m.home_goal + m.away_goal) >
		(SELECT AVG(home_goal + away_goal)
		FROM match WHERE season = '2013/2014')
GROUP BY country_id;

#---------------------------------------------------------------------
ALL the Subqueries EVERYWHERE
In soccer leagues, games are played at different stages. Winning teams progress from one stage to the next, until they reach the final stage. In each stage, the stakes become higher than the previous one. The match table includes data about the different stages that each match took place in.

In this lesson, you will build a final query across 3 exercises that will contain three subqueries -- one in the SELECT clause, one in the FROM clause, and one in the WHERE clause. In the final exercise, your query will extract data examining the average goals scored in each stage of a match. Does the average number of goals scored change as the stakes get higher from one stage to the next?

SELECT 
	-- Select the stage and average goals for each stage
	m.stage,
    ROUND(AVG(home_goal + m.away_goal),2) AS avg_goals,
    -- Select the average overall goals for the 2012/2013 season
    ROUND((SELECT AVG(home_goal + away_goal) 
           FROM match 
           WHERE season = '2012/2013'),2) AS overall
FROM match AS m
-- Filter for the 2012/2013 season
WHERE season = '2012/2013'
-- Group by stage
GROUP BY m.stage;

#---------------------------------------------------------------------
Add a subquery in FROM
In the previous exercise, you created a data set listing the average home and away goals in each match stage of the 2012/2013 match season.

In this next step, you will turn the main query into a subquery to extract a list of stages where the average home goals in a stage is higher than the overall average for home goals in a match.

SELECT 
	-- Select the stage and average goals from the subquery
	s.stage,
	ROUND(s.avg_goals,2) AS avg_goals
FROM 
	-- Select the stage and average goals in 2012/2013
	(SELECT
		 stage,
         AVG(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	-- Filter the main query using the subquery
	s.avg_goals > (SELECT AVG(home_goal + away_goal) 
                    FROM match WHERE season = '2012/2013');

#---------------------------------------------------------------------

Add a subquery in SELECT
In the previous exercise, you added a subquery to the FROM statement and selected the stages where the number of average goals in a stage exceeded the overall average number of goals in the 2012/2013 match season. In this final step, you will add a subquery in SELECT to compare the average number of goals scored in each stage to the total.

SELECT 
	-- Select the stage and average goals from s
	s.stage,
    ROUND(s.avg_goals,2) AS avg_goal,
    -- Select the overall average for 2012/2013
    (SELECT AVG(home_goal + away_goal) FROM match WHERE season = '2012/2013') AS overall_avg
FROM 
	-- Select the stage and average goals in 2012/2013 from match
	(SELECT
		 stage,
         AVG(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	-- Filter the main query using the subquery
	s.avg_goals > (SELECT AVG(home_goal + away_goal) 
                    FROM match WHERE season = '2012/2013');


######################################################################
######################################################################
######################################################################

######## Correlated Queries, Nested Queries, and Common Table Expressions (Module 03-023)
######################################################################
video: Correlated Subqueries

Correlated subquery
	Uses values from the outer query to generate a result
	Re-run for every row generated in the final data set
	Used for advanced joinin, filtering, and evaluating data

A simple example
Which match stages tend to have a higher than average number of goals
scored?

SELECT
	s.stage,
	ROUND(s.avg_goals,2) AS avg_goal,
	(SELECT AVG(home_goal + away_goal) FROM match
	WHERE season = '2012/2013') AS overall_avg
FROM
	(SELECT
		stage,
		AVG(home_goal + away_goal) AS avg_goals
	FROM match
	WHERE season = '2012/2013'
	GROUP BY stage) AS s -- Subquery in FROM
WHERE s.avg_goals > (SELECT AVG(home_goal + away_goal)
					FROM match
					WHERE season = '2012/2013'); -- Subquery in WHERE

A correlated example

SELECT
	s.stage,
	ROUND(s.avg_goals,2) AS avg_goal,
	(SELECT AVG(home_goal + away_goal)
	FROM match
	WHERE season = '2012/2013') AS overall_avg
FROM
	(SELECT
		stage,
		AVG(home_goal + away_goal) AS avg_goals
	FROM match
	WHERE season = '2012/2013'
	GROUP BY stage) AS s
WHERE s.avg_goals > (SELECT AVG(home_goal + away_goal)
					FROM match AS m
					WHERE s.stage > m.stage);


Simple vs. correlated subqueries

Simple Subquery
	Can be run independently from the main query
	Evaluated once in the whole query

Correlated Subquery
	Dependent on the main query to execute
	Evaluated in loops  Signicantly slows down query runtime

Correlated subqueries
What is the average number of goals scored in each country?
*normal
SELECT
	c.name AS country,
	AVG(m.home_goal + m.away_goal)
		AS avg_goals
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
GROUP BY country;

*correlated
SELECT
	c.name AS country,
	(SELECT
		AVG(home_goal + away_goal)
		FROM match AS m
		WHERE m.country_id = c.id)
		AS avg_goals
FROM country AS c
GROUP BY country;

#---------------------------------------------------------------------

Basic Correlated Subqueries
Correlated subqueries are subqueries that reference one or more columns in the main query. Correlated subqueries depend on information in the main query to run, and thus, cannot be executed on their own.

Correlated subqueries are evaluated in SQL once per row of data retrieved -- a process that takes a lot more computing power and time than a simple subquery.

In this exercise, you will practice using correlated subqueries to examine matches with scores that are extreme outliers for each country -- above 3 times the average score!

SELECT
    -- Select country ID, date, home, and away goals from match
    main.country_id,
    date,
    main.home_goal,
    away_goal
FROM match AS main
WHERE
    -- Filter the main query by the subquery
    (home_goal + away_goal) >
        (SELECT AVG((sub.home_goal + sub.away_goal) * 3)
         FROM match AS sub
         -- Join the main query to the subquery in WHERE
         WHERE main.country_id = sub.country_id);


#---------------------------------------------------------------------
Correlated subquery with multiple conditions
Correlated subqueries are useful for matching data across multiple columns. In the previous exercise, you generated a list of matches with extremely high scores for each country. In this exercise, you're going to add an additional column for matching to answer the question -- what was the highest scoring match for each country, in each season?

*Note: this query may take a while to load.

SELECT
    -- Select country ID, date, home, and away goals from match
    main.country_id,
    date,
    main.home_goal,
    away_goal
FROM match AS main
WHERE
    -- Filter for matches with the highest number of goals scored
    (home_goal + away_goal) =
        (SELECT MAX(sub.home_goal + sub.away_goal)
         FROM match AS sub
         WHERE main.country_id = sub.country_id
               AND main.season = sub.season);

#---------------------------------------------------------------------
Video
Nested Subqueries
	Subquery inside another subquery
	Perform multiple layers of transformation

A subquery...
	How much did each country's average differ from the overall average?

SELECT
	c.name AS country,
	AVG(m.home_goal + m.away_goal) AS avg_goals,
	AVG(m.home_goal + m.away_goal) -
		(SELECT AVG(home_goal + away_goal)
		FROM match) AS avg_diff
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
GROUP BY country;

...inside a subquery!
	How does each month's total goals differ from the average monthly
total of goals scored?

SELECT
	EXTRACT(MONTH FROM date) AS month,
	SUM(m.home_goal + m.away_goal) AS total_goals,
	SUM(m.home_goal + m.away_goal) -
	(SELECT AVG(goals)
	FROM (SELECT
			EXTRACT(MONTH FROM date) AS month,
			SUM(home_goal + away_goal) AS goals
		FROM match
		GROUP BY month)) AS avg_diff
FROM match AS m
GROUP BY month;

Inner subquery
SELECT
	EXTRACT(MONTH from date) AS month,
	SUM(home_goal + away_goal) AS goals
FROM match
GROUP BY month;

Outer subquery
SELECT AVG(goals)
FROM (SELECT
		EXTRACT(MONTH from date) AS month,
		AVG(home_goal + away_goal) AS goals
FROM match
GROUP BY month) AS s;

Final query
SELECT
	EXTRACT(MONTH FROM date) AS month,
	SUM(m.home_goal + m.away_goal) AS total_goals,
	SUM(m.home_goal + m.away_goal) -
	(SELECT AVG(goals)
	FROM (SELECT
			EXTRACT(MONTH FROM date) AS month,
			SUM(home_goal + away_goal) AS goals
		FROM match
		GROUP BY month) AS s) AS diff
FROM match AS m
GROUP BY month;

Correlated nested subqueries
Nested subqueries can be correlated or uncorrelated
	Or...a combination of the two
	Can reference information from the outer subquery or main query

Correlated nested subqueries
	What is the each country's average goals scored in the 2011/2012
season?

SELECT
	c.name AS country,
	(SELECT AVG(home_goal + away_goal)
	FROM match AS m
	WHERE m.country_id = c.id -- Correlates with main query
		AND id IN (
			SELECT id
			FROM match
			WHERE season = '2011/2012')) AS avg_goals
FROM country AS c
GROUP BY country;

#---------------------------------------------------------------------
Nested simple subqueries
Nested subqueries can be either simple or correlated.

Just like an unnested subquery, a nested subquery's components can be executed independently of the outer query, while a correlated subquery requires both the outer and inner subquery to run and produce results.

In this exercise, you will practice creating a nested subquery to examine the highest total number of goals in each season, overall, and during July across all seasons.

SELECT
	-- Select the season and max goals scored in a match
	season,
    MAX(home_goal + away_goal) AS max_goals,
    -- Select the overall max goals scored in a match
   (SELECT MAX(home_goal + away_goal) FROM match) AS overall_max_goals,
   -- Select the max number of goals scored in any match in July
   (SELECT MAX(home_goal + away_goal) 
    FROM match
    WHERE id IN (
          SELECT id FROM match WHERE EXTRACT(MONTH FROM date) = 07)) AS july_max_goals
FROM match
GROUP BY season;

#---------------------------------------------------------------------
SELECT
	-- Select the season and max goals scored in a match
	season,
    MAX(home_goal + away_goal) AS max_goals,
    -- Select the overall max goals scored in a match
   (SELECT MAX(home_goal + away_goal) FROM match) AS overall_max_goals,
   -- Select the max number of goals scored in any match in July
   (SELECT MAX(home_goal + away_goal) 
    FROM match
    WHERE id IN (
          SELECT id FROM match WHERE EXTRACT(MONTH FROM date) = 07)) AS july_max_goals
FROM match
GROUP BY season;

STEP01
-- Select matches where a team scored 5+ goals
SELECT
	country_id,
    season,
	id
FROM match
WHERE home_goal > 5 OR away_goal > 5;

STEP02
-- Count match ids
SELECT
    country_id,
    season,
    COUNT(id) AS matches
-- Set up and alias the subquery
FROM (
	SELECT
    	country_id,
    	season,
    	id
	FROM match
	WHERE home_goal >= 5 OR away_goal >= 5) AS subquery
-- Group by country_id and season
GROUP BY country_id, season;

STEP03
SELECT
	c.name AS country,
    -- Calculate the average matches per season
	AVG(outer_s.country_id) AS avg_seasonal_high_scores
FROM country AS c
-- Left join outer_s to country
LEFT JOIN (
  SELECT country_id, season,
         COUNT(id) AS matches
  FROM (
    SELECT country_id, season, id
	FROM match
	WHERE home_goal >= 5 OR away_goal >= 5) AS inner_s
  -- Close parentheses and alias the subquery
  GROUP BY country_id, season) AS outer_s
ON c.id = outer_s.country_id
GROUP BY country;

#---------------------------------------------------------------------
VIDEO
Common Table
Expressions

When adding subqueries...
Query complexity increases quickly!
Information can be dif

Common Table Expressions
Common Table Expressions
(CTEs)
	Table declared before themain query
	Named and referenced later in FROM statement

Setting up CTEs
WITH cte AS (
	SELECT col1, col2
	FROM table)
SELECT
	AVG(col1) AS avg_col
FROM cte;

STEP01
Take a subquery in FROM  
SELECT
	c.name AS country,
	COUNT(s.id) AS matches
FROM country AS c
INNER JOIN (
	SELECT country_id, id
	FROM match
	WHERE (home_goal + away_goal) >= 10) AS s
ON c.id = s.country_id
GROUP BY country;

STEP02
Place it at the beginning
(
SELECT country_id, id
FROM match
WHERE (home_goal + away_goal) >= 10
)

STEP03
WITH s AS (
SELECT country_id, id
FROM match
WHERE (home_goal + away_goal) >= 10
)

STEP04
Show me the CTE
WITH s AS (
	SELECT country_id, id
	FROM match
	WHERE (home_goal + away_goal) >= 10
)
SELECT
	c.name AS country,
	COUNT(s.id) AS matches
FROM country AS c
INNER JOIN s
ON c.id = s.country_id
GROUP BY country;

Show me all the CTEs
WITH s1 AS (
	SELECT country_id, id
	FROM match
	WHERE (home_goal + away_goal) >= 10),
s2 AS ( -- New subquery
	SELECT country_id, id
	FROM match
	WHERE (home_goal + away_goal) <= 1
)
SELECT
	c.name AS country,
	COUNT(s1.id) AS high_scores,
	COUNT(s2.id) AS low_scores -- New column
FROM country AS c
INNER JOIN s1
ON c.id = s1.country_id
INNER JOIN s2 -- New join
ON c.id = s2.country_id
GROUP BY country;


Why use CTEs?
Executed once
CTE is then stored in memory
Improves query performance
Improving organization of queries
Referencing other CTEs
Referencing itself ( SELF JOIN )

#---------------------------------------------------------------------
Clean up with CTEs
In chapter 2, you generated a list of countries and the number of matches in each country with more than 10 total goals. The query in that exercise utilized a subquery in the FROM statement in order to filter the matches before counting them in the main query. Below is the query you created:

SELECT
  c.name AS country,
  COUNT(sub.id) AS matches
FROM country AS c
INNER JOIN (
  SELECT country_id, id 
  FROM match
  WHERE (home_goal + away_goal) >= 10) AS sub
ON c.id = sub.country_id
GROUP BY country;
You can list one (or more) subqueries as common table expressions (CTEs) by declaring them ahead of your main query, which is an excellent tool for organizing information and placing it in a logical order.

In this exercise, let's rewrite a similar query using a CTE.

-- Set up your CTE
WITH match_list AS (
    SELECT 
  		country_id, 
  		id
    FROM match
    WHERE (home_goal + away_goal) >= 10)
-- Select league and count of matches from the CTE
SELECT
    l.name AS league,
    COUNT(match_list.id) AS matches
FROM league AS l
-- Join the CTE to the league table
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;

#---------------------------------------------------------------------
Organizing with CTEs
Previously, you modified a query based on a statement you completed in chapter 2 using common table expressions.

This time, let's expand on the exercise by looking at details about matches with very high scores using CTEs. Just like a subquery in FROM, you can join tables inside a CTE.

-- Set up your CTE
WITH match_list AS (
  -- Select the league, date, home, and away goals
    SELECT 
  		l.name AS league, 
     	date, 
  		m.home_goal, 
  		m.away_goal,
       (m.home_goal + m.away_goal) AS total_goals
    FROM match AS m
    LEFT JOIN league as l ON m.country_id = l.id)
-- Select the league, date, home, and away goals from the CTE
SELECT league, date, home_goal, away_goal
FROM match_list
-- Filter by total goals
WHERE total_goals >= 10;

#---------------------------------------------------------------------
CTEs with nested subqueries
If you find yourself listing multiple subqueries in the FROM clause with nested statement, your query will likely become long, complex, and difficult to read.

Since many queries are written with the intention of being saved and re-run in the future, proper organization is key to a seamless workflow. Arranging subqueries as CTEs will save you time, space, and confusion in the long run!

-- Set up your CTE
WITH match_list AS (
    SELECT 
  		country_id,
  	   (home_goal + away_goal) AS goals
    FROM match
  	-- Create a list of match IDs to filter data in the CTE
    WHERE id IN (
       SELECT id
       FROM match
       WHERE season = '2013/2014' AND EXTRACT(MONTH FROM date) = 8))
-- Select the league name and average of goals in the CTE
SELECT 
	l.name,
    AVG(goals)
FROM league AS l
-- Join the CTE onto the league table
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;

#---------------------------------------------------------------------
video
Deciding on
techniques to use

Differentiating Techniques
	Joins
		Combine 2+ tables
		Simple
		operations/aggregations

	Correlated Subqueries
		Match subqueries & tables
		Avoid limits of joins
		High processing time
	Multiple/Nested Subqueries
		Multi-step
		transformations
		Improve accuracy and
		reproducibility
	Common Table Expressions
		Organize subqueries
		sequentially
		Can reference other CTEs

So which do I use?
	Depends on your database/question
	The technique that best allows you to:
		Use and reuse your queries
		Generate clear and accurate results

Different use cases
	Joins
		2+ tables (What is the total
		sales per employee?)
	Correlated Subqueries
		Who does each employee
		report to in a company?
	Multiple/Nested Subqueries
		What is the average deal size
		closed by each sales
		representative in the quarter?
	Common Table Expressions
		How did the marketing, sales,
		growth, & engineering teams
		perform on key metrics?

#---------------------------------------------------------------------
Get team names with a subquery
Let's solve a problem we've encountered a few times in this course so far -- How do you get both the home and away team names into one final query result?

Out of the 4 techniques we just discussed, this can be performed using subqueries, correlated subqueries, and CTEs. Let's practice creating similar result sets using each of these 3 methods over the next 3 exercises, starting with subqueries in FROM.

step01
SELECT 
	m.id, 
    t.team_long_name AS hometeam
-- Left join team to match
FROM match AS m
LEFT JOIN team as t
ON m.hometeam_id = t.team_api_id;

step02
SELECT
	m.date,
    -- Get the home and away team names
    hometeam,
    awayteam,
    m.home_goal,
    m.away_goal
FROM match AS m
-- Join the home subquery to the match table
LEFT JOIN (
  SELECT match.id, team.team_long_name AS hometeam
  FROM match
  LEFT JOIN team
  ON match.hometeam_id = team.team_api_id) AS home
ON home.id = m.id
-- Join the away subquery to the match table
LEFT JOIN (
  SELECT match.id, team.team_long_name AS awayteam
  FROM match
  LEFT JOIN team
  -- Get the away team ID in the subquery
  ON match.awayteam_id = team.team_api_id) AS away
ON away.id = m.id;

#---------------------------------------------------------------------
Get team names with correlated subqueries
Let's solve the same problem using correlated subqueries -- How do you get both the home and away team names into one final query result?

This can easily be performed using correlated subqueries. But how might that impact the performance of your query? Complete the following steps and let's find out!

Please note that your query will run more slowly than the previous exercise!

step01
SELECT
    m.date,
   (SELECT team_long_name
    FROM team AS t
    -- Connect the team to the match table
    WHERE team_api_id = hometeam_id) AS hometeam
FROM match AS m;

step02
SELECT
    m.date,
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.hometeam_id) AS hometeam,
    -- Connect the team to the match table
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.awayteam_id) AS awayteam,
    -- Select home and away goals
     home_goal,
     away_goal
FROM match AS m;

#---------------------------------------------------------------------
Get team names with CTEs
You've now explored two methods for answering the question, How do you get both the home and away team names into one final query result?

Let's explore the final method - common table expressions. Common table expressions are similar to the subquery method for generating results, mainly differing in syntax and the order in which information is processed.

step01
SELECT 
	-- Select match id and team long name
    m.id, 
    t.team_long_name AS hometeam
FROM match AS m
-- Join team to match using team_api_id and hometeam_id
LEFT JOIN team AS t 
ON m.hometeam_id = t.team_api_id;

step02
-- Declare the home CTE
WITH home AS (
	SELECT m.id, t.team_long_name AS hometeam
	FROM match AS m
	LEFT JOIN team AS t 
	ON m.hometeam_id = t.team_api_id)
-- Select everything from home
SELECT *
FROM home;

step03
WITH home AS (
  SELECT m.id, m.date, 
  		 t.team_long_name AS hometeam, m.home_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.hometeam_id = t.team_api_id),
-- Declare and set up the away CTE
away AS (
  SELECT m.id, m.date, 
  		 t.team_long_name AS awayteam, m.away_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.awayteam_id = t.team_api_id)
-- Select date, home_goal, and away_goal
SELECT 
	home.date,
    home.hometeam,
    away.awayteam,
    home.home_goal,
    away.away_goal
-- Join away and home on the id column
FROM home
INNER JOIN away
ON home.id = away.id;

######################################################################
######################################################################
######################################################################

######## Window Functions (Module 04-023)
######################################################################
video
Working with aggregate values
Requires you to use GROUP BY with all non-aggregate columns

SELECT
country_id,
season,
date,
AVG(home_goal) AS avg_home
FROM match
GROUP BY country_id;
ERROR: column "match.season" must appear in the GROUP BY
clause or be used in an aggregate function

Introducing window functions!
	Perform calculations on an already generated result set (a window)
	Aggregate calculations
		Similar to subqueries in SELECT
		Running totals, rankings, moving averages

What's a window function?

How many goals were scored in each match in 2011/2012, and how did
that compare to the average?
SELECT
date,
(home_goal + away_goal) AS goals,
(SELECT AVG(home_goal + away_goal)
FROM match
WHERE season = '2011/2012') AS overall_avg
FROM match
WHERE season = '2011/2012';

EJ:
SELECT
date,
(home_goal + away_goal) AS goals,
AVG(home_goal + away_goal) OVER() AS overall_avg
FROM match
WHERE season = '2011/2012';

*****Generate a RANK
What is the rank of matches based on number of goals scored?
SELECT
date,
(home_goal + away_goal) AS goals
FROM match
WHERE season = '2011/2012';

EJ:
SELECT
date,
(home_goal + away_goal) AS goals,
RANK() OVER(ORDER BY home_goal + away_goal) AS goals_rank
FROM match
WHERE season = '2011/2012';

SELECT
date,
(home_goal + away_goal) AS goals,
RANK() OVER(ORDER BY home_goal + away_goal DESC) AS goals_rank
FROM match
WHERE season = '2011/2012';

Key Differences
	Processed after every part of query except ORDER BY
		Uses information in result set rather than database
	Available in PostgreSQL, Oracle, MySQL, SQL Server...
		...but NOT SQLite

#---------------------------------------------------------------------

The match is OVER
The OVER() clause allows you to pass an aggregate function down a data set, similar to subqueries in SELECT. The OVER() clause offers significant benefits over subqueries in select -- namely, your queries will run faster, and the OVER() clause has a wide range of additional functions and clauses you can include with it that we will cover later on in this chapter.

In this exercise, you will revise some queries from previous chapters using the OVER() clause.

SELECT 
	-- Select the id, country name, season, home, and away goals
	m.id, 
    c.name AS country, 
    m.season,
	m.home_goal,
	m.away_goal,
    -- Use a window to include the aggregate average in each row
	AVG(m.home_goal + m.away_goal) OVER() AS overall_avg
FROM match AS m
LEFT JOIN country AS c ON m.country_id = c.id;

#---------------------------------------------------------------------

What's OVER here?
Window functions allow you to create a RANK of information according to any variable you want to use to sort your data. When setting this up, you will need to specify what column/calculation you want to use to calculate your rank. This is done by including an ORDER BY clause inside the OVER() clause. Below is an example:

SELECT 
    id,
    RANK() OVER(ORDER BY home_goal) AS rank
FROM match;
In this exercise, you will create a data set of ranked matches according to which leagues, on average, score the most goals in a match.

SELECT 
	-- Select the league name and average goals scored
	l.name AS league,
    AVG(m.home_goal + m.away_goal) AS avg_goals,
    -- Rank each league according to the average goals
    RANK() OVER(ORDER BY AVG(m.home_goal + m.away_goal)) AS league_rank
FROM league AS l
LEFT JOIN match AS m 
ON l.id = m.country_id
WHERE m.season = '2011/2012'
GROUP BY l.name
-- Order the query by the rank you created
ORDER BY league_rank;

#---------------------------------------------------------------------

Flip OVER your results
In the last exercise, the rank generated in your query was organized from smallest to largest. By adding DESC to your window function, you can create a rank sorted from largest to smallest.

SELECT 
    id,
    RANK() OVER(ORDER BY home_goal DESC) AS rank
FROM match;

SELECT 
	-- Select the league name and average goals scored
	l.name AS league,
    AVG(m.home_goal + m.away_goal) AS avg_goals,
    -- Rank leagues in descending order by average goals
    RANK() OVER(ORDER BY AVG(m.home_goal + m.away_goal) DESC) AS league_rank
FROM league AS l
LEFT JOIN match AS m 
ON l.id = m.country_id
WHERE m.season = '2011/2012'
GROUP BY l.name
-- Order the query by the rank you created
ORDER BY league_rank;

#---------------------------------------------------------------------
Video
Window Partitions

OVER and PARTITION BY
	Calculate separate values for different categories
	Calculate different calculations in the same column
AVG(home_goal) OVER(PARTITION BY season)

Partition your data
	How many goals were scored in each match, and how did that compare
	to the overall average?
SELECT
date,
(home_goal + away_goal) AS goals,
AVG(home_goal + away_goal) OVER() AS overall_avg
FROM match;
EJ:
SELECT
date,
(home_goal + away_goal) AS goals,
AVG(home_goal + away_goal) OVER(PARTITION BY season) AS season_avg
FROM match;

PARTITION by Multiple Columns
SELECT
c.name,
m.season,
(home_goal + away_goal) AS goals,
AVG(home_goal + away_goal)
OVER(PARTITION BY m.season, c.name) AS season_ctry_avg
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id

PARTITION BY considerations
	Can partition data by 1 or more columns
	Can partition aggregate calculations, ranks, etc

#---------------------------------------------------------------------

PARTITION BY a column
The PARTITION BY clause allows you to calculate separate "windows" based on columns you want to divide your results. For example, you can create a single column that calculates an overall average of goals scored for each season.

In this exercise, you will be creating a data set of games played by Legia Warszawa (Warsaw League), the top ranked team in Poland, and comparing their individual game performance to the overall average for that season.

Where do you see more outliers? Are they Legia Warszawa's home or away games?

SELECT
	date,
	season,
	home_goal,
	away_goal,
	CASE WHEN hometeam_id = 8673 THEN 'home' 
		 ELSE 'away' END AS warsaw_location,
    -- Calculate the average goals scored partitioned by season
    AVG(home_goal) OVER(PARTITION BY season) AS season_homeavg,
    AVG(away_goal) OVER(PARTITION BY season) AS season_awayavg
FROM match
-- Filter the data set for Legia Warszawa matches only
WHERE 
	hometeam_id   = 8673 
    OR awayteam_id = 8673
ORDER BY (home_goal + away_goal) DESC;

#---------------------------------------------------------------------

PARTITION BY multiple columns
The PARTITION BY clause can be used to break out window averages by multiple data points (columns). You can even calculate the information you want to use to partition your data! For example, you can calculate average goals scored by season and by country, or by the calendar year (taken from the date column).

In this exercise, you will calculate the average number home and away goals scored Legia Warszawa, and their opponents, partitioned by the month in each season.

SELECT 
	date,
	season,
	home_goal,
	away_goal,
	CASE WHEN hometeam_id = 8673 THEN 'home' 
         ELSE 'away' END AS warsaw_location,
	-- Calculate average goals partitioned by season and month
    AVG(home_goal) OVER(PARTITION BY season, 
         	EXTRACT(month FROM date)) AS season_mo_home,
    AVG(away_goal) OVER(PARTITION BY season, 
            EXTRACT(month FROM date)) AS season_mo_away
FROM match
WHERE 
	hometeam_id = 8673 
    OR awayteam_id = 8673
ORDER BY (home_goal + away_goal) DESC;

#---------------------------------------------------------------------
VIDEO
Sliding Windows
Sliding Windows
	Perform calculations relative to the current row
	Can be used to calculate running totals, sums, averages, etc
	Can be partitioned by one or more columns

Sliding Window Keywords
	ROWS BETWEEN <start> AND <finish>
		PRECEDING
		FOLLOWING
		UNBOUNDED PRECEDING
		UNBOUNDED FOLLOWING
		CURRENT ROW

Sliding Window Example
-- Manchester City Home Games
SELECT
date,
home_goal,
away_goal,
SUM(home_goal)
OVER(ORDER BY date ROWS BETWEEN
UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM match
WHERE hometeam_id = 8456 AND season = '2011/2012';

Sliding Window Frame
-- Manchester City Home Games
SELECT date,
home_goal,
away_goal,
SUM(home_goal)
OVER(ORDER BY date
ROWS BETWEEN 1 PRECEDING
AND CURRENT ROW) AS last2
FROM match
WHERE hometeam_id = 8456
AND season = '2011/2012';

#---------------------------------------------------------------------
Slide to the left
Sliding windows allow you to create running calculations between any two points in a window using functions such as PRECEDING, FOLLOWING, and CURRENT ROW. You can calculate running counts, sums, averages, and other aggregate functions between any two points you specify in the data set.

In this exercise, you will expand on the examples discussed in the video, calculating the running total of goals scored by the FC Utrecht when they were the home team during the 2011/2012 season. Do they score more goals at the end of the season as the home or away team?

SELECT 
	date,
	home_goal,
	away_goal,
    -- Create a running total and running average of home goals
    SUM(home_goal) OVER(ORDER BY date 
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
    AVG(home_goal) OVER(ORDER BY date 
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_avg
FROM match
WHERE 
	hometeam_id = 9908 
	AND season = '2011/2012';

#---------------------------------------------------------------------

Slide to the right
Now let's see how FC Utrecht performs when they're the away team. You'll notice that the total for the season is at the bottom of the data set you queried. Depending on your results, this could be pretty long, and scrolling down is not very helpful.

In this exercise, you will slightly modify the query from the previous exercise by sorting the data set in reverse order and calculating a backward running total from the CURRENT ROW to the end of the data set (earliest record).

SELECT 
	-- Select the date, home goal, and away goals
	date,
    home_goal,
    away_goal,
    -- Create a running total and running average of home goals
    SUM(home_goal) OVER(ORDER BY date DESC
         ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS running_total,
    AVG(home_goal) OVER(ORDER BY date DESC
         ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS running_avg
FROM match
WHERE 
	awayteam_id = 9908 
    AND season = '2011/2012';

#---------------------------------------------------------------------
VIDEO
Bringing it all
Together

What you've learned so far
	CASE statements
	Simple subqueries
	Nested and correlated subqueries
	Common table expressions
	Window functions

#---------------------------------------------------------------------
Setting up the home team CTE
In this course, we've covered ways in which you can use CASE statements, subqueries, common table expressions, and window functions in your queries to structure a data set that best meets your needs. For this exercise, you will be using all of these concepts to generate a list of matches in which Manchester United was defeated during the 2014/2015 English Premier League season.

Your first task is to create the first query that filters for matches where Manchester United played as the home team. This will become a common table expression in a later exercise.

SELECT 
	m.id, 
    t.team_long_name,
    -- Identify matches as home/away wins or ties
	CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		WHEN m.home_goal < m.away_goal THEN 'MU Loss'
        ELSE 'Tie' END AS outcome
FROM match AS m
-- Left join team on the home team ID and team API id
LEFT JOIN team AS t 
ON m.hometeam_id = t.team_api_id
WHERE 
	-- Filter for 2014/2015 and Manchester United as the home team
	season = '2014/2015'
	AND t.team_long_name = 'Manchester United';
	
#---------------------------------------------------------------------

Setting up the away team CTE
Great job! Now that you have a query identifying the home team in a match, you will perform a similar set of steps to identify the away team. Just like the previous step, you will join the match and team tables. Each of these two queries will be declared as a Common Table Expression in the following step.

The primary difference in this query is that you will be joining the tables on awayteam_id, and reversing the match outcomes in the CASE statement.

When altering CASE statement logic in your own work, you can reverse either the logical condition (i.e., home_goal > away_goal) or the outcome in THEN -- just make sure you only reverse one of the two!

SELECT 
	m.id, 
    t.team_long_name,
    -- Identify matches as home/away wins or ties
	CASE WHEN m.home_goal > m.away_goal THEN 'MU Loss'
		WHEN m.home_goal < m.away_goal THEN 'MU Win'
        ELSE 'Tie' END AS outcome
-- Join team table to the match table
FROM match AS m
LEFT JOIN team AS t 
ON m.awayteam_id = t.team_api_id
WHERE 
	-- Filter for 2014/2015 and Manchester United as the away team
	season = '2014/2015'
	AND t.team_long_name = 'Manchester United';

#---------------------------------------------------------------------
Putting the CTEs together
Now that you've created the two subqueries identifying the home and away team opponents, it's time to rearrange your query with the home and away subqueries as Common Table Expressions (CTEs). You'll notice that the main query includes the phrase, SELECT DISTINCT. Without identifying only DISTINCT matches, you will return a duplicate record for each game played.

Continue building the query to extract all matches played by Manchester United in the 2014/2015 season.

-- Set up the home team CTE
WITH home AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		   WHEN m.home_goal < m.away_goal THEN 'MU Loss' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.hometeam_id = t.team_api_id),
-- Set up the away team CTE
away AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		   WHEN m.home_goal < m.away_goal THEN 'MU Loss' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.awayteam_id = t.team_api_id)
-- Select team names, the date and goals
SELECT DISTINCT
    m.date,
    home.team_long_name AS home_team,
    away.team_long_name AS away_team,
    m.home_goal,
    m.away_goal
-- Join the CTEs onto the match table
FROM match AS m
LEFT JOIN home ON m.id = home.id
LEFT JOIN away ON m.id = away.id
WHERE m.season = '2014/2015'
      AND (home.team_long_name = 'Manchester United' 
           OR away.team_long_name = 'Manchester United');

#---------------------------------------------------------------------

Add a window function
Fantastic! You now have a result set that retrieves the match date, home team, away team, and the goals scored by each team. You have one final component of the question left -- how badly did Manchester United lose in each match?

In order to determine this, let's add a window function to the main query that ranks matches by the absolute value of the difference between home_goal and away_goal. This allows us to directly compare the difference in scores without having to consider whether Manchester United played as the home or away team!

The equation is complete for you -- all you need to do is properly complete the window function!

-- Set up the home team CTE
WITH home AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		   WHEN m.home_goal < m.away_goal THEN 'MU Loss' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.hometeam_id = t.team_api_id),
-- Set up the away team CTE
away AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Loss'
		   WHEN m.home_goal < m.away_goal THEN 'MU Win' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.awayteam_id = t.team_api_id)
-- Select columns and and rank the matches by date
SELECT DISTINCT
    m.date,
    home.team_long_name AS home_team,
    away.team_long_name AS away_team,
    m.home_goal, m.away_goal,
    RANK() OVER(ORDER BY ABS(home_goal - away_goal) DESC) as match_rank
-- Join the CTEs onto the match table
FROM match AS m
LEFT JOIN home ON m.id = home.id
LEFT JOIN away ON m.id = away.id
WHERE m.season = '2014/2015'
      AND ((home.team_long_name = 'Manchester United' AND home.outcome = 'MU Loss')
      OR (away.team_long_name = 'Manchester United' AND away.outcome = 'MU Loss'));









END

*/
