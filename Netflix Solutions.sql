SELECT COUNT  (*) as total_content FROM netflix;

SELECT *  FROM netflix; 

SELECT DISTINCT TYPE FROM netflix;

-- count the number of movies vs shows --

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;

-- List all movies released ina specifice year (2020)--

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND
	release_year = 2020;

--Find the top 5 countries with the most content on Netflix--

SELECT 
	UNNEST (STRING_TO_ARRAY (country,',')) AS New_Country,
	COUNT (show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Identify the longest movie --

SELECT * FROM netflix
WHERE 
	type = 'Movie'
	AND 
	duration = (SELECT MAX (duration) FROM netflix)


-- Find the content added in the last 5 years --

SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

-- Find all the movie/TV shows by director 'Rajiv Chilaka'--

SELECT *
FROM
(
SELECT 
	*,
	UNNEST (STRING_TO_ARRAY(director,',')) AS DIRECTOR_NAME
FROM netflix
)
WHERE 
	DIRECTOR_NAME = 'Rajiv Chilaka'

-- List all seasons more than 5 seasons --

SELECT * FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5

--Count the number of items in each genre --

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1

-- List all movies that are documentaries --

SELECT *FROM netflix
WHERE listed_in LIKE 'Documentaries'

--Find the content without a director --

SELECT * FROM netflix
WHERE director is NULL


-- Find how many movies actor Salmon Khan appeared in last 10 years --

SELECT * FROM netflix
WHERE
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT (YEAR FROM CURRENT_DATE) - 10

-- Find the top 10 actors who have appeared in the highest number of movies produced in India --

SELECT 
	UNNEST(STRING_TO_ARRAY(casts,',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

-- Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords --

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;

--  Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India --

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;