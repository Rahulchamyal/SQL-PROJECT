-- tutorial.crunchbase_companies 
select * from tutorial.crunchbase_companies ;
-- q1) Find the list of unique country codes in the data. 
select DISTINCT country_code 
from tutorial.crunchbase_companies ;

-- q2) Find the list of all the companies funded on or after 2009.
SELECT DISTINCT name
from tutorial.crunchbase_companies 
WHERE  founded_year >= '2009';

-- q3)Find the list of all the companies founded before 2015 and have received funding of at least 1 Mn USD or after 2009. 
SELECT DISTINCT name
FROM tutorial.crunchbase_companies
WHERE founded_year < 2015
   OR (funding_total_usd >= 1000000
       OR (first_funding_at >= '2009-01-01' AND first_funding_at IS NOT NULL)
       OR (last_funding_at >= '2009-01-01' AND last_funding_at IS NOT NULL));

-- q4)Find the list of all the companies that has funding between 3 to 6 rounds.
SELECT DISTINCT name
FROM tutorial.crunchbase_companies
WHERE funding_rounds BETWEEN 3 AND 6;

-- q5)Find the list of all the companies founded in India(IN), the USA(USA), and the Great Britain(GBR).
SELECT DISTINCT name
FROM tutorial.crunchbase_companies
WHERE country_code IN ('IND', 'USA', 'GBR');

--q6)Find the list of all the companies which are either acquired or operating.
SELECT DISTINCT name
FROM tutorial.crunchbase_companies
WHERE status = 'acquired' OR status = 'operating';

--q7)Find the list of all the companies starting with the letter S.
SELECT DISTINCT name
FROM tutorial.crunchbase_companies
WHERE name LIKE 'S%';

--q8)Find the list of all the companies founded in the city containing word ‘Park’.
SELECT DISTINCT name
FROM tutorial.crunchbase_companies
WHERE city LIKE '%Park%';

--q9)Find the list of all the companies which are operated outside the USA(USA), Australia(AUS), and Argentina(ARG).
SELECT DISTINCT name
FROM tutorial.crunchbase_companies
WHERE country_code NOT IN ('USA', 'AUS', 'ARG');

--q10)Find the list of all the companies founded after 2015 or have received funding of at least 1 Mn USD.
SELECT DISTINCT name
FROM tutorial.crunchbase_companies
WHERE founded_year > 2015 OR funding_total_usd >= 1000000;

--q11)Find the list of unique country codes in the data excluding the null values.
SELECT DISTINCT country_code
FROM tutorial.crunchbase_companies
WHERE country_code IS NOT NULL;

-- ASSIGNMENT – 02
select * from tutorial.sat_scores;

--1 Find the minimum marks in sat_verbal in the dataset.
SELECT MIN(sat_verbal)
FROM tutorial.sat_scores;

--2 Find the maximum marks in sat_writing in the dataset.
SELECT MAX(sat_writing)
FROM tutorial.sat_scores;

--3 Find the count of students in the dataset.
SELECT COUNT(student_id)
FROM tutorial.sat_scores;

--4 Find the average marks in sat_math in the dataset.
select AVG(sat_math)
from tutorial.sat_scores;

--5 Find the sum of hrs_studied in the dataset.
select SUM(hrs_studied)
from tutorial.sat_scores;

--6 Find the list of unique school in the data using Group by clause.
SELECT school
FROM tutorial.sat_scores
GROUP BY school;

--7 Find the list of unique school and teachers in the data using Group by clause.
SELECT DISTINCT school, teacher
FROM tutorial.sat_scores
GROUP BY school, teacher;

--8 Find the total number of hours studied per school.
SELECT school, SUM(hrs_studied) AS total_hours_studied
FROM tutorial.sat_scores
GROUP BY school;

--9 Find the number of students in each school.
SELECT school, COUNT(student_id) AS number_of_students
FROM tutorial.sat_scores
GROUP BY school;

--10 Find the average marks scored in sat_writing per teacher for the school 'Petersville HS’.
SELECT teacher, AVG(sat_writing) AS average_sat_writing_score
FROM tutorial.sat_scores
WHERE school = 'Petersville HS'
GROUP BY teacher;

--11 Find the maximum marks scored in sat_math per teacher for the school ‘Washington HS’.
SELECT teacher, MAX(sat_math) AS maximum_sat_math_score
FROM tutorial.sat_scores
WHERE school = 'Washington HS'
GROUP BY teacher;

--12 Find the list of unique school and teachers in the data using Group by clause and sort it by ascending order for school and descending order for teacher name.
SELECT school, teacher
FROM tutorial.sat_scores
GROUP BY school, teacher
ORDER BY school ASC, teacher DESC;

--13 Find the list of all the teachers along with the minimum marks scored by their students in sat_verbal. Only consider those teachers where minimum marks is more than 220. Sort the output in ascending order.
SELECT teacher, MIN(sat_verbal) AS minimum_sat_verbal_score
FROM tutorial.sat_scores
GROUP BY teacher
HAVING MIN(sat_verbal) > 220
ORDER BY minimum_sat_verbal_score ASC;

--14 Find the first 5 rows of the data.
SELECT *
FROM tutorial.sat_scores
LIMIT 5;
