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

--SELECT * from benn.college_football_teams 
--Select * from benn.college_football_players

--1 Write a query to return player_name, school_name, position, conference from the above dataset
SELECT p.player_name, p.school_name, p.position, t.conference
FROM benn.college_football_players AS p
JOIN benn.college_football_teams AS t
ON p.school_name = t.school_name;

--2 Write a query to find the total number of players playing in each conference.Order the output in the descending order of number of players.
SELECT t.conference, COUNT(p.player_name) AS total_players
FROM benn.college_football_players AS p
JOIN benn.college_football_teams AS t ON p.school_name = t.school_name
GROUP BY t.conference
ORDER BY total_players DESC;

--3 Write a query to find the average height of players per division. 
SELECT t.division, AVG(p.height) AS average_height
FROM benn.college_football_players AS p
JOIN benn.college_football_teams AS t ON p.school_name = t.school_name
GROUP BY t.division;

--4 Write a query to return to the conference where average weight is more than 210. Order the output in the descending order of average weight. 
SELECT t.conference, AVG(p.weight) AS average_weight
FROM benn.college_football_players AS p
JOIN benn.college_football_teams AS t ON p.school_name = t.school_name
GROUP BY t.conference
HAVING AVG(p.weight) > 210
ORDER BY average_weight DESC;

--5 Write a query to return to the top 3 conference with the highest BMI (weight/height) ratio.
SELECT t.conference, AVG(p.weight * 1.0 / NULLIF(p.height, 0)) AS average_bmi_ratio
FROM benn.college_football_players AS p
JOIN benn.college_football_teams AS t ON p.school_name = t.school_name
GROUP BY t.conference
ORDER BY average_bmi_ratio DESC
LIMIT 3;

-- CASE STUDY 2
--SELECT * FROM tutorial.excel_sql_inventory_data;
--Select * from tutorial.excel_sql_transaction_data

--1 Write a query to join the above tables. Use left join.
SELECT i.*, t.time, t.transaction_id
FROM tutorial.excel_sql_inventory_data AS i
LEFT JOIN tutorial.excel_sql_transaction_data AS t ON i.product_id = t.product_id;

--2 Find the product which does not sell a single unit.
SELECT i.product_name, i.product_id
FROM tutorial.excel_sql_inventory_data AS i
LEFT JOIN tutorial.excel_sql_transaction_data AS t ON i.product_id = t.product_id
WHERE t.transaction_id IS NULL;

--3 Write a query to find how many units are sold per product. Sort the data in terms of unit sold(descending order).
SELECT i.product_name, COUNT(t.transaction_id) AS units_sold
FROM tutorial.excel_sql_inventory_data AS i
JOIN tutorial.excel_sql_transaction_data AS t ON i.product_id = t.product_id
GROUP BY i.product_name
ORDER BY units_sold DESC;

--4 Write a query to return product_type and units_sold where product_type is sold more than 50 times. 
SELECT i.product_type, COUNT(t.transaction_id) AS units_sold
FROM tutorial.excel_sql_inventory_data AS i
JOIN tutorial.excel_sql_transaction_data AS t ON i.product_id = t.product_id
GROUP BY i.product_type
HAVING COUNT(t.transaction_id) > 50
ORDER BY units_sold DESC;

--5 Write a query to return the total revenue generated.  
SELECT SUM(i.price_unit) AS total_revenue
FROM tutorial.excel_sql_inventory_data AS i
JOIN tutorial.excel_sql_transaction_data AS t ON i.product_id = t.product_id;

--6 Write a query to return the most selling product under product_type = ‘dry goods’.
SELECT i.product_name, COUNT(t.transaction_id) AS units_sold
FROM tutorial.excel_sql_inventory_data AS i
JOIN tutorial.excel_sql_transaction_data AS t ON i.product_id = t.product_id
WHERE LOWER(i.product_type) = 'dry goods'
GROUP BY i.product_name
LIMIT 1;

