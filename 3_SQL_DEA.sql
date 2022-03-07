SELECT * FROM games_scores
LIMIT 10;

-- How many games are there?
SELECT DISTINCT COUNT(name) FROM games_scores;

-- How many games were released by year?
SELECT  release_date, COUNT(DISTINCT(name)) 
FROM games_scores
GROUP BY release_date;

SELECT name FROM games_scores
WHERE release_date = 1995;

-- How many games were released by platform?
SELECT platform, COUNT(name)
FROM games_scores
GROUP BY platform
ORDER BY COUNT(name) DESC;

-- How many unique games per platform were released?
SELECT platform, COUNT(DISTINCT(name))
FROM games_scores
GROUP BY platform
ORDER BY COUNT(DISTINCT(name)) DESC;

-- How many unique games were released by plaform every year?
SELECT release_date, platform, COUNT(DISTINCT(name))
FROM games_scores
GROUP BY release_date, platform
ORDER BY release_date ASC, COUNT(DISTINCT(name)) DESC;

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
SELECT release_date, count(*) AS num_games
FROM games_scores
GROUP BY release_date
ORDER BY num_games DESC;


