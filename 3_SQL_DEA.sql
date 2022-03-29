SELECT * FROM games_scores
LIMIT 10;

-- How many games are there?
SELECT DISTINCT COUNT(name) FROM games_scores;

-- How many games have been released by year? Which is the first game recorded in our dataset?
SELECT  release_date, COUNT(DISTINCT(name)) 
FROM games_scores
GROUP BY release_date;

SELECT name FROM games_scores
WHERE release_date = 1995;

-- How many games have been released by platform?
SELECT platform, COUNT(name)
FROM games_scores
GROUP BY platform
ORDER BY COUNT(name) DESC;


-- How many games were released by plaform every year?
SELECT release_date, platform, COUNT(name)
FROM games_scores
GROUP BY release_date, platform
ORDER BY release_date, COUNT(DISTINCT(name)) DESC;

-- Perfect. Now, how many unique games are there for PlayStation consoles?
SELECT COUNT(name), platform FROM games_scores 
WHERE name IN
	(SELECT name FROM games_scores
	GROUP BY name
	HAVING COUNT(name) = 1)
AND platform LIKE 'PlayStation%'
GROUP BY platform;


-- There is a Playstation 4 release in 1999. Let's investigate.
SELECT name FROM games_scores
WHERE release_date = 1999 AND platform = 'PlayStation 4';

-- It's Jeremy McGrath Supercross. Let's see in which other platforms it was released.
SELECT name, platform, release_date FROM games_scores
WHERE name LIKE '%McGrath%';

-- Ok, according to Wikipedia, the PlayStation version was released in 2000. Let's fix the platform's name and release date.
UPDATE games_scores
SET platform = 'PlayStation',
	release_date = 2000
WHERE name = 'Jeremy McGrath Supercross 2000';

-- In which year have we seen the highest number of releases?
SELECT release_date, COUNT(*) AS num_games
FROM games_scores
GROUP BY release_date
ORDER BY num_games DESC;

-- What is the highest number of releases sorted by year and consoles?
SELECT release_date, platform, COUNT(*) AS num_games
FROM games_scores
GROUP BY release_date, platform
ORDER BY num_games DESC;

SELECT release_date, platform, COUNT(*) AS num_games
FROM games_scores
GROUP BY release_date, platform
ORDER BY release_date ASC, num_games DESC;

-- There is a PlayStation 2 game dated as from 1998, while this console was released in 2000. 
-- Let's check this data and figure out which game is it and whether it was really a PlayStation game.
SELECT name FROM games_scores
WHERE platform = 'PlayStation 2'
AND release_date = 1998;

-- Ok, the game is "The X-Files Game" and it was released for pc, and PlayStation. 
-- Let's rename the value and see if there are other issues with other platforms with this game.
UPDATE games_scores
SET platform = 'PlayStation',
	release_date = 2000
WHERE name = 'The X-Files Game';

SELECT name, platform FROM games_scores
WHERE name = 'The X-Files Game';

-- Let's look at some scores now.
SELECT * FROM games_scores
LIMIT 20;

--		META_SCORE    --
-- 1. What is the highest, lowest, average, standard deviation, and variance of the meta score?
SELECT  
	MAX(meta_score),
	MIN(meta_score),
	ROUND(AVG(meta_score),2) as average,
	ROUND(STDDEV(meta_score),2) as std_dev,
	ROUND(VARIANCE(meta_score),2) as variance
FROM games_scores;

--2. Which games and in which consoles had a maximum meta score?
SELECT name, platform
FROM games_scores
WHERE meta_score = 99

--3. And how about the minimum scored ones?
SELECT name, platform
FROM games_scores
WHERE meta_score = 20;

--4. Considering now that the average meta score is 71.20, let's find out first how many games per platform scored above the average yearly.
SELECT COUNT(*), release_date, platform
FROM games_scores
WHERE meta_score >= 71.20
GROUP BY release_date, platform
ORDER BY release_date, COUNT(*) DESC;

-- And what is the average meta score by each individual console?
SELECT COUNT(*), platform, ROUND(AVG(meta_score),2) AS avg_score FROM games_scores
GROUP BY platform;

-- Considering the number of releases, the PlayStation franchise has received solid scores. 
-- If we could sum all of them and count as one console, what average score would we get?
SELECT COUNT(*) , ROUND(AVG(meta_score),2) AS avg_score FROM games_scores
WHERE platform LIKE 'PlayStation%' 
OR platform LIKE 'PSP';

-- Aha. So, considering all PlayStation consoles, we get an all-time average meta score of 70.90, which is pretty high.
-- USER REVIEW --
-- Let's take a look at user_review scores before comparing it with meta score.
--1. What is the highest, lowest, average, standard deviation, and variance of the user review score?
--  First, let's convert user review to an integer so that we can later on compare it with the meta score.
ALTER TABLE games_scores
	ALTER COLUMN user_review TYPE bigint
	USING games_scores.user_review * 10;
	