--7 Write a query to find the difference between inventory and total sales per product_type.
WITH ProductSales AS (
  SELECT product_id, COUNT(transaction_id) AS units_sold
  FROM tutorial.excel_sql_transaction_data
  GROUP BY product_id
)
SELECT i.product_type, SUM(i.current_inventory) - SUM(COALESCE(ps.units_sold, 0)) AS inventory_sales_difference
FROM tutorial.excel_sql_inventory_data AS i
LEFT JOIN ProductSales AS ps ON i.product_id = ps.product_id
GROUP BY i.product_type;

--8 Find the product-wise sales for product_type =’dairy’.
SELECT i.product_name, COUNT(t.transaction_id) AS units_sold
FROM tutorial.excel_sql_inventory_data AS i
JOIN tutorial.excel_sql_transaction_data AS t ON i.product_id = t.product_id
WHERE LOWER(i.product_type) = 'dairy'
GROUP BY i.product_name
ORDER BY units_sold DESC;

-- CASE STUDY
-- SELECT * FROM tutorial.yammer_users
-- SELECT * FROM tutorial.yammer_experiments
-- SELECT * FROM tutorial.yammer_events
-- SELECT * FROM tutorial.yammer_emails

--1 Find the number of users per language type.
SELECT language, COUNT(user_id) AS number_of_users
FROM tutorial.yammer_users
GROUP BY language
ORDER BY number_of_users DESC;

--2 Write a query to find how many users are part of experiments.
SELECT COUNT(DISTINCT user_id) AS number_of_users_in_experiments
FROM tutorial.yammer_experiments;

--3 Find the number of users in experiment per language category.
SELECT u.language, COUNT(DISTINCT e.user_id) AS number_of_users_in_experiment
FROM tutorial.yammer_users AS u
JOIN tutorial.yammer_experiments AS e ON u.user_id = e.user_id
GROUP BY u.language
ORDER BY number_of_users_in_experiment DESC;

--4 Write a query to find how many users have received at least one email.
SELECT COUNT(DISTINCT user_id) AS users_received_email
FROM tutorial.yammer_emails;

--5 Write a query to find how many users per company id have received at least one email.
SELECT u.company_id, COUNT(DISTINCT e.user_id) AS users_received_email
FROM tutorial.yammer_users AS u
JOIN tutorial.yammer_emails AS e ON u.user_id = e.user_id
GROUP BY u.company_id
ORDER BY users_received_email DESC;

--6 Write a query to find how many users have received at least one event.
SELECT COUNT(DISTINCT user_id) AS users_received_event
FROM tutorial.yammer_events;

--7 Write a query to find how many distinct users per state have at least one event.
SELECT u.state, COUNT(DISTINCT e.user_id) AS distinct_users_with_events
FROM tutorial.yammer_users AS u
JOIN tutorial.yammer_events AS e ON u.user_id = e.user_id
GROUP BY u.state
ORDER BY distinct_users_with_events DESC;

-- CASE STUDY 4

--SELECT * from tutorial.us_housing_units;
--SELECT * from tutorial.us_housing_units_completed;

--1 Write a query to join the tables tutorial.us_housing_units and tutorial.us_housing_units_completed. Return all the records.
SELECT
  COALESCE(hu.year, huc.year) AS year,
  COALESCE(hu.month, huc.month) AS month,
  hu.west AS housing_units_west,
  hu.south AS housing_units_south,
  hu.midwest AS housing_units_midwest,
  hu.northeast AS housing_units_northeast,
  huc.west AS completed_units_west,
  huc.south AS completed_units_south,
  huc.midwest AS completed_units_midwest,
  huc.northeast AS completed_units_northeast
FROM
  tutorial.us_housing_units AS hu
FULL OUTER JOIN
  tutorial.us_housing_units_completed AS huc
ON
  hu.year = huc.year AND hu.month = huc.month;
  
