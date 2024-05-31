USE bikes;
-- ALTER TABLE rental_df RENAME TO rental;
-- ALTER TABLE season_df RENAME TO season;
-- ALTER TABLE weather_df RENAME TO weather;

SHOW TABLES;

-- Count the number of casual riders from bike share
SELECT COUNT(DISTINCT date_hour) AS cas_rider
FROM rental;

-- Count the number of registered riders from bike share
SELECT COUNT(DISTINCT date_hour) AS registered_rider
FROM rental;

-- Count the total number of riders from bike share
SELECT COUNT(DISTINCT date_hour) AS total_rider
FROM rental;

-- Calculate the maximun of users by season
-- SELECT MAX(total_users) AS max_total_users
-- FROM rental;
-- SELECT max_total_users GROUP BY season FROM season;

-- Calculate the total users by season and year
SELECT r.total_users, s.weekday, s.holiday, s.season, s.year FROM bikes.rental AS r
JOIN bikes.season AS s
ON r.date_hour = s.date_hour;

-- 
SELECT year, season, sum(total_users) as total_users FROM 
(SELECT r.total_users, s.weekday, s.holiday, s.season, s.year FROM bikes.rental AS r
JOIN bikes.season AS s
ON r.date_hour = s.date_hour) as s
GROUP BY year, season
ORDER BY year;

-- Table illustrating total, registered, casual users by season and year 
SELECT year, season, 
       SUM(registered) AS total_registered_users, 
       SUM(casual) AS total_casual_users,
       SUM(registered) + SUM(casual) AS total_users
FROM 
    (SELECT r.total_users, s.weekday, s.holiday, s.season, s.year, r.registered, r.casual 
     FROM bikes.rental AS r
     JOIN bikes.season AS s
     ON r.date_hour = s.date_hour) AS s
GROUP BY year, season
ORDER BY year, season;

-- Table illustrating total, registered, casual users by month and year 
SELECT year, mnth, 
       SUM(registered) AS total_registered_users, 
       SUM(casual) AS total_casual_users,
       SUM(registered) + SUM(casual) AS total_users
FROM 
    (SELECT r.total_users, s.weekday, s.holiday, s.season, s.year, r.registered, r.casual, s.mnth
     FROM bikes.rental AS r
     JOIN bikes.season AS s
     ON r.date_hour = s.date_hour) AS s
GROUP BY year, mnth
ORDER BY year, mnth;

-- Average Registered and Casual per season 
WITH total_users_per_season_per_year AS (
    SELECT 
        s.season,
        s.year,
        SUM(r.registered) AS total_registered_per_season_per_year,
        SUM(r.casual) AS total_casual_per_season_per_year
    FROM 
        rental r
    JOIN 
        season s ON r.date_hour = s.date_hour
    GROUP BY 
        s.season, s.year
)
SELECT 
    season,
    year,
    total_registered_per_season_per_year,
    total_casual_per_season_per_year,
    AVG(total_registered_per_season_per_year) OVER (PARTITION BY season) AS average_registered_per_season,
    AVG(total_casual_per_season_per_year) OVER (PARTITION BY season) AS average_casual_per_season
FROM 
    total_users_per_season_per_year
ORDER BY 
    season, year;
    

-- Average total users per season 
SELECT 
    YEAR(r.date_hour) AS yr,
    MONTH(r.date_hour) AS mnth,
    AVG(r.total_users) AS average_total_users
FROM 
    rental r
GROUP BY 
    YEAR(r.date_hour), MONTH(r.date_hour)
ORDER BY 
    yr, mnth;