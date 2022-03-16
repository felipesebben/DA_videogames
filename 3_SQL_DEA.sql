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