SELECT 
	MAX(user_review),
	MIN(user_review),
	ROUND(AVG(user_review),2) as average,
	ROUND(STDDEV(user_review),2) as std_dev,
	ROUND(VARIANCE(user_review),2) as variance
FROM games_scores;

--2. Which games and in which consoles had a maximum user review?
SELECT name, platform, user_review
FROM games_scores
WHERE user_review >= 97;

--3. And how about the bottom rated?
SELECT name, platform
FROM games_scores
WHERE user_review = 2;

--4. Considering now that the average user_review is 69.91, let's find out first how many games per platform scored above the average yearly.
SELECT release_date, COUNT(*), platform
FROM games_scores
WHERE user_review >= 69.91
GROUP BY release_date, platform
ORDER BY release_date;

-- Hm, a PlayStation Vita game in 2000? I don't think so. Let's fix it.
SELECT name FROM games_scores
WHERE platform LIKE '%Vita' AND release_date = 2000
UPDATE games_scores
SET platform = 'PlayStation',
	release_date = 2000
WHERE name = 'Evil Dead: Hail to the King' AND platform LIKE '%Vita';



SELECT name, platform, release_date 
FROM games_scores
WHERE release_date BETWEEN 2000 AND 2008 
AND platform LIKE 'PlayStation%'
GROUP BY name, platform, release_date
ORDER BY release_date



UPDATE games_scores
SET platform = 'Nintendo 64',
	release_date = 2000
WHERE name LIKE '%Exotica' AND platform LIKE 'PlayStation%';

SELECT * FROM games_scores
LIMIT 20

-- 5. How have users rated PlayStation games?
SELECT COUNT(*), ROUND(AVG(user_review)), platform
FROM games_scores
WHERE platform LIKE 'PlayStation%' --AND platform LIKE 'PSP'
GROUP BY platform
ORDER BY platform;

-- It seems that scores have lowered as new PS consoles were released. PlayStation has a much smaller sample, yet the 3 following generations have similar game releases.
-- Has this score changed through the years?
SELECT COUNT(*), release_date, ROUND(AVG(user_review)) AS avg_score, platform
FROM games_scores
WHERE platform LIKE 'PlayStation%'
GROUP BY platform, release_date
ORDER BY release_date;

SELECT name, platform, release_date, meta_score
FROM games_scores
WHERE meta_score > 
	(SELECT ROUND(AVG(meta_score),2)
	FROM games_scores)
	AND platform LIKE 'PlayStation%'
GROUP BY 1, 2, 3, 4
ORDER BY release_date, meta_score DESC;

-- 6. Let's now see which games have performed above the average in both score methods.

SELECT name, platform, release_date, meta_score, user_review
FROM games_scores
WHERE meta_score > 
	(SELECT ROUND(AVG(meta_score),2)
	FROM games_scores)
AND user_review >
	(SELECT ROUND(AVG(user_review),2)
	FROM games_scores)	
AND platform LIKE 'PlayStation%'
GROUP BY 1, 2, 3, 4, 5
ORDER BY release_date DESC, meta_score DESC;

-- 7. Now, let's add another column containing the average score obtained from the two scores.
ALTER TABLE games_scores
ADD COLUMN avg_meta_user NUMERIC;

UPDATE games_scores
SET avg_meta_user = (meta_score + user_review)/ 2

SELECT * FROM games_scores
ORDER BY avg_meta_user DESC
LIMIT 100

-- Cool, now we can see top performing games according to two different classifications!
-- It's time to take a look at our ratings table.
SELECT * FROM games_ratings
LIMIT 100;

-- Let's first count the number of games according to the esrb rating.
-- Consider that:
-- 		E: Everyone
--		T: Teen, suitable for ages 13 and up.
--		M: Mature, suitable for ages 17 and older.
SELECT COUNT(*), esrb_rating
FROM games_ratings
GROUP BY esrb_rating;

-- What is "ET", though? Let's see which games are rated as such.
SELECT title, esrb_rating
FROM games_ratings
WHERE esrb_rating = 'ET';

-- Ok, after a quick research on the esrb website, these games are rated as 'E10+', which basically means everyone that is older than 10.
-- Let's rename this category so that it reflects the proper nomenclature.
UPDATE games_ratings
SET esrb_rating = 'E10+'
WHERE esrb_rating = 'ET';

SELECT title, esrb_rating
FROM games_ratings
WHERE esrb_rating = 'E10+';

-- Nice! Let's take a look at the dataset and explore it a bit further now.
SELECT * FROM games_ratings
LIMIT 100;

-- Ok, now, the next challenge is to figure out which platform is '1' and which is '0' in the 'console' column. Let's do that before joining both tables.
SELECT title FROM games_ratings
WHERE console = 0
AND title LIKE 'Final Fantasy%';

-- Ok, we know that '1' does NOT stand for PlayStation games, as its unique releases are associated with '0'. God of War and Final Fantasy games, for instance, are found when conditioning the 'console' column as '0'.
-- Let's take a look at the different ratings by making several queries:

