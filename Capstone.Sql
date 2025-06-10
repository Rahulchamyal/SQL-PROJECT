-- CASE STUDY 1
SELECT * from tutorial.oscar_nominees;

-- 1 Write a query to display all the records in the table tutorial.oscar_nominees.
SELECT * from tutorial.oscar_nominees;

-- 2 Write a query to find the distinct values in the ‘year’ column.
select distinct year
from tutorial.oscar_nominees;

-- 3 Write a query to filter the records from year 1999 to year 2006.
SELECT *
FROM tutorial.oscar_nominees
WHERE year BETWEEN 1999 AND 2006;

-- 4 Write a query to filter the records for either year 1991 or 1998.
SELECT *
FROM tutorial.oscar_nominees
WHERE year IN (1991, 1998);

-- 5 Write a query to return the winner movie name for the year of 1997.
SELECT movie
FROM tutorial.oscar_nominees
WHERE year = 1997 AND winner = TRUE;

-- 6 Write a query to return the winner in the ‘actor in a leading role’ and ‘actress in a leading role’ category for the year of 1994,1980, and 2008.
SELECT year, category, nominee
FROM tutorial.oscar_nominees
WHERE winner = TRUE
  AND category IN ('actor in a leading role', 'actress in a leading role')
  AND year IN (1994, 1980, 2008);

-- 7 Write a query to return the name of the movie starting from letter ‘a’.
SELECT movie
FROM tutorial.oscar_nominees
WHERE movie LIKE 'A%';

-- 8 Write a query to return the name of movies containing the word ‘the’.
SELECT movie
FROM tutorial.oscar_nominees
WHERE movie LIKE 'The%';

-- 9 Write a query to return all the records where the nominee name starts with “c” and ends with “r”.
SELECT *
FROM tutorial.oscar_nominees
WHERE nominee LIKE 'C%r';

-- 10 Write a query to return all the records where the movie was released in 2005 and movie name does not start with ‘a’ and ‘c’ and nominee was a winner.
SELECT *
FROM tutorial.oscar_nominees
WHERE year = 2005
  AND winner = TRUE
  AND movie NOT LIKE 'A%'
  AND movie NOT LIKE 'C%';
  

-- Case Study 2
select * from tutorial.kag_conversion_data;

--1 Write a query to count the total number of records in the tutorial.kag_conversion_data dataset. 
SELECT COUNT(*)
FROM tutorial.kag_conversion_data;

--2 Write a query to count the distinct number of fb_campaign_id.
SELECT COUNT(DISTINCT fb_campaign_id)
FROM tutorial.kag_conversion_data;

--3 Write a query to find the maximum spent, average interest, minimum impressions for ad_id.
SELECT ad_id,
  MAX(spent) AS max_spent,
  AVG(interest) AS average_interest,
  MIN(impressions) AS minimum_impressions
FROM tutorial.kag_conversion_data
GROUP BY ad_id;

--4 Write a query to create an additional column spent per impressions(spent/impressions).
SELECT *, (spent / impressions) AS spent_per_impressions
FROM tutorial.kag_conversion_data;

--5 Write a query to count the ad_campaign for each age group..
SELECT age,
COUNT(DISTINCT xyz_campaign_id) AS distinct_xyz_campaigns,
COUNT(DISTINCT fb_campaign_id) AS distinct_fb_campaigns,
COUNT(ad_id) AS total_ads_in_age_group 
FROM tutorial.kag_conversion_data
GROUP BY age
ORDER BY age;

--6 Write a query to calculate the average spent on ads for each gender category.
SELECT gender,
AVG(spent) AS average_spent
FROM tutorial.kag_conversion_data
GROUP BY gender;

--7 Write a query to find the total approved conversion per xyz campaign id. Arrange the total conversion in descending order.
SELECT xyz_campaign_id,
SUM(approved_conversion) AS total_approved_conversion
FROM tutorial.kag_conversion_data
GROUP BY xyz_campaign_id
ORDER BY total_approved_conversion DESC;

--8 Write a query to show the fb_campaign_id and total interest per fb_campaign_id. Only show the campaign which has more than 300 interests. 
SELECT fb_campaign_id, SUM(interest) AS total_interest
FROM tutorial.kag_conversion_data
GROUP BY fb_campaign_id
HAVING SUM(interest) > 300
ORDER BY total_interest DESC;