--2 Write a query to return year, month, month_name and difference between the units and units completed for west from 2000 onwards.
SELECT COALESCE(hu.year, huc.year) AS year, COALESCE(hu.month, huc.month) AS month, COALESCE(hu.month_name, huc.month_name) AS month_name, (hu.west - huc.west) AS difference_west
FROM tutorial.us_housing_units AS hu
FULL OUTER JOIN tutorial.us_housing_units_completed AS huc ON hu.year = huc.year AND hu.month = huc.month
WHERE COALESCE(hu.year, huc.year) >= 2000;

-- CASE STUDY 5
--SELECT * from tutorial.crunchbase_acquisitions;

--1 Write a query that performs a left join between the tutorial.crunchbase_companies table and tutorial.crunchbase_acquisitions table. List the individual rows.
SELECT c.*, a.acquired_at, a.acquired_month, a.acquired_quarter, a.acquired_year, a.acquirer_name, a.price_amount, a.price_currency_code
FROM tutorial.crunchbase_companies AS c
LEFT JOIN tutorial.crunchbase_acquisitions AS a ON c.permalink = a.company_permalink;

--2 Count the number of unique companies (don't double-count companies) and unique acquired companies.
SELECT COUNT(DISTINCT permalink) AS unique_companies
FROM tutorial.crunchbase_companies;

SELECT COUNT(DISTINCT company_permalink) AS unique_acquired_companies
FROM tutorial.crunchbase_acquisitions;

--3 Write a query to give a count of number of companies which never acquired any company.
SELECT COUNT(c.permalink) AS companies_never_acquired
FROM tutorial.crunchbase_companies AS c
LEFT JOIN tutorial.crunchbase_acquisitions AS a ON c.permalink = a.acquirer_permalink
WHERE a.acquirer_permalink IS NULL;

--4 Count the number of unique companies (don't double-count companies) and unique acquired companies by state. Do not include results for which there is no state data, and order by the number of acquired companies from highest to lowest.
WITH CompanyCounts AS (
  SELECT state_code, COUNT(DISTINCT permalink) AS unique_companies_count FROM tutorial.crunchbase_companies WHERE state_code IS NOT NULL GROUP BY state_code
), AcquiredCompanyCounts AS (
  SELECT company_state_code AS state_code, COUNT(DISTINCT company_permalink) AS unique_acquired_companies_count FROM tutorial.crunchbase_acquisitions WHERE company_state_code IS NOT NULL GROUP BY company_state_code
)
SELECT COALESCE(cc.state_code, acc.state_code) AS state, COALESCE(cc.unique_companies_count, 0) AS number_of_unique_companies, COALESCE(acc.unique_acquired_companies_count, 0) AS number_of_unique_acquired_companies
FROM CompanyCounts AS cc
FULL OUTER JOIN AcquiredCompanyCounts AS acc ON cc.state_code = acc.state_code
WHERE COALESCE(cc.state_code, acc.state_code) IS NOT NULL
ORDER BY number_of_unique_acquired_companies DESC;

--5 Write a query that joins tutorial.crunchbase_companies and tutorial.crunchbase_investments_part1 using a FULL JOIN. Count up the number of rows that are present in one table and present in both the table.
SELECT
  COUNT(CASE WHEN c.permalink IS NOT NULL AND i.company_permalink IS NULL THEN 1 END) AS companies_only,
  COUNT(CASE WHEN c.permalink IS NULL AND i.company_permalink IS NOT NULL THEN 1 END) AS investments_only,
  COUNT(CASE WHEN c.permalink IS NOT NULL AND i.company_permalink IS NOT NULL THEN 1 END) AS companies_and_investments
FROM
  tutorial.crunchbase_companies AS c
FULL JOIN
  tutorial.crunchbase_investments_part1 AS i ON c.permalink = i.company_permalink;
  
--6 Write a query to find the records where a company received investment 5 year after founding year.
SELECT c.name, c.founded_year, CAST(SUBSTRING(i.funded_at, 1, 4) AS INTEGER) AS funded_year
FROM tutorial.crunchbase_companies AS c
JOIN tutorial.crunchbase_investments_part1 AS i ON c.permalink = i.company_permalink
WHERE i.funded_at LIKE '____-%' AND CAST(SUBSTRING(i.funded_at, 1, 4) AS INTEGER) = c.founded_year + 5;

-- CASE STUDY 6
-- SELECT * FROM tutorial.city_populations;

--1 In the tutorial.city_populations dataset, add a column which tells how many cities have less population than the city mentioned in the row.
SELECT cp1.city, cp1.state, cp1.population_estimate_2012, 
(SELECT COUNT(*) FROM tutorial.city_populations AS cp2 
WHERE cp2.population_estimate_2012 < cp1.population_estimate_2012) AS cities_with_less_population 
FROM tutorial.city_populations AS cp1 ORDER BY cp1.population_estimate_2012 DESC;

--2 In the tutorial.city_populations dataset, add a column which tells the rank of city in terms of population. City with highest population should get rank = 1.
SELECT city, state, population_estimate_2012, RANK() OVER (ORDER BY population_estimate_2012 DESC) AS population_rank 
FROM tutorial.city_populations 
ORDER BY population_estimate_2012 DESC;

--3 Write a query that counts the number of companies founded and acquired by quarter starting in Q1 2012. Create the aggregations in two separate queries, then join them. Use: tutorial.crunchbase_companies, tutorial.crunchbase_acquisitions tables.
WITH FoundedCompanies AS (
  SELECT
    CONCAT(founded_year, '-', founded_quarter) AS quarter_found,
    COUNT(id) AS companies_founded
  FROM tutorial.crunchbase_companies
  WHERE founded_year >= 2012
  GROUP BY 1
), AcquiredCompanies AS (
  SELECT
    CONCAT(acquired_year, '-', acquired_quarter) AS quarter_acquired,
    COUNT(id) AS companies_acquired
  FROM tutorial.crunchbase_acquisitions
  WHERE acquired_year >= 2012
  GROUP BY 1
)
SELECT
  COALESCE(fc.quarter_found, ac.quarter_acquired) AS quarter,
  COALESCE(fc.companies_founded, 0) AS total_companies_founded,
  COALESCE(ac.companies_acquired, 0) AS total_companies_acquired
FROM FoundedCompanies AS fc
FULL OUTER JOIN AcquiredCompanies AS ac ON fc.quarter_found = ac.quarter_acquired
ORDER BY quarter;

--4 Write a query that ranks investors from the combined dataset above by the total number of investments they have made. Use: tutorial.crunchbase_investments_part1, tutorial.crunchbase_investments_part2 tables.
WITH CombinedInvestments AS (
  SELECT investor_permalink, investor_name
  FROM tutorial.crunchbase_investments_part1
  UNION ALL
  SELECT investor_permalink, investor_name
  FROM tutorial.crunchbase_investments_part2
)
SELECT
  investor_name,
  COUNT(investor_permalink) AS total_investments,
  RANK() OVER (ORDER BY COUNT(investor_permalink) DESC) AS investor_rank
FROM CombinedInvestments
GROUP BY investor_permalink, investor_name
ORDER BY investor_rank ASC;

--5 Write a query that ranks investors from the combined dataset above by the total number of investments they have made. Consider only the companies whose status is operating. Use: tutorial.crunchbase_investments_part1, tutorial.crunchbase_investments_part2 tables for investment. Use: tutorial.crunchbase_companies for status. 
WITH AllInvestments AS (
  SELECT i1.investor_permalink, i1.investor_name, i1.company_permalink
  FROM tutorial.crunchbase_investments_part1 AS i1
  UNION ALL
  SELECT i2.investor_permalink, i2.investor_name, i2.company_permalink
  FROM tutorial.crunchbase_investments_part2 AS i2
), OperatingCompanyInvestments AS (
  SELECT ai.investor_permalink, ai.investor_name, COUNT(ai.investor_permalink) AS total_investments
  FROM AllInvestments AS ai
  JOIN tutorial.crunchbase_companies AS cc ON ai.company_permalink = cc.permalink
  WHERE cc.status = 'operating'
  GROUP BY ai.investor_permalink, ai.investor_name
)
SELECT
  investor_name,
  total_investments,
  RANK() OVER (ORDER BY total_investments DESC) AS investor_rank
FROM OperatingCompanyInvestments
ORDER BY investor_rank ASC;

-- CASE STUDY 7

--1 Write a query to return all the records where the city population is more than average population of dataset.
SELECT city, state, population_estimate_2012
FROM tutorial.city_populations
WHERE population_estimate_2012 > (SELECT AVG(population_estimate_2012) FROM tutorial.city_populations);

--2 Write a query to return all the records where the city population is more than the most populated city of Texas(TX) state. 
SELECT city, state, population_estimate_2012
FROM tutorial.city_populations
WHERE population_estimate_2012 > (SELECT MAX(population_estimate_2012) FROM tutorial.city_populations WHERE state = 'TX');

--3 Find the number of cities where population is more than the average population of Illinois(IL) state.
SELECT COUNT(city) AS num_cities_above_il_avg
FROM tutorial.city_populations
WHERE population_estimate_2012 > (SELECT AVG(population_estimate_2012) FROM tutorial.city_populations WHERE state = 'IL');

--4 Write a query to add the additional column - percentage_population(city population/total population of dataset). 
SELECT city, state, population_estimate_2012, (population_estimate_2012 * 100.0 / (SELECT SUM(population_estimate_2012) FROM tutorial.city_populations)) AS percentage_population
FROM tutorial.city_populations
ORDER BY population_estimate_2012 DESC;

--5 Write a query to add the additional column - population density. The column logic is: 
--Population more than average - High 
--Population less than or equal to average – Low
SELECT
  city,
  state,
  population_estimate_2012,
  (population_estimate_2012 * 100.0 / (SELECT SUM(population_estimate_2012) FROM tutorial.city_populations)) AS percentage_population,
  CASE
    WHEN population_estimate_2012 > (SELECT AVG(population_estimate_2012) FROM tutorial.city_populations) THEN 'High'
    ELSE 'Low'
  END AS population_density
FROM tutorial.city_populations
ORDER BY population_estimate_2012 DESC;

--6 Write a query to add the additional column - percentage_population(city population/total population of dataset).
SELECT city, state, population_estimate_2012, (population_estimate_2012 * 100.0 / (SELECT SUM(population_estimate_2012) FROM tutorial.city_populations)) AS percentage_population
FROM tutorial.city_populations
ORDER BY population_estimate_2012 DESC;

-- CASE STUDY 8
--SELECT * FROM  tutorial.oscar_nominees;

--1 Write a query to return the name of nominees who got more nominations than ‘Akim Tamiroff’. Solve this using CTE. 
WITH NomineeNominations AS (
  SELECT
    nominee,
    COUNT(id) AS total_nominations
  FROM tutorial.oscar_nominees
  GROUP BY nominee
), AkimNominations AS (
  SELECT total_nominations
  FROM NomineeNominations
  WHERE nominee = 'Akim Tamiroff'
)
SELECT
  nn.nominee,
  nn.total_nominations
FROM NomineeNominations AS nn
WHERE nn.total_nominations > (SELECT total_nominations FROM AkimNominations)
ORDER BY nn.total_nominations DESC;

--2 Write a query to find the nominee name with the second highest number of oscar wins. Solve using subquery.
SELECT nominee, total_wins
FROM (
  SELECT nominee, COUNT(id) AS total_wins, DENSE_RANK() OVER (ORDER BY COUNT(id) DESC) AS rank_num
  FROM tutorial.oscar_nominees
  WHERE winner = TRUE
  GROUP BY nominee
) AS ranked_nominees
WHERE rank_num = 2;

--3 Write a query to create three columns per nominee: a) no. of wins, b) no. of loss, c) total nomination.
SELECT nominee,
  COUNT(CASE WHEN winner = TRUE THEN id END) AS no_of_wins,
  COUNT(CASE WHEN winner = FALSE THEN id END) AS no_of_losses,
  COUNT(id) AS total_nominations
