-- Exploratory data analysis of my sportify streaming data 
SELECT * 
FROM streaming_history.my_sportify_streaming_audio_2023;

-- Verifying if dataset was uploaded correctly
SELECT COUNT(*)
FROM streaming_history.my_sportify_streaming_audio_2023;

-- Aggregating essential columns by generating a new table derived from the pre existing dataset 
CREATE TABLE streaming_history AS
	SELECT 
	ts, 
    platform, 
    ms_played, 
    master_metadata_track_name,
    master_metadata_album_artist_name,
    master_metadata_album_album_name,
    reason_start,
    reason_end,
    shuffle,
    skipped
FROM streaming_history.my_sportify_streaming_audio_2023;

-- Verifying new table 
SELECT *
FROM streaming_history.streaming_history;

-- Dropping redundant datasets
DROP TABLE my_sportify_streaming_audio_2023;

--  Reanaming table 
RENAME TABLE streaming_history TO sportify_history_2023;

SELECT *
FROM streaming_history.sportify_history_2023;

-- 'msplayed' is in miliseconds and needs to be converted to minutes 
-- Adding a new column as minutes played
ALTER TABLE sportify_history_2023
	ADD min_played DECIMAL (5,2)
AFTER platform;

-- Updating min_played column 
UPDATE sportify_history_2023
SET min_played = ms_played / (1000 * 60);

-- Dropping ms_played column as it is now redundant 
ALTER TABLE sportify_history_2023
DROP COLUMN ms_played;

-- Verifying changes 
SELECT *
FROM streaming_history.sportify_history_2023;

-- Adding new columns 'date' and 'time'
ALTER TABLE sportify_history_2023
ADD date_played date
AFTER ts;
ALTER TABLE sportify_history_2023
ADD time_played time
AFTER ts;

-- Converting data format for 'ts' from a text data format into one that can be recognized by MySQL
ALTER TABLE sportify_history_2023
ADD TS_NEW TIMESTAMP
AFTER ts;

-- Updating TS with the converted values by converting the datatype from str to datetime
UPDATE sportify_history_2023
SET TS_NEW = STR_TO_DATE(ts, '%Y-%m-%dT%H:%i:%sZ');

-- Updating new columns with values from timestamp column
UPDATE sportify_history_2023
SET 
	date_played = DATE(TS_NEW),
	time_played = TIME(TS_NEW);
    
-- Verifying changes
SELECT *
FROM streaming_history.sportify_history_2023;

-- Dropping redundant 'ts' column 
ALTER TABLE sportify_history_2023
DROP COLUMN ts;

-- Renaming columns for better readability and understanding 
ALTER TABLE sportify_history_2023
RENAME COLUMN master_metadata_track_name TO track_name,
RENAME COLUMN master_metadata_album_artist_name TO artist_name,
RENAME COLUMN master_metadata_album_album_name TO album_name;

-- Verifying changes
SELECT *
FROM streaming_history.sportify_history_2023;

-- Remove blanks or NULL values 
DELETE FROM sportify_history_2023
WHERE track_name IS NULL OR 
	TRIM(track_name) = '';

-- Exploratory analysis of my streaming history

-- Total number of unique songs streamed
SELECT COUNT(DISTINCT (track_name)) AS Total_unique_songs
FROM streaming_history.sportify_history_2023;

-- Total number of songs streamed
SELECT COUNT(track_name) AS Total_songs
FROM streaming_history.sportify_history_2023;

-- Favorite track
SELECT track_name,
SUM(min_played) AS total_play_minutes
FROM streaming_history.sportify_history_2023
GROUP BY track_name
ORDER BY total_play_minutes DESC
LIMIT 1;

-- Top 10 songs streamed by number of minutes played
SELECT track_name,
SUM(min_played) AS total_minutes_played
FROM streaming_history.sportify_history_2023
GROUP BY track_name
ORDER BY total_minutes_played DESC
LIMIT 10;

-- Total number of artists listened to
SELECT COUNT(artist_name) AS Total_artists
FROM streaming_history.sportify_history_2023;

-- Total unique artists streamed
SELECT COUNT(DISTINCT(artist_name)) AS Unique_artists
FROM streaming_history.sportify_history_2023;

-- Favorite artist by number of minutes their song was played
SELECT artist_name,
SUM(min_played) AS total_play_minutes
FROM streaming_history.sportify_history_2023
GROUP  BY artist_name
ORDER BY total_play_minutes DESC
Limit 1;

-- Top 10 most streamed artsts 
SELECT artist_name,
SUM(min_played) AS total_minutes_played
FROM streaming_history.sportify_history_2023
GROUP  BY artist_name
ORDER BY total_minutes_played DESC
Limit 10;

-- Top 10 artists whose songs I streamed completely the most times 
SELECT artist_name,
COUNT(*) AS track_done_freq
FROM streaming_history.sportify_history_2023
WHERE reason_end =  'trackdone'
GROUP BY artist_name
ORDER BY track_done_freq DESC
Limit 10;

-- Most streamed album
SELECT album_name,
SUM(min_played) AS total_minutes_played
FROM streaming_history.sportify_history_2023
GROUP BY album_name
ORDER BY total_minutes_played DESC
Limit 1;

-- Top 10 most streamed albums 
SELECT album_name,
SUM(min_played) AS total_minutes_played
FROM streaming_history.sportify_history_2023
GROUP BY album_name
ORDER BY total_minutes_played DESC 
Limit 10;

-- 10 top tracks I streamed completely the most time
SELECT track_name,
COUNT(*) AS track_done_freq
FROM streaming_history.sportify_history_2023
WHERE reason_end =  'trackdone'
GROUP BY track_name
ORDER BY track_done_freq DESC
Limit 10;

-- Top 10 most skipped tracks
SELECT track_name,
COUNT(*) AS skip_count
FROM streaming_history.sportify_history_2023
WHERE skipped = 'TRUE'
GROUP BY track_name
ORDER BY skip_count DESC
Limit 10;

-- Most used platform/device by total_play_time
SELECT platform,
SUM(min_played) AS total_play_time
FROM streaming_history.sportify_history_2023
GROUP BY platform
ORDER BY total_play_time DESC
Limit 2;

-- Longest day streaming on spotify using min_played
SELECT date_played,
	SUM(min_played) AS total_streamed_time
FROM streaming_history.sportify_history_2023
GROUP BY date_played
ORDER BY total_streamed_time DESC
Limit 1;

-- Total number of minutes streamed
SELECT SUM(min_played) AS total_min_streamed
FROM streaming_history.sportify_history_2023;

-- Most active day pf the week 
-- Get day_of_week from date_played column 
ALTER TABLE sportify_history_2023
ADD COLUMN day_of_week VARCHAR(20) 
AFTER date_played;
  
UPDATE sportify_history_2023 
SET day_of_week = DAYNAME(date_played);

SELECT day_of_week,
SUM(min_played) AS total_play_time
FROM streaming_history.sportify_history_2023
GROUP BY day_of_week
ORDER BY total_play_time DESC;

-- Most active times of the day
SELECT time_played AS hour_of_day,
SUM(min_played) AS total_min_played
FROM streaming_history.sportify_history_2023
GROUP BY hour_of_day
ORDER BY total_min_played
Limit 10;

-- Shuffle or no shuffle? based on how often I use the feature 
SELECT shuffle,
COUNT(*) AS shuffle_count
FROM streaming_history.sportify_history_2023
GROUP BY shuffle
ORDER BY shuffle_count DESC
Limit 2;

-- Verifying changes
SELECT *
FROM streaming_history.sportify_history_2023;