--9 Write a query to find the age and gender segment with maximum impression to interest ratio. Return three columns - age, gender, impression_to_interest. 
SELECT age, gender, (SUM(impressions) * 1.0 / NULLIF(SUM(interest), 0)) AS impression_to_interest_ratio
FROM tutorial.kag_conversion_data
GROUP BY age, gender
ORDER BY impression_to_interest_ratio DESC

--10 Write a query to find the top 2 xyz_campaign_id and gender segment with the maximum total_unapproved_conversion.
SELECT xyz_campaign_id, gender, SUM(COALESCE(total_conversion, 0) - COALESCE(approved_conversion, 0)) AS total_unapproved_conversion
FROM tutorial.kag_conversion_data
GROUP BY xyz_campaign_id, gender
ORDER BY total_unapproved_conversion DESC
LIMIT 2;


-- CASE STUDY 3
select * from tutorial.crunchbase_companies;

--1 Find the top 5 countries(country code) with the highest number of operating companies. Ensure the country code is not null. 
SELECT country_code, COUNT(*) AS number_of_operating_companies
FROM tutorial.crunchbase_companies
WHERE status = 'operating' AND country_code IS NOT NULL
GROUP BY country_code
ORDER BY number_of_operating_companies DESC
LIMIT 5;

--2 How many companies have no country code available in the dataset.
SELECT COUNT(*)
FROM tutorial.crunchbase_companies
WHERE country_code IS NULL;

--3 Find the number of companies starting with letter ‘g’ founded in France(FRA) and still operational(status = operating).
SELECT COUNT(*)
FROM tutorial.crunchbase_companies
WHERE name LIKE 'G%' AND country_code = 'FRA' AND status = 'operating';

--4 How many advertising, founded after 2003, are acquired?
SELECT COUNT(*)
FROM tutorial.crunchbase_companies
WHERE category_code = 'advertising' AND founded_year > 2003 AND status = 'acquired';

--5 Calculated the average funding_total_usd per company for the companies founded in the software, education, and analytics category.
SELECT category_code, AVG(funding_total_usd) AS average_funding_usd
FROM tutorial.crunchbase_companies
WHERE category_code IN ('software', 'education', 'analytics')
GROUP BY category_code;

--6 Find the city having more than 50 closed companies. Return the city and number of companies closed. 
SELECT city, COUNT(name) AS number_of_closed_companies
FROM tutorial.crunchbase_companies
WHERE status = 'closed'
GROUP BY city
HAVING COUNT(name) > 50
ORDER BY number_of_closed_companies DESC;

--7 Find the number of bio-tech companies who are founded after 2000 and either have more than 1Mn funding or have ipo and secured more than 1 round of funding. 
SELECT COUNT(*)
FROM tutorial.crunchbase_companies
WHERE category_code = 'biotech'
  AND founded_year > 2000
  AND (
    funding_total_usd > 1000000
    OR (
      status = 'ipo' AND funding_rounds > 1
    )
  );

--8 Find all number of all acquired companies founded between 1980 and 2005 and founded in the city ending with the word ‘city’. Return the city name and number of acquired companies. 
SELECT city, COUNT(*) AS number_of_acquired_companies
FROM tutorial.crunchbase_companies
WHERE status = 'acquired'
  AND founded_year BETWEEN 1980 AND 2005
  AND LOWER(city) LIKE '%city'
GROUP BY city
ORDER BY number_of_acquired_companies DESC;

--9 Find the number of ‘hardware’ companies founded outside ‘USA’ and did not take any funding. Return the country code and number of hardware companies in descending order.
SELECT country_code, COUNT(*) AS number_of_hardware_companies
FROM tutorial.crunchbase_companies
WHERE category_code = 'hardware'
  AND country_code != 'USA'
  AND (funding_total_usd IS NULL OR funding_total_usd = 0)
GROUP BY country_code
ORDER BY number_of_hardware_companies DESC;

--10 Find the 5 most popular company category(category with highest companies) across the city Singapore, Shanghai, and Bangalore. Return category code and number of companies. 
SELECT category_code, COUNT(*) AS number_of_companies
FROM tutorial.crunchbase_companies
WHERE city IN ('Singapore', 'Shanghai', 'Bangalore')
  AND category_code IS NOT NULL -- Ensure category code is not null for a valid category
GROUP BY category_code
ORDER BY number_of_companies DESC
LIMIT 5;
