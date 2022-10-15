/*

######################################################################
######################################################################
######################################################################

# COURSE PostgreSQL Summary Stats and Window Functions

Course outline
1. Introduction to window functions
2. Fetching, ranking, and paging
3. Aggregate window functions and frames
4. Beyond window functions

Summer olympics dataset
Each row represents a medal awarded in the Summer Olympics games
Columns
Year , City
Sport , Discipline , Event
Athlete , Country , Gender
Medal

######################################################################
######################################################################
######################################################################

######## Introduction to window functions (Module 01-024)
######################################################################
video

Window functions
    Perform an operation across a set of rows that are somehow related to the current row
    Similar to GROUP BY aggregate functions, but all rows remain in the output

Uses
    Fetching values from preceding or following rows (e.g. fetching the previous row's value)
        Determining reigning champion status
        Calculating growth over time
    ssigning ordinal ranks (1rst, 2nd, etc.) to rows based on their values' positions in a sorted list
    unning totals, moving averages

SELECT
Year, Event, Country,
ROW_NUMBER() OVER () AS Row_N
FROM Summer_Medals
WHERE
Medal = 'Gold';

FUNCTION_NAME() OVER (...)
    ORDER BY
    PARTITION BY
    ROWS/RANGE PRECEDING/FOLLOWING/UNBOUNDED

#---------------------------------------------------------------------
Numbering rows
The simplest application for window functions is numbering rows. Numbering rows allows you to easily fetch the nth row. For example, it would be very difficult to get the 35th row in any given table if you didn't have a column with each row's number.

SELECT
  *,
  -- Assign numbers to each row
  ROW_NUMBER() OVER() AS Row_N
FROM Summer_Medals
ORDER BY Row_N ASC;

#---------------------------------------------------------------------

Numbering Olympic games in ascending order
The Summer Olympics dataset contains the results of the games between 1896 and 2012. The first Summer Olympics were held in 1896, the second in 1900, and so on. What if you want to easily query the table to see in which year the 13th Summer Olympics were held? You'd need to number the rows for that.

SELECT
  Year,

  -- Assign numbers to each year
  ROW_NUMBER() OVER() AS Row_N
FROM (
  SELECT DISTINCT Year
  FROM Summer_Medals
  ORDER BY Year ASC
) AS Years
ORDER BY Year ASC;


#---------------------------------------------------------------------
VIDEO
Row numbers
SELECT
Year, Event, Country,
ROW_NUMBER() OVER () AS Row_N
FROM Summer_Medals
WHERE
Medal = 'Gold';

Enter ORDER BY
ORDER BY in OVER orders the rows related to the current row
Example: Ordering by year in descending order in ROW_NUMBER 's OVER clause will assign 1 to
the most recent year's rows

***Ordering by Year in descending order
SELECT
Year, Event, Country,
ROW_NUMBER() OVER (ORDER BY Year DESC) AS Row_N
FROM Summer_Medals
WHERE
Medal = 'Gold';

***Ordering by multiple columns
SELECT
Year, Event, Country,
ROW_NUMBER() OVER
(ORDER BY Year DESC, Event ASC) AS Row_N
FROM Summer_Medals
WHERE
Medal = 'Gold';

***Ordering in- and outside OVER
SELECT
Year, Event, Country,
ROW_NUMBER() OVER
(ORDER BY Year DESC, Event ASC) AS Row_N
FROM Summer_Medals
WHERE
Medal = 'Gold'
ORDER BY Country ASC, Row_N ASC;


***Reigning champion
    A reigning champion is a champion who's won both the previous and current years' competitions
    The previous and current year's champions need to be in the same row (in two different columns)

Enter LAG
    LAG(column, n) OVER (...) returns column 's value at the row n rows before the
current row
    LAG(column, 1) OVER (...) returns the previous row's value

***Current champions
Year, Country AS Champion
FROM Summer_Medals
WHERE
Year IN (1996, 2000, 2004, 2008, 2012)
AND Gender = 'Men' AND Medal = 'Gold'
AND Event = 'Discus Throw';

***Current and last champions
WITH Discus_Gold AS (
SELECT
Year, Country AS Champion
FROM Summer_Medals
WHERE
Year IN (1996, 2000, 2004, 2008, 2012)
AND Gender = 'Men' AND Medal = 'Gold'
AND Event = 'Discus Throw')
SELECT
Year, Champion,
LAG(Champion, 1) OVER
(ORDER BY Year ASC) AS Last_Champion
FROM Discus_Gold
ORDER BY Year ASC;

#---------------------------------------------------------------------

Numbering Olympic games in descending order
You've already numbered the rows in the Summer Medals dataset. What if you need to reverse the row numbers so that the most recent Olympic games' rows have a lower number?

SELECT
  Year,
  -- Assign the lowest numbers to the most recent years
  ROW_NUMBER() OVER (ORDER BY Year DESC) AS Row_N
FROM (
  SELECT DISTINCT Year
  FROM Summer_Medals
) AS Years
ORDER BY Year;

#---------------------------------------------------------------------

Numbering Olympic athletes by medals earned
Row numbering can also be used for ranking. For example, numbering rows and ordering by the count of medals each athlete earned in the OVER clause will assign 1 to the highest-earning medalist, 2 to the second highest-earning medalist, and so on.

STEP01
SELECT
  -- Count the number of medals each athlete has earned
  athlete,
  COUNT(*) AS Medals
FROM Summer_Medals
GROUP BY Athlete
ORDER BY Medals DESC;

STEP02
WITH Athlete_Medals AS (
  SELECT
    -- Count the number of medals each athlete has earned
    Athlete,
    COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete)

SELECT
  -- Number each athlete by how many medals they've earned
  athlete,
  ROW_NUMBER() OVER (ORDER BY Medals DESC) AS Row_N
FROM Athlete_Medals
ORDER BY Medals DESC;

#---------------------------------------------------------------------
Reigning weightlifting champions
A reigning champion is a champion who's won both the previous and current years' competitions. To determine if a champion is reigning, the previous and current years' results need to be in the same row, in two different columns.

STEP01
SELECT
  -- Return each year's champions' countries
  year,
  country AS champion
FROM Summer_Medals
WHERE
  Discipline = 'Weightlifting' AND
  Event = '69KG' AND
  Gender = 'Men' AND
  Medal = 'Gold';

STEP02
WITH Weightlifting_Gold AS (
  SELECT
    -- Return each year's champions' countries
    Year,
    Country AS champion
  FROM Summer_Medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold')

SELECT
  Year, Champion,
  -- Fetch the previous year's champion
  LAG(Champion, 1) OVER
    (ORDER BY Year ASC) AS Last_Champion
FROM Weightlifting_Gold
ORDER BY Year ASC;

#---------------------------------------------------------------------
vIDEO
PARTITION BY


***motive
WITH Discus_Gold AS (
SELECT
Year, Event, Country AS Champion
FROM Summer_Medals
WHERE
Year IN (2004, 2008, 2012)
AND Gender = 'Men' AND Medal = 'Gold'
AND Event IN ('Discus Throw', 'Triple Jump')
AND Gender = 'Men')
SELECT
Year, Event, Champion,
LAG(Champion) OVER
(ORDER BY Event ASC, Year ASC) AS Last_Champion
FROM Discus_Gold
ORDER BY Event ASC, Year ASC;

When Event changes from
Discus Throw to Triple Jump , LAG
fetched Discus Throw 's last champion as
opposed to a null

***Enter PARTITION BY
PARTITION BY splits the table into partitions based on a column's unique values
    The results aren't rolled into one column
Operated on separately by the window function
    ROW_NUMBER will reset for each partition
    LAG will only fetch a row's previous value if its previous row is in the same partition


***Partitioning by one column
WITH Discus_Gold AS (...)
SELECT
Year, Event, Champion,
LAG(Champion) OVER
(PARTITION BY Event
ORDER BY Event ASC, Year ASC) AS Last_Champion
FROM Discus_Gold
ORDER BY Event ASC, Year ASC;

***Partitioning by multiple columns
WITH Country_Gold AS (
SELECT
DISTINCT Year, Country, Event
FROM Summer_Medals
WHERE
Year IN (2008, 2012)
AND Country IN ('CHN', 'JPN')
AND Gender = 'Women' AND Medal = 'Gold')
SELECT
Year, Country, Event,
ROW_NUMBER() OVER (PARTITION BY Year, Country)
FROM Country_Gold;

#---------------------------------------------------------------------
Reigning champions by gender
You've already fetched the previous year's champion for one event. However, if you have multiple events, genders, or other metrics as columns, you'll need to split your table into partitions to avoid having a champion from one event or gender appear as the previous champion of another event or gender.

WITH Tennis_Gold AS (
  SELECT DISTINCT
    Gender, Year, Country
  FROM Summer_Medals
  WHERE
    Year >= 2000 AND
    Event = 'Javelin Throw' AND
    Medal = 'Gold')

SELECT
  Gender, Year,
  Country AS Champion,
  -- Fetch the previous year's champion by gender
  LAG(Country) OVER (PARTITION BY Gender
            ORDER BY Year ASC) AS Last_Champion
FROM Tennis_Gold
ORDER BY Gender ASC, Year ASC;

#---------------------------------------------------------------------
Reigning champions by gender and event
In the previous exercise, you partitioned by gender to ensure that data about one gender doesn't get mixed into data about the other gender. If you have multiple columns, however, partitioning by only one of them will still mix the results of the other columns.

WITH Athletics_Gold AS (
  SELECT DISTINCT
    Gender, Year, Event, Country
  FROM Summer_Medals
  WHERE
    Year >= 2000 AND
    Discipline = 'Athletics' AND
    Event IN ('100M', '10000M') AND
    Medal = 'Gold')

SELECT
  Gender, Year, Event,
  Country AS Champion,
  -- Fetch the previous year's champion by gender and event
  LAG(Country) OVER (PARTITION BY Gender, Event
            ORDER BY Year ASC) AS Last_Champion
FROM Athletics_Gold
ORDER BY Event ASC, Gender ASC, Year ASC;

######################################################################
######################################################################
######################################################################

######## Fetching, ranking, and paging  (Module 02-024)
######################################################################
video
The four functions
  Relative
    LAG(column, n) returns column 's value at the row n rows before the current row
    LEAD(column, n) returns column 's value at the row n rows after the current row

  Absolute
    FIRST_VALUE(column) returns the first 
    LAST_VALUE(column) returns the last value in the table or partition

***LEAD
WITH Hosts AS (
SELECT DISTINCT Year, City
FROM Summer_Medals)
SELECT
Year, City,
LEAD(City, 1) OVER (ORDER BY Year ASC)
AS Next_City,
LEAD(City, 2) OVER (ORDER BY Year ASC)
AS After_Next_City
FROM Hosts
ORDER BY Year ASC;

***FIRST_VALUE and LAST_VALUE
SELECT
Year, City,
FIRST_VALUE(City) OVER
(ORDER BY Year ASC) AS First_City,
LAST_VALUE(City) OVER (
ORDER BY Year ASC
RANGE BETWEEN
UNBOUNDED PRECEDING AND
UNBOUNDED FOLLOWING
) AS Last_City
FROM Hosts
ORDER BY Year ASC;

***Partitioning with LEAD
LEAD(Champion, 1) with
PARTITION BY Event
***Partitioning with FIRST_VALUE
FIRST_VALUE(Champion) with
PARTITION BY Event

#---------------------------------------------------------------------
Future gold medalists
Fetching functions allow you to get values from different parts of the table into one row. If you have time-ordered data, you can "peek into the future" with the LEAD fetching function. This is especially useful if you want to compare a current value to a future value.

WITH Discus_Medalists AS (
  SELECT DISTINCT
    Year,
    Athlete
  FROM Summer_Medals
  WHERE Medal = 'Gold'
    AND Event = 'Discus Throw'
    AND Gender = 'Women'
    AND Year >= 2000)

SELECT
  -- For each year, fetch the current and future medalists
  Year,
  athlete,
  LEAD(athlete, 3) OVER (ORDER BY Year ASC) AS Future_Champion
FROM Discus_Medalists
ORDER BY Year ASC;

#---------------------------------------------------------------------

First athlete by name
It's often useful to get the first or last value in a dataset to compare all other values to it. With absolute fetching functions like FIRST_VALUE, you can fetch a value at an absolute position in the table, like its beginning or end.

WITH All_Male_Medalists AS (
  SELECT DISTINCT
    Athlete
  FROM Summer_Medals
  WHERE Medal = 'Gold'
    AND Gender = 'Men')

SELECT
  -- Fetch all athletes and the first althete alphabetically
  Athlete,
  FIRST_VALUE(athlete) OVER (
    ORDER BY Athlete ASC
  ) AS First_Athlete
FROM All_Male_Medalists;

#---------------------------------------------------------------------

Last country by name
Just like you can get the first row's value in a dataset, you can get the last row's value. This is often useful when you want to compare the most recent value to previous values.

WITH Hosts AS (
  SELECT DISTINCT Year, City
    FROM Summer_Medals)

SELECT
  Year,
  City,
  -- Get the last city in which the Olympic games were held
  LAST_VALUE(City) OVER (
   ORDER BY Year ASC
   RANGE BETWEEN
     UNBOUNDED PRECEDING AND
     UNBOUNDED FOLLOWING
  ) AS Last_City
FROM Hosts
ORDER BY Year ASC;

#---------------------------------------------------------------------
video
Ranking

The ranking functions
  ROW_NUMBER() always assigns unique numbers, even if two rows' values are the same
  RANK() assigns the same number to rows with identical values, skipping over the next numbers in
such cases
  DENSE_RANK() also assigns the same number to rows with identical values, but doesn't skip over
the next numbers

***Source table
SELECT
Country, COUNT(DISTINCT Year) AS Games
FROM Summer_Medals
WHERE
Country IN ('GBR', 'DEN', 'FRA',
'ITA', 'AUT', 'BEL',
'NOR', 'POL', 'ESP')
GROUP BY Country
ORDER BY Games DESC;

***Different ranking functions - ROW_NUMBER
WITH Country_Games AS (...)
SELECT
Country, Games,
ROW_NUMBER()
OVER (ORDER BY Games DESC) AS Row_N
FROM Country_Games
ORDER BY Games DESC, Country ASC;

***Different ranking functions - RANK
WITH Country_Games AS (...)
SELECT
Country, Games,
ROW_NUMBER()
OVER (ORDER BY Games DESC) AS Row_N,
RANK()
OVER (ORDER BY Games DESC) AS Rank_N
FROM Country_Games
ORDER BY Games DESC, Country ASC;

***Different ranking functions - DENSE_RANK
WITH Country_Games AS (...)
SELECT
Country, Games,
ROW_NUMBER()
OVER (ORDER BY Games DESC) AS Row_N,
RANK()
OVER (ORDER BY Games DESC) AS Rank_N,
DENSE_RANK()
OVER (ORDER BY Games DESC) AS Dense_Rank_N
FROM Country_Games
ORDER BY Games DESC, Country ASC;

  ROW_NUMBER and RANK will have the
same last rank, the count of rows
  DENSE_RANK 's last rank is the count of
unique values being ranked

***Ranking without partitioning - Source table
SELECT
Country, Athlete, COUNT(*) AS Medals
FROM Summer_Medals
WHERE
Country IN ('CHN', 'RUS')
AND Year = 2012
GROUP BY Country, Athlete
HAVING COUNT(*) > 1
ORDER BY Country ASC, Medals DESC;

***Ranking without partitioning
WITH Country_Medals AS (...)
SELECT
Country, Athlete, Medals,
DENSE_RANK()
OVER (ORDER BY Medals DESC) AS Rank_N
FROM Country_Medals
ORDER BY Country ASC, Medals DESC;

***Ranking with partitioning
WITH Country_Medals AS (...)
SELECT
Country, Athlete,
DENSE_RANK()
OVER (PARTITION BY Country
ORDER BY Medals DESC) AS Rank_N
FROM Country_Medals
ORDER BY Country ASC, Medals DESC;

#---------------------------------------------------------------------
Ranking athletes by medals earned
In chapter 1, you used ROW_NUMBER to rank athletes by awarded medals. However, ROW_NUMBER assigns different numbers to athletes with the same count of awarded medals, so it's not a useful ranking function; if two athletes earned the same number of medals, they should have the same rank.

WITH Athlete_Medals AS (
  SELECT
    Athlete,
    COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete)

SELECT
  Athlete,
  Medals,
  -- Rank athletes by the medals they've won
  RANK() OVER (ORDER BY Medals DESC) AS Rank_N
FROM Athlete_Medals
ORDER BY Medals DESC;

#---------------------------------------------------------------------
Ranking athletes from multiple countries
In the previous exercise, you used RANK to assign rankings to one group of athletes. In real-world data, however, you'll often find numerous groups within your data. Without partitioning your data, one group's values will influence the rankings of the others.

Also, while RANK skips numbers in case of identical values, the most natural way to assign rankings is not to skip numbers. If two countries are tied for second place, the country after them is considered to be third by most people.

WITH Athlete_Medals AS (
  SELECT
    Country, Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('JPN', 'KOR')
    AND Year >= 2000
  GROUP BY Country, Athlete
  HAVING COUNT(*) > 1)

SELECT
  Country,
  -- Rank athletes in each country by the medals they've won
  Athlete,
  DENSE_RANK() OVER (PARTITION BY Country
                ORDER BY Medals DESC) AS Rank_N
FROM Athlete_Medals
ORDER BY Country ASC, RANK_N ASC;

#---------------------------------------------------------------------
video
Paging

What is paging?
  Paging: Splitting data into (approximately) equal chunks
  Uses
    Many APIs return data in "pages" to reduce data being sent
    Separating data into quartiles or thirds (top middle 33%, and bottom thirds) to judge
    performance

  Enter NTILE
    NTILE(n) splits the data into n approximately equal pages

***Paging - Source table
SELECT
DISTINCT Discipline
FROM Summer_Medals;
  Split the data into 15 approx. equally sized
  pages
  67/15 ≃ 4, so each each page will contain
  four or 5 rows

***Paging
WITH Disciplines AS (
SELECT
DISTINCT Discipline
FROM Summer_Medals)
SELECT
Discipline, NTILE(15) OVER () AS Page
From Disciplines
ORDER BY Page ASC;

***Top, middle, and bottom thirds
WITH Country_Medals AS (
SELECT
Country, COUNT(*) AS Medals
FROM Summer_Medals
GROUP BY Country),
SELECT
Country, Medals,
NTILE(3) OVER (ORDER BY Medals DESC) AS Third
FROM Country_Medals;

***Thirds averages
WITH Country_Medals AS (...),
Thirds AS (
SELECT
Country, Medals,
NTILE(3) OVER (ORDER BY Medals DESC) AS Third
FROM Country_Medals)
SELECT
Third,
ROUND(AVG(Medals), 2) AS Avg_Medals
FROM Thirds
GROUP BY Third
ORDER BY Third ASC;

#---------------------------------------------------------------------
Paging events
There are exactly 666 unique events in the Summer Medals Olympics dataset. If you want to chunk them up to analyze them piece by piece, you'll need to split the events into groups of approximately equal size.

WITH Events AS (
  SELECT DISTINCT Event
  FROM Summer_Medals)
  
SELECT
  --- Split up the distinct events into 111 unique groups
  event,
  NTILE(111) OVER (ORDER BY event ASC) AS Page
FROM Events
ORDER BY Event ASC;

#---------------------------------------------------------------------

Top, middle, and bottom thirds
Splitting your data into thirds or quartiles is often useful to understand how the values in your dataset are spread. Getting summary statistics (averages, sums, standard deviations, etc.) of the top, middle, and bottom thirds can help you determine what distribution your values follow.

step01
WITH Athlete_Medals AS (
  SELECT Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete
  HAVING COUNT(*) > 1)
  
SELECT
  Athlete,
  Medals,
  -- Split athletes into thirds by their earned medals
  NTILE(3) OVER (ORDER BY Medals DESC) AS Third
FROM Athlete_Medals
ORDER BY Medals DESC, Athlete ASC;

step02
WITH Athlete_Medals AS (
  SELECT Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete
  HAVING COUNT(*) > 1),
  
  Thirds AS (
  SELECT
    Athlete,
    Medals,
    NTILE(3) OVER (ORDER BY Medals DESC) AS Third
  FROM Athlete_Medals)
  
SELECT
  -- Get the average medals earned in each third
  Third,
  AVG(Medals) AS Avg_Medals
FROM Thirds
GROUP BY Third
ORDER BY Third ASC;

######################################################################
######################################################################
######################################################################

######## Aggregate window functions and frames (Module 03-024)
######################################################################
video
Aggregate window
functions

***Source table
SELECT
Year, COUNT(*) AS Medals
FROM Summer_Medals
WHERE
Country = 'BRA'
AND Medal = 'Gold'
AND Year >= 1992
GROUP BY Year
ORDER BY Year ASC;

***Aggregate functions
    MAX Query
WITH Brazil_Medals AS (...)
SELECT MAX(Medals) AS Max_Medals
FROM Brazil_Medals;

    SUM Query
WITH Brazil_Medals AS (...)
SELECT SUM(Medals) AS Total_Medals
FROM Brazil_Medals;

***MAX Window function
WITH Brazil_Medals AS (...)
SELECT
Year, Medals,
MAX(Medals)
OVER (ORDER BY Year ASC) AS Max_Medals
FROM Brazil_Medals;

***SUM Window function
WITH Brazil_Medals AS (...)
SELECT
Year, Medals,
SUM(Medals) OVER (ORDER BY Year ASC) AS Medals_RT
FROM Brazil_Medals;

***Partitioning with aggregate window functions
  nopart
WITH Medals AS (...)
SELECT Year, Country, Medals,
SUM(Meals) OVER (...)
FROM Medals;

  yespart
WITH Medals AS (...)
SELECT Year, Country, Medals,
SUM(Meals) OVER (PARTITION BY Country ...)
FROM Medals;

#---------------------------------------------------------------------
Running totals of athlete medals
The running total (or cumulative sum) of a column helps you determine what each row's contribution is to the total sum.

WITH Athlete_Medals AS (
  SELECT
    Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'USA' AND Medal = 'Gold'
    AND Year >= 2000
  GROUP BY Athlete)

SELECT
  -- Calculate the running total of athlete medals
  Athlete,
  Medals,
  SUM(Medals) OVER (ORDER BY Athlete ASC) AS Max_Medals
FROM Athlete_Medals
ORDER BY Athlete ASC;

#---------------------------------------------------------------------
Maximum country medals by year
Getting the maximum of a country's earned medals so far helps you determine whether a country has broken its medals record by comparing the current year's earned medals and the maximum so far.

WITH Country_Medals AS (
  SELECT
    Year, Country, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('CHN', 'KOR', 'JPN')
    AND Medal = 'Gold' AND Year >= 2000
  GROUP BY Year, Country)

SELECT
  -- Return the max medals earned so far per country
  Year,
  Country,
  Medals,
  MAX(Medals) OVER (PARTITION BY Country
                ORDER BY Year ASC) AS Max_Medals
FROM Country_Medals
ORDER BY Country ASC, Year ASC;

#---------------------------------------------------------------------
Minimum country medals by year
So far, you've seen MAX and SUM, aggregate functions normally used with GROUP BY, being used as window functions. You can also use the other aggregate functions, like MIN, as window functions.

WITH France_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'FRA'
    AND Medal = 'Gold' AND Year >= 2000
  GROUP BY Year)

SELECT
  Year,
  Medals,
  MIN(Medals) OVER (ORDER BY Year ASC) AS Min_Medals
FROM France_Medals
ORDER BY Year ASC;

#---------------------------------------------------------------------
video
Frames

***Motivation
LAST_VALUE(City) OVER (
ORDER BY Year ASC
RANGE BETWEEN
UNBOUNDED PRECEDING AND
UNBOUNDED FOLLOWING
) AS Last_City

Frame: RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
Without the frame, LAST_VALUE would return the row's value in the City column
By default, a frame starts at the beginning of a table or partition and ends at the current row

***ROWS BETWEEN
  ROWS BETWEEN [START] AND [FINISH]
    n PRECEDING : n rows before the current row
    CURRENT ROW : the current row
    n FOLLOWING : n rows after the current row
  Examples
    ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ROWS BETWEEN 5 PRECEDING AND 1 PRECEDING

***Source table
SELECT
Year, COUNT(*) AS Medals
FROM Summer_Medals
WHERE
Country = 'RUS'
AND Medal = 'Gold'
GROUP BY Year
ORDER BY Year ASC;

***MAX without a frame
WITH Russia_Medals AS (...)
SELECT
Year, Medals,
MAX(Medals)
OVER (ORDER BY Year ASC) AS Max_Medals
FROM Russia_Medals
ORDER BY Year ASC;

***MAX with a frame
WITH Russia_Medals AS (...)
SELECT
Year, Medals,
MAX(Medals)
OVER (ORDER BY Year ASC) AS Max_Medals,
MAX(Medals)
OVER (ORDER BY Year ASC
ROWS BETWEEN
1 PRECEDING AND CURRENT ROW)
AS Max_Medals_Last
FROM Russia_Medals
ORDER BY Year ASC;

***Current and following rows
WITH Russia_Medals AS (...)
SELECT
Year, Medals,
MAX(Medals)
OVER (ORDER BY Year ASC
ROWS BETWEEN
CURRENT ROW AND 1 FOLLOWING)
AS Max_Medals_Next
FROM Russia_Medals
ORDER BY Year ASC;

#---------------------------------------------------------------------
Moving maximum of Scandinavian athletes' medals
Frames allow you to restrict the rows passed as input to your window function to a sliding window for you to define the start and finish.

Adding a frame to your window function allows you to calculate "moving" metrics, inputs of which slide from row to row.

WITH Scandinavian_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('DEN', 'NOR', 'FIN', 'SWE', 'ISL')
    AND Medal = 'Gold'
  GROUP BY Year)

SELECT
  -- Select each year's medals
  Year,
  Medals,
  -- Get the max of the current and next years'  medals
  MAX(Medals) OVER (ORDER BY Year ASC
             ROWS BETWEEN CURRENT ROW
             AND 1 FOLLOWING) AS Max_Medals
FROM Scandinavian_Medals
ORDER BY Year ASC;

#---------------------------------------------------------------------

Moving maximum of Chinese athletes' medals
Frames allow you "peak" forwards or backward without first using the relative fetching functions, LAG and LEAD, to fetch previous rows' values into the current row.

WITH Chinese_Medals AS (
  SELECT
    Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'CHN' AND Medal = 'Gold'
    AND Year >= 2000
  GROUP BY Athlete)

SELECT
  -- Select the athletes and the medals they've earned
  Athlete,
  Medals,
  -- Get the max of the last two and current rows' medals 
  MAX(Medals) OVER (ORDER BY Athlete ASC
            ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW) AS Max_Medals
FROM Chinese_Medals
ORDER BY Athlete ASC;

#---------------------------------------------------------------------
video
Moving averages and
totals

Overview
Moving average (MA): Average of last n periods
  Example: 10-day MA of units sold in sales is the average of the last 10 days' sold units
  Used to indicate momentum/trends
  Also useful in eliminating seasonality
Moving total: Sum of last n periods
  Example: Sum of the last 3 Olympic games' medals
  Used to indicate performance; if the sum is going down, overall performance is going down

***Source table
SELECT
Year, COUNT(*) AS Medals
FROM Summer_Medals
WHERE
Country = 'USA'
AND Medal = 'Gold'
AND Year >= 1980
GROUP BY Year
ORDER BY Year ASC;

***Moving average
WITH US_Medals AS (...)
SELECT
Year, Medals,
AVG(Medals) OVER
(ORDER BY Year ASC
ROWS BETWEEN
2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM US_Medals
ORDER BY Year ASC;

***Moving total
WITH US_Medals AS (...)
SELECT
Year, Medals,
SUM(Medals) OVER
(ORDER BY Year ASC
ROWS BETWEEN
2 PRECEDING AND CURRENT ROW) AS Medals_MT
FROM US_Medals
ORDER BY Year ASC;

ROWS vs RANGE
RANGE BETWEEN [START] AND [FINISH]
  Functions much the same as ROWS BETWEEN
  RANGE treats duplicates in OVER 's ORDER BY subclause as a single entity
  ROWS BETWEEN is almost always used over RANGE BETWEEN

#---------------------------------------------------------------------
Moving average of Russian medals
Using frames with aggregate window functions allow you to calculate many common metrics, including moving averages and totals. These metrics track the change in performance over time.

WITH Russian_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'RUS'
    AND Medal = 'Gold'
    AND Year >= 1980
  GROUP BY Year)

SELECT
  Year, Medals,
  --- Calculate the 3-year moving average of medals earned
  AVG(Medals) OVER
    (ORDER BY Year ASC
     ROWS BETWEEN
     2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM Russian_Medals
ORDER BY Year ASC;

#---------------------------------------------------------------------
Moving total of countries' medals
What if your data is split into multiple groups spread over one or more columns in the table? Even with a defined frame, if you can't somehow separate the groups' data, one group's values will affect the average of another group's values.

WITH Country_Medals AS (
  SELECT
    Year, Country, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Year, Country)

SELECT
  Year, Country, Medals,
  -- Calculate each country's 3-game moving total
  SUM(Medals) OVER
    (PARTITION BY Country
     ORDER BY Year ASC
     ROWS BETWEEN
     2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM Country_Medals
ORDER BY Country ASC, Year ASC;

######################################################################
######################################################################
######################################################################

######## Beyond window functions  (Module 04-024)
######################################################################
video
Pivoting

Transforming tables

***Enter CROSSTAB
CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT * FROM CROSSTAB($$
source_sql TEXT
$$) AS ct (column_1 DATA_TYPE_1,
column_2 DATA_TYPE_2,
...,
column_n DATA_TYPE_N);

***Queries
  ***Before
SELECT
Country, Year, COUNT(*) AS Awards
FROM Summer_Medals
WHERE
Country IN ('CHN', 'RUS', 'USA')
AND Year IN (2008, 2012)
AND Medal = 'Gold'
GROUP BY Country, Year
ORDER BY Country ASC, Year ASC;

  ***After
CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT * FROM CROSSTAB($$
SELECT
Country, Year, COUNT(*) :: INTEGER AS Awards
FROM Summer_Medals
WHERE
Country IN ('CHN', 'RUS', 'USA')
AND Year IN (2008, 2012)
AND Medal = 'Gold'
GROUP BY Country, Year
ORDER BY Country ASC, Year ASC;
$$) AS ct (Country VARCHAR, "2008" INTEGER, "2012" INTEGE
ORDER BY Country ASC;

***Source query
WITH Country_Awards AS (
SELECT
Country, Year, COUNT(*) AS Awards
FROM Summer_Medals
WHERE
Country IN ('CHN', 'RUS', 'USA')
AND Year IN (2004, 2008, 2012)
AND Medal = 'Gold' AND Sport = 'Gymnastics'
GROUP BY Country, Year
ORDER BY Country ASC, Year ASC)
SELECT
Country, Year,
RANK() OVER
(PARTITION BY Year ORDER BY Awards DESC) :: INTEGER
AS rank
FROM Country_Awards
ORDER BY Country ASC, Year ASC;

***Pivot query
CREATE EXTENSION IF NOT EXISTS tablefunc;
SELECT * FROM CROSSTAB($$
...
$$) AS ct (Country VARCHAR,
"2004" INTEGER,
"2008" INTEGER,
"2012" INTEGER)
ORDER BY Country ASC;

#---------------------------------------------------------------------
A basic pivot
You have the following table of Pole Vault gold medalist countries by gender in 2008 and 2012.

| Gender | Year | Country |
|--------|------|---------|
| Men    | 2008 | AUS     |
| Men    | 2012 | FRA     |
| Women  | 2008 | RUS     |
| Women  | 2012 | USA     |
Pivot it by Year to get the following reshaped, cleaner table.

| Gender | 2008 | 2012 |
|--------|------|------|
| Men    | AUS  | FRA  |
| Women  | RUS  | USA  |

-- Create the correct extention to enable CROSSTAB
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
  SELECT
    Gender, Year, Country
  FROM Summer_Medals
  WHERE
    Year IN (2008, 2012)
    AND Medal = 'Gold'
    AND Event = 'Pole Vault'
  ORDER By Gender ASC, Year ASC;
-- Fill in the correct column names for the pivoted table
$$) AS ct (Gender VARCHAR,
           "2008" VARCHAR,
           "2012" VARCHAR)

ORDER BY Gender ASC;

#---------------------------------------------------------------------
Pivoting with ranking
You want to produce an easy scannable table of the rankings of the three most populous EU countries by how many gold medals they've earned in the 2004 through 2012 Olympic games. The table needs to be in this format:

| Country | 2004 | 2008 | 2012 |
|---------|------|------|------|
| FRA     | ...  | ...  | ...  |
| GBR     | ...  | ...  | ...  |
| GER     | ...  | ...  | ...  |
You'll need to count the gold medals each country has earned, produce the ranks of each country by medals earned, then pivot the table to this shape.

step01
-- Count the gold medals per country and year
SELECT
  Country,
  Year,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Country IN ('FRA', 'GBR', 'GER')
  AND Year IN (2004, 2008, 2012)
  AND Medal = 'Gold'
GROUP BY Country, Year
ORDER BY Country ASC, Year ASC

step02
WITH Country_Awards AS (
  SELECT
    Country,
    Year,
    COUNT(*) AS Awards
  FROM Summer_Medals
  WHERE
    Country IN ('FRA', 'GBR', 'GER')
    AND Year IN (2004, 2008, 2012)
    AND Medal = 'Gold'
  GROUP BY Country, Year)

SELECT
  -- Select Country and Year
  Country,
  Year,
  -- Rank by gold medals earned per year
  Rank() OVER (PARTITION BY Year ORDER BY Awards DESC) :: INTEGER AS rank
FROM Country_Awards
ORDER BY Country ASC, Year ASC;

step03
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
  WITH Country_Awards AS (
    SELECT
      Country,
      Year,
      COUNT(*) AS Awards
    FROM Summer_Medals
    WHERE
      Country IN ('FRA', 'GBR', 'GER')
      AND Year IN (2004, 2008, 2012)
      AND Medal = 'Gold'
    GROUP BY Country, Year)

  SELECT
    Country,
    Year,
    RANK() OVER
      (PARTITION BY Year
       ORDER BY Awards DESC) :: INTEGER AS rank
  FROM Country_Awards
  ORDER BY Country ASC, Year ASC;
-- Fill in the correct column names for the pivoted table
$$) AS ct (Country VARCHAR,
           "2004" INTEGER,
           "2008" INTEGER,
           "2012" INTEGER)

ORDER BY Country ASC;

#---------------------------------------------------------------------
video
ROLLUP and CUBE
Group-level totals

***The old way
SELECT
Country, Medal, COUNT(*) AS Awards
FROM Summer_Medals
WHERE
Year = 2008 AND Country IN ('CHN', 'RUS')
GROUP BY Country, Medal
ORDER BY Country ASC, Medal ASC
UNION ALL
SELECT
Country, 'Total', COUNT(*) AS Awards
FROM Summer_Medals
WHERE
Year = 2008 AND Country IN ('CHN', 'RUS')
GROUP BY Country, 2
ORDER BY Country ASC;

***Enter ROLLUP
SELECT
Country, Medal, COUNT(*) AS Awards
FROM Summer_Medals
WHERE
Year = 2008 AND Country IN ('CHN', 'RUS')
GROUP BY Country, ROLLUP(Medal)
ORDER BY Country ASC, Medal ASC;

  ROLLUP is a GROUP BY subclause that includes extra rows for group-level aggregations
  GROUP BY Country, ROLLUP(Medal) will count all Country - and Medal -level totals, then
count only Country -level totals and 

***ROLLUP - Query
SELECT
Country, Medal, COUNT(*) AS Awards
FROM summer_medals
WHERE
Year = 2008 AND Country IN ('CHN', 'RUS')
GROUP BY ROLLUP(Country, Medal)
ORDER BY Country ASC, Medal ASC;

ROLLUP is hierarchical, de-aggregating from the leftmost provided column to the right-most
  ROLLUP(Country, Medal) includes Country -level totals
  ROLLUP(Medal, Country) includes Medal -level totals
Both include grand totals

***ROLLUP - Result
  Group-level totals contain nulls ; the row with all null s is the grand total
  Notice that it didn't include Medal -level totals, since it's ROLLUP(Country, Medal) and not
ROLLUP(Medal, Country)

***Enter CUBE
SELECT
Country, Medal, COUNT(*) AS Awards
FROM summer_medals
WHERE
Year = 2008 AND Country IN ('CHN', 'RUS')
GROUP BY CUBE(Country, Medal)
ORDER BY Country ASC, Medal ASC;

  CUBE is a non-hierarchical ROLLUP
  It generates all possible group-level aggregations
    CUBE(Country, Medal) counts Country -level, Medal -level, and grand totals

***CUBE - Result
  Notice that Medal -level totals are included

***ROLLUP vs CUBE
  Use ROLLUP when you have hierarchical
  data (e.g., date parts) and don't want all
  possible group-level aggregations

  Use CUBE when you want all possible
  group-level aggregations

#---------------------------------------------------------------------
Country-level subtotals
You want to look at three Scandinavian countries' earned gold medals per country and gender in the year 2000. You're also interested in Country-level subtotals to get the total medals earned for each country, but Gender-level subtotals don't make much sense in this case, so disregard them.

-- Count the gold medals per country and gender
SELECT
  country,
  gender,
  COUNT(*) AS Gold_Awards
FROM Summer_Medals
WHERE
  Year = 2004
  AND Medal = 'Gold'
  AND Country IN ('DEN', 'NOR', 'SWE')
-- Generate Country-level subtotals
GROUP BY Country, ROLLUP(Gender)
ORDER BY Country ASC, Gender ASC;

#---------------------------------------------------------------------

All group-level subtotals
You want to break down all medals awarded to Russia in the 2012 Olympic games per gender and medal type. Since the medals all belong to one country, Russia, it makes sense to generate all possible subtotals (Gender- and Medal-level subtotals), as well as a grand total.

Generate a breakdown of the medals awarded to Russia per country and medal type, including all group-level subtotals and a grand total.

-- Count the medals per country and medal type
SELECT
  Gender,
  Medal,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Year = 2012
  AND Country = 'RUS'
-- Get all possible group-level subtotals
GROUP BY CUBE(Gender, Medal)
ORDER BY Gender ASC, Medal ASC;

#---------------------------------------------------------------------
A survey of useful
functions

***Nulls ahoy
SELECT
Country, Medal, COUNT(*) AS Awards
FROM summer_medals
WHERE
Year = 2008 AND Country IN ('CHN', 'RUS')
GROUP BY ROLLUP(Country, Medal)
ORDER BY Country ASC, Medal ASC;

    null s signify group totals

***Enter COALESCE
  COALESCE() takes a list of values and returns the 1st non-null value, going from left to right
  COALESCE(null, null, 1, null, 2) ? 1
  Useful when using SQL operations that return null s
    ROLLUP and CUBE
    Pivoting
    LAG and LEAD

***Annihilating nulls

SELECT
COALESCE(Country, 'Both countries') AS Country,
COALESCE(Medal, 'All medals') AS Medal,
COUNT(*) AS Awards
FROM summer_medals
WHERE
Year = 2008 AND Country IN ('CHN', 'RUS')
GROUP BY ROLLUP(Country, Medal)
ORDER BY Country ASC, Medal ASC;

***Compressing data
Before 
  Rank is redundant because the ranking is
  implied
After
  Succinct and provides all information
  needed because the ranking is implied

***Enter STRING_AGG
  STRING_AGG(column, separator) takes all the values of a column and concatenates them, with
  separator in between each value
  STRING_AGG(Letter, ', ') transforms this...
  | Letter |
|--------|
| A |
| B |
| C |
...into this
A, B, C

***Query and result
    Before
WITH Country_Medals AS (
SELECT
Country, COUNT(*) AS Medals
FROM Summer_Medals
WHERE Year = 2012
AND Country IN ('CHN', 'RUS', 'USA')
AND Medal = 'Gold'
AND Sport = 'Gymnastics'
GROUP BY Country),
SELECT
Country,
RANK() OVER (ORDER BY Medals DESC) AS Rank
FROM Country_Medals
ORDER BY Rank ASC;

    After
WITH Country_Medals AS (...),
Country_Ranks AS (...)
SELECT STRING_AGG(Country, ', ')
FROM Country_Medals;

Result
CHN, RUS, USA

#---------------------------------------------------------------------
Cleaning up results
Returning to the breakdown of Scandinavian awards you previously made, you want to clean up the results by replacing the nulls with meaningful text.

SELECT
  -- Replace the nulls in the columns with meaningful text
  COALESCE(Country, 'All countries') AS Country,
  COALESCE(Gender, 'All genders') AS Gender,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Year = 2004
  AND Medal = 'Gold'
  AND Country IN ('DEN', 'NOR', 'SWE')
GROUP BY ROLLUP(Country, Gender)
ORDER BY Country ASC, Gender ASC;

#---------------------------------------------------------------------

Summarizing results
After ranking each country in the 2000 Olympics by gold medals awarded, you want to return the top 3 countries in one row, as a comma-separated string. In other words, turn this:

| Country | Rank |
|---------|------|
| USA     | 1    |
| RUS     | 2    |
| AUS     | 3    |
| ...     | ...  |
into this:

USA, RUS, AUS

step01
WITH Country_Medals AS (
  SELECT
    Country,
    COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE Year = 2000
    AND Medal = 'Gold'
  GROUP BY Country)

  SELECT
    Country,
    -- Rank countries by the medals awarded
    RANK() OVER (ORDER BY Medals DESC) AS Rank
  FROM Country_Medals
  ORDER BY Rank ASC;

step02
WITH Country_Medals AS (
  SELECT
    Country,
    COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE Year = 2000
    AND Medal = 'Gold'
  GROUP BY Country),

  Country_Ranks AS (
  SELECT
    Country,
    RANK() OVER (ORDER BY Medals DESC) AS Rank
  FROM Country_Medals
  ORDER BY Rank ASC)

-- Compress the countries column
SELECT STRING_AGG(Country, ', ')
FROM Country_Ranks
-- Select only the top three ranks
WHERE Rank <= 3







END

*/