FROM tutorial.oscar_nominees
GROUP BY nominee
ORDER BY total_nominations DESC, no_of_wins DESC;

--4 Write a query to create two columns: a) Win_rate: Number of wins/total wins, b) Loss_rate: Number of loss/total wins.
SELECT nominee,
  COUNT(CASE WHEN winner = TRUE THEN id END) AS no_of_wins,
  COUNT(CASE WHEN winner = FALSE THEN id END) AS no_of_losses,
  COUNT(id) AS total_nominations,
  
  CAST(COUNT(CASE WHEN winner = TRUE THEN id END) AS REAL) / NULLIF(COUNT(id), 0) AS win_rate,
  
  CAST(COUNT(CASE WHEN winner = FALSE THEN id END) AS REAL) / NULLIF(COUNT(id), 0) AS loss_rate
FROM tutorial.oscar_nominees
GROUP BY nominee
ORDER BY total_nominations DESC, no_of_wins DESC;

--5 Write a query to return all the records of the nominees who have lost but won at least once.
WITH NomineesWithWinsAndLosses AS (
  SELECT nominee
  FROM tutorial.oscar_nominees
  GROUP BY nominee
  HAVING
    SUM(CASE WHEN winner = TRUE THEN 1 ELSE 0 END) >= 1 AND
    SUM(CASE WHEN winner = FALSE THEN 1 ELSE 0 END) >= 1
)
SELECT o.*
FROM tutorial.oscar_nominees AS o
JOIN NomineesWithWinsAndLosses AS nwl ON o.nominee = nwl.nominee
ORDER BY o.nominee, o.year, o.category;

