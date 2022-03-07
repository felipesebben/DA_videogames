-- 1. Which games have the best meta scores? 
SELECT * FROM scores
ORDER BY meta_score DESC;

-- a. And ordered by year?
SELECT  * FROM scores
ORDER BY release_date DESC, meta_score DESC;

-- Which ones hold the best user reviews?
SELECT * FROM scores
ORDER BY user_review DESC;

-- a. And ordered by year?
SELECT  * FROM scores
ORDER BY release_date DESC, user_review DESC;

-- How many games are there per platform?
SELECT platform, COUNT(*) FROM scores
GROUP BY platform
ORDER BY COUNT(*) DESC;