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

-- Perfect. Now, how many unique games are there for PlayStation consoles?
SELECT DISTINCT(name), platform, release_date
FROM games_scores
WHERE name NOT IN (
						'Xbox One',
						'Xbox',
						'Switch',
						'Xbox Series X',
						'Dreamcast',
						'Nintendo 64',
						'Stadia',
						'Wii U',
						'Xbox 360',
						'3DS',
						'Wii',
						'Game Boy Advance',
						'GameCube',
						'DS',
						'PC')
GROUP BY platform, release_date, name
ORDER BY release_date, platform;

SELECT name, platform FROM games_scores
WHERE name LIKE 'Star Wars Battlefront II'

SELECT DISTINCT(platform) FROM games_scores


SELECT name, platform FROM games_scores
WHERE name LIKE 'Reign of Fire';

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