-- 1. To be a E-rated game, what are the contents that it must not display? Let's see E-rated games and their content.
-- First, there's a typo. The column 'strong_janguage' was an obvious mistake. Let's fix it.
ALTER TABLE games_ratings
RENAME COLUMN strong_janguage TO strong_language;

SELECT COUNT(*) FROM games_ratings
WHERE esrb_rating = 'E'
	AND alcohol_reference = 0
	AND animated_blood = 0
	AND blood = 0
	AND blood_and_gore = 0
	AND cartoon_violence = 0
	AND crude_humor = 0
	AND drug_reference = 0
	AND fantasy_violence = 0
	AND intense_violence = 0
	AND language = 0
	AND lyrics = 0
	AND mature_humor = 0
	AND mild_blood = 0
	AND mild_cartoon_violence = 0
	AND mild_fantasy_violence = 0
	AND mild_language = 0
	AND mild_lyrics = 0
	AND mild_suggestive_themes = 0
	AND mild_violence = 0
	AND nudity = 0
	AND partial_nudity = 0
	AND sexual_content = 0
	AND sexual_themes = 0
	AND simulated_gambling = 0
	AND strong_language = 0
	AND strong_sexual_content = 0
	AND suggestive_themes = 0
	AND use_of_alcohol = 0
	AND use_of_drugs_and_alcohol = 0
	AND violence = 0
-- There are 273 games in which no descriptor was found. These games are 100% E-rated. But are all the 'E' category games included in these 273 games? Let's see.

SELECT COUNT(*) FROM games_ratings
WHERE esrb_rating = 'E';

-- There's a total number of 416 E-rated games,.
-- Find out how to find the difference between both, divided by the total and multiplied by 100. We should get the percentage of games that are have some content restriction.
SELECT  DISTINCT(
	CAST((SELECT COUNT(*) FROM games_ratings
	WHERE esrb_rating = 'E'
		AND alcohol_reference = 0
		AND animated_blood = 0
		AND blood = 0
		AND blood_and_gore = 0
		AND cartoon_violence = 0
		AND crude_humor = 0
		AND drug_reference = 0
		AND fantasy_violence = 0
		AND intense_violence = 0
		AND language = 0
		AND lyrics = 0
		AND mature_humor = 0
		AND mild_blood = 0
		AND mild_cartoon_violence = 0
		AND mild_fantasy_violence = 0
		AND mild_language = 0
		AND mild_lyrics = 0
		AND mild_suggestive_themes = 0
		AND mild_violence = 0
		AND nudity = 0
		AND partial_nudity = 0
		AND sexual_content = 0
		AND sexual_themes = 0
		AND simulated_gambling = 0
		AND strong_language = 0
		AND strong_sexual_content = 0
		AND suggestive_themes = 0
		AND use_of_alcohol = 0
		AND use_of_drugs_and_alcohol = 0
		AND violence = 0) AS FLOAT)  / 
	CAST((SELECT COUNT(*) FROM games_ratings
	WHERE esrb_rating = 'E') AS FLOAT) * 100)
FROM games_ratings;

-- Awesome! That was difficult, but we've managed to get the figure: 65.62% of E-rated games have no restriction whatsoever.

SELECT console, COUNT(console), esrb_rating FROM games_ratings
GROUP BY console, esrb_rating
ORDER BY console, esrb_rating


-- What is the percentage of each esrb rating for PlayStation games when compared to other platforms?
SELECT console, esrb_rating, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),2) AS "rating_percentage"
FROM games_ratings
GROUP BY console, esrb_rating
ORDER BY console, esrb_rating

-- As we can see, PlayStation games concentrate their audience in the middle - almost 20 percent of its games are T-rated, while E and M ratings come last.

-- Now, let's take a look at the content of each game and see what we can get out of it.
SELECT * FROM games_ratings
LIMIT 10;

-- Let's join both tables now and compare scores and ratings. Let's order them first by meta score.

SELECT games_ratings.title, games_scores.meta_score, games_ratings.esrb_rating FROM games_ratings
INNER JOIN games_scores
	ON games_ratings.title = games_scores.name
ORDER BY meta_score DESC;

-- Mature-rated games seem to be on top. Let's check the number of games per category that have scored above average (69.91).

SELECT 
	COUNT(games_ratings.esrb_rating) AS count_by_ratings, 
	games_ratings.esrb_rating 
FROM games_ratings
INNER JOIN games_scores
	ON games_ratings.title = games_scores.name
WHERE games_scores.meta_score > 69.91
GROUP BY games_ratings.esrb_rating;


SELECT 
	MAX(user_review),
	MIN(user_review),
	ROUND(AVG(user_review),2) as average,
	ROUND(STDDEV(user_review),2) as std_dev,
	ROUND(VARIANCE(user_review),2) as variance
FROM games_scores;