--6 Write a query to find the nominees who are nominated for both ‘actor in a leading role’ and ‘actor in supporting role’. 
SELECT nominee
FROM tutorial.oscar_nominees
WHERE category IN ('actor in a leading role', 'actor in a supporting role')
GROUP BY nominee
HAVING COUNT(DISTINCT category) = 2;

--7 Write a query to find the movie which won more than average number of wins per winning movie. 
WITH MovieWins AS (
  SELECT movie,
    COUNT(id) AS total_wins
  FROM tutorial.oscar_nominees
  WHERE winner = TRUE
  GROUP BY movie
),
AverageWins AS (
  SELECT AVG(total_wins) AS avg_wins_per_movie
  FROM MovieWins
)
SELECT
  mw.movie,
  mw.total_wins
FROM MovieWins AS mw
WHERE mw.total_wins > (SELECT avg_wins_per_movie FROM AverageWins)
ORDER BY mw.total_wins DESC;

--8 Write a query to return the year which have more winners than year 1970.
WITH YearWinners AS (
  SELECT year,
    COUNT(id) AS total_winners
  FROM tutorial.oscar_nominees
  WHERE winner = TRUE
  GROUP BY year
),
Winners1970 AS (
  SELECT total_winners
  FROM YearWinners
  WHERE year = 1970
)
SELECT yw.year, yw.total_winners
FROM YearWinners AS yw
WHERE yw.total_winners > (SELECT total_winners FROM Winners1970)
ORDER BY yw.total_winners DESC;

--9 Write a query to return all the movies which have won oscars both in the actor and actress category. 
SELECT movie
FROM tutorial.oscar_nominees
WHERE winner = TRUE
GROUP BY movie
HAVING
  MAX(CASE WHEN category IN ('actor in a leading role', 'actor in supporting role') THEN 1 ELSE 0 END) = 1
  AND
  MAX(CASE WHEN category IN ('actress in a leading role', 'actress in a supporting role') THEN 1 ELSE 0 END) = 1;
  
--10 Write a query to return the movie name which did not win a single oscar.
SELECT movie
FROM tutorial.oscar_nominees
GROUP BY movie
HAVING SUM(CASE WHEN winner = TRUE THEN 1 ELSE 0 END) = 0
ORDER BY movie;

-- CASE STUDY 9
--SELECT * from tutorial.patient_list;

--1 Add two additional column in the dataset: ‘Age_category’ ○ old_age: >60 ○ mid_age: 30-60 ○ young: < 30 Bmi: 703*weight (lbs) /height (inches)^2
SELECT *, CASE WHEN age > 60 THEN 'old_age' WHEN age >= 30 AND age <= 60 THEN 'mid_age' WHEN age < 30 THEN 'young' END AS Age_category, 703 * weight_lbs / POWER(height_inches, 2) AS Bmi
FROM tutorial.patient_list;

--2 Find the physician last_name who treats maximum mid_age patients.
SELECT physician_last_name
FROM tutorial.patient_list
WHERE age >= 30 AND age <= 60
GROUP BY physician_last_name
ORDER BY COUNT(patient_id) DESC
LIMIT 1;

--3 Write a query to return the following for each category: Average age, Max height, Min weight Number of patients
SELECT
  CASE
    WHEN age > 60 THEN 'old_age'
    WHEN age >= 30 AND age <= 60 THEN 'mid_age'
    WHEN age < 30 THEN 'young'
    ELSE 'UNIQUE'
  END AS Age_category,
  AVG(age) AS average_age,
  MAX(height_inches) AS max_height,
  MIN(weight_lbs) AS min_weight,
  COUNT(patient_id) AS number_of_patients
FROM tutorial.patient_list
GROUP BY Age_category
ORDER BY Age_category;

--5 List all the records where bmi is less than average bmi. Solve using CTE. 
WITH PatientBMI AS (
  SELECT *, 703 * weight_lbs / POWER(height_inches, 2) AS bmi
  FROM tutorial.patient_list
)
SELECT *
FROM PatientBMI
WHERE bmi < (SELECT AVG(bmi) FROM PatientBMI);

-- CASE STUDY 10
--SELECT * FROM tutorial.sales_performance;
--1 Write a query to return all the records where sales_revenue is less than the average sales_revenue made by salesperson whose name starts with T. Output should not contain the records of salesperson whose name starts with T. 
SELECT *
FROM tutorial.sales_performance
WHERE sales_revenue < (
    SELECT AVG(sales_revenue)
    FROM tutorial.sales_performance
    WHERE salesperson LIKE 'T%'
)
AND salesperson NOT LIKE 'T%';

--SELECT * FROM tutorial.playbook_users;

--1 What percentage of users are in ‘pending’ state?
SELECT CAST(SUM(CASE WHEN state = 'pending' THEN 1 ELSE 0 END) AS REAL) * 100 / COUNT(user_id) AS percentage_pending 
FROM tutorial.playbook_users;

--2 Find the language with the maximum ‘active’ state percentage.
SELECT language, CAST(SUM(CASE WHEN state = 'active' THEN 1 ELSE 0 END) AS REAL) * 100 / COUNT(user_id) AS active_percentage 
FROM tutorial.playbook_users 
GROUP BY language
ORDER BY active_percentage DESC 
LIMIT 1;

--3 Find the percentage of user(out of total dataset) per company. 
SELECT company_id,
  CAST(COUNT(user_id) AS REAL) * 100 / (SELECT COUNT(user_id) FROM tutorial.playbook_users) AS user_percentage
FROM tutorial.playbook_users
GROUP BY company_id
ORDER BY user_percentage DESC;
