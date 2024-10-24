# EXPLORATORY DATA ANALYSIS OF MY SPOTIFY STREAMING HISTORY USING EXCEL, SQL AND TABLEAU

## TABLE OF CONTENT 
- [INTRODUCTION](#introduction)
- [OBJECTIVES](#objectives)
- [DATA COLLECTION AND PREPARATION](#data-collection-and-preparation)
  - [DATA SOURCE AND EXTRACTION](#data-source-and-extraction)
  - [IMPORTING DATA INTO MySQL](#importing-data-into-mysql)
  - [DATA CLEANING AND TRANSFORMATION](#data-cleaning-and-transformation)
 - [EXPLORATORY DATA ANALYSIS USING MySQL](#exploratory-data-analysis-using-mysql)
 - [DATA VISUALIZATION USING TABLEAU](#data-visualization-using-tableau)
 - [CONCLUSIONS](#conclusions)
 - [RECOMMENDATIONS](#recommendations)


## INTRODUCTION

Music offers a unique perspective into my personality, with song choices reflecting who I am and listening patterns revealing its role in my daily life. To explore whether music is a source of motivation, a pastime, or something deeper, I decided to analyze my streaming data for clearer connections.

This project highlights my approach to extracting data, over a 9-month period, between Feb 13th 2023 to Oct 26th 2023, from my Spotify music streaming history, analyzing it with MySQL and visualizing insights in Tableau to gain a deeper understanding of my musical preferences and overall listening habits.


## OBJECTIVES

Key questions I want answered are outlined below

- How much time I’ve spent steaming on spotify overall.
-	Discover my favorite artists, tracks, and albums over the past 9 months.
-	Discover peak listening times by both time of day and day of the week.
-	Time changes in my music consumption over the 9-month period.
-	Determine my preferred device for consuming musical content.
-	Uncover patterns in how my top music preferences evolved month by month.
-	Identify my music-related habits, such as reasons for ending tracks, shuffling preference

## DATA COLLECTION AND PREPARATION
### DATA SOURCE AND EXTRACTION 

I appreciate Spotify's feature that lets users download their streaming history via its developer platform. The data, sent in JSON format to my email, was converted to CSV using Excel. I used the Extended Streaming History dataset, which includes 21 columns with details like timestamps, user info, track data, and streaming metadata.

-	Ts - Date and time of when the stream ended in UTC format (Coordinated Universal Time zone).
-	Username – My Spotify username.
-	Platform - Platform used when streaming the track (e.g. Android OS, Google Chromecast)
-	Ms_played - For how many milliseconds the track was played.
-	Conn_country - Country code of the country where the stream was played.
-	Ip_addr_decrypted - IP address used when streaming the track.
-	User_agent_decrypted - User agent used when streaming the track (e.g. a browser, like Mozilla Firefox, or Safari).
-	Master_metadata_track_name - Name of the track.
-	Master_metadata_album_artist_name - Name of the artist, band or podcast.
-	Master_metadata_album_album_name - Name of the album of the track.
-	Spotify_track_uri - A Spotify Track URI, that is identifying the unique music track.
-	Episode_name - Name of the episode of the podcast.
-	Episode_show_name - Name of the show of the podcast.
-	Spotify_episode_uri - A Spotify Episode URI, that is identifying the unique podcast episode.
-	Reason_start - Reason why the track started (e.g. previous track finished or you picked it from the playlist).
-	Reason_end - Reason why the track ended (e.g. the track finished playing or you hit the next button).
-	Shuffle: null/true/false - Whether shuffle mode was used when playing the track.
-	Skipped: null/true/false - Information whether the user skipped to the next song.
-	Offline: null/true/false - Information whether the track was played in offline mode.
-	Offline_timestamp - Timestamp of when offline mode was used, if it was used.
-	Incognito_mode: null/true/false - Information whether the track was played during a private session.

At first glance, the data was organized into a folder with multiple distinct datasets, each representing different aspects of my Spotify personal data. My primary focus was on the dataset containing my complete streaming history.

As I reviewed the dataset, I identified several key columns that would be essential for answering my predefined questions and uncovering deeper insights. However, I also noticed a few columns that were irrelevant to my objectives, making them redundant for this analysis. 

I noticed that a crucial column, *music genre*, was missing from the data. This column is essential as it categorizes the genre of every track I’ve listened to. While resolving this issue wasn’t impossible, it required sourcing the missing information from external resources.


### IMPORTING DATA INTO MySQL

Given the large size of the dataset, I chose MySQL as my primary tool for data cleaning and querying to extract insights. I created a schema named *streaming history* within MySQL workspace, imported the CSV file of the *my_spotify_streaming_audio_2023* dataset as a table using the Table data import wizard option for this purpose.

To preview the summary of the queries i used in my analysis conducted using SQL [CLICK HERE](https://github.com/paschaldubem/Spotify_Analysis/blob/main/my_sportify_case_study_analysis.sql)

The dataset had a single table with 21 columns, capturing my Spotify experience. I wrote a query to verify that all information was correctly imported from the original file.

``` sql
-- Importing data 
-- Initial view of imported dataset
SELECT * 
FROM streaming_history.my_sportify_streaming_audio_2023;
```

Querying the imported dataset to be certain it tallies with the original excel spreadsheet

```sql
-- Verifying that downloaded number of fields tallies with that in the excel spreadsheet
SELECT COUNT(*)
FROM streaming_history.my_sportify_streaming_audio_2023;
```


### DATA CLEANING AND TRANSFORMATION
Cleaning and transforming my data are a prerequisite to my analysis process and is vital for its accuracy, efficiency, and its meaning. Without these steps, any conclusions drawn from the data could be unreliable or invalid at best.

To focus on the key columns relevant to my analysis, I created and populated a new table named *streaming_history*. This table includes the selected columns crucial for answering my predefined questions, as well as additional insights, and will serve as the primary source for querying throughout the analysis.

```sql
-- Aggregating essential columns by generating a new table derived from the pre-existing dataset 
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
```

For better readability and clarity, I noticed that both my schema and table were named *streaming_history*.  To avoid confusion, I renamed the table to *spotify_history_2023*.

```sql
--  Reanaming table 
RENAME TABLE streaming_history TO sportify_history_2023;
```

Next, I dropped the now redundant *my_spotify_streaming_audio_2023* table, as it was no longer required after the data was migrated to the new table. 

```sql
-- Dropping redundant datasets
DROP TABLE my_sportify_streaming_audio_2023;
```

Since the `ms_played` column was in milliseconds, I converted it to minutes for easier analysis. I added a new column, `min_played`, with the converted data and dropped the redundant `ms_played` column. Afterward, I verified that the changes were applied correctly.

```sql
-- Adding a new column as min_played
-- 'msplayed' is in miliseconds and needs to be converted to minutes 
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
```

I also added two new columns, `date_played` and `time_played`, to show the exact dates and times I streamed music

```sql
-- Adding new columns 'date_played' and 'time_played'
ALTER TABLE sportify_history_2023
ADD date_played date
AFTER ts;
ALTER TABLE sportify_history_2023
ADD time_played time
AFTER ts;
```

MySQL incorrectly identified the `ts` column as a text format, so I created a new column, `TS_NEW`, with the TIMESTAMP datatype to ensure proper identification and querying. I then populated it with the values from the `ts` column, converting them to the DATETIME format.

```sql
-- Adding a new column "TS_NEW" with a data format timestamp recognized by MySQL
ALTER TABLE sportify_history_2023
ADD TS_NEW TIMESTAMP
AFTER ts;

-- Updating "TS_NEW" column with the converted values by transforming the datatype from STR to DATETIME
UPDATE sportify_history_2023
SET TS_NEW = STR_TO_DATE(ts, '%Y-%m-%dT%H:%i:%sZ');
```

I updated the `date_played` and `time_played` columns with values extracted from the `TS_NEW` column to display exact streaming dates and times.

```sql
-- Updating new columns 'date_played' and 'time_played' with values from "TS_NEW" column
UPDATE sportify_history_2023
SET 
    date_played = DATE(TS_NEW),
    time_played = TIME(TS_NEW);
```

To ensure the correctness of all modifications, I intermittently checked the data for errors

```sql
-- Verifying changes
SELECT *
FROM streaming_history.sportify_history_2023;
```

I then dropped redundant columns, such as the `ts` column.

```sql
-- Dropping redundant 'ts' column 
ALTER TABLE sportify_history_2023
DROP COLUMN ts;
```

Some columns had excessively long names, which could make the SQL queries less readable. To simplify my SQL code and improve clarity, I decided to rename those columns.

```sql
-- Renaming columns for better readability and understanding 
ALTER TABLE sportify_history_2023
RENAME COLUMN master_metadata_track_name TO track_name,
RENAME COLUMN master_metadata_album_artist_name TO artist_name,
RENAME COLUMN master_metadata_album_album_name TO album_name;
```

After all necessary adjustments, I was satisfied with the table structure. Ensuring the table is free from NULL values and blanks is critical for accurate analysis, so I addressed and removed these where necessary.

```sql
-- Remove blanks or NULL values 
DELETE FROM sportify_history_2023
WHERE track_name IS NULL OR 
    TRIM(track_name) = '';
```
    
As I wrap up my cleaning process, I need to verify that all changes were implemented correctly and without any errors.

```sql
-- Verifying changes
SELECT *
FROM streaming_history.sportify_history_2023;
```

## EXPLORATORY DATA ANALYSIS USING MySQL

The purpose of this analysis is to better understand myself through my music choices, uncover hidden habits, and explore any potential relationships between music and my personality. My EDA begins with simple questions and expands into areas that I couldn't fully explore using SQL alone, utilizing Tableau for deeper insights. This process was both insightful and enjoyable, and I hope to demonstrate some its value here.

Some of the questions are

- TOTAL UNIQUE TRACK STREAMED: Over the 9-month period, I queried the number of unique tracks to understand how many songs I have been exposed to since joining Spotify. This query aggregates by doing a count of all unique tracks in my historical data.

```sql
-- Total number of unique songs streamed
SELECT COUNT(DISTINCT (track_name)) AS Total_unique_songs
FROM streaming_history.sportify_history_2023;
```

This revealed that I listened to 2164 potentially new songs during the time I spent on the platform.

- TOTAL MINUTES STREAMING ON SPOTIFY: I calculated the total time spent on Spotify over the 9 months, this query helps put this into perspective.

```sql
-- Total minutes streaming on spotify
SELECT SUM(min_played) AS total_min_streamed
FROM streaming_history.sportify_history_2023;
```
The query helps reveal the total time in 9 months I spent listening to music on spotify which was 37,948 minutes (about 27 days!

- IDENTIFY TOP TRACKS: To identify the top songs streamed over this 9-month period, I discovered and used two criteria I felt held equal standing in giving insights into an accurate result.
  
  - By total minutes played: This ranks the tracks based on total time listened over the period
    
  -  By frequency of completing the tracks `trackdone`: This shows how often I listened to a track all the way through without skipping.
Spotify have a column named “reason for trackend” where any possible scenario leading to a track ending is recorded.
 
```sql
-- Top 10 songs streamed by total minutes played
SELECT track_name,
SUM(min_played) AS total_minutes_played
FROM streaming_history.sportify_history_2023
GROUP BY track_name
ORDER BY total_minutes_played DESC
LIMIT 10;


-- 10 top tracks I streamed completely the most times
SELECT track_name,
COUNT(*) AS track_done_freq
FROM streaming_history.sportify_history_2023
WHERE reason_end =  'trackdone'
GROUP BY track_name
ORDER BY track_done_freq DESC
Limit 10;
```

These metrics highlight my favorite songs and reveal patterns I may not have noticed, like tracks I replay more often than I realized.

- TOTAL UNIQUE ARTISTS STREAMED: To assess the diversity of my music choices, I calculated the total number of unique artists I’ve streamed. This helps to determine the number of artists ive streamed over this 9-month period.

```sql
-- Total unique artists streamed
SELECT COUNT(DISTINCT(artist_name)) AS Unique_artists
FROM streaming_history.sportify_history_2023;
```

This showed that I listened to and interacted with 1,078 unique artists on the platform.

- TOP ARTISTS STREAMED: To identify the artists that were streamed the most frequently over the given period, two criteria were used:
    - By total minutes played: This helped reveal the total time I spent listening to these artists over the given period. This query ranks artists by total minutes played.
      
    - By frequency of completing the tracks `trackdone`: This reveals the number of times I fully listened to these artists songs without skipping over this same time period. Spotify has a column named “reason for trackend” where any possible scenario leading to their songs ending is recorded.
 
```sql
-- Top 10 artists by total minutes played
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
```

These queries will reveal which artists dominated my listening history, providing insights into my musical preferences. I discovered that certain artists were streamed far more frequently than others.

- MOST STREAMED ALBUMS: I identified the albums I listened to the most, which also sheds light on my favorite collections of tracks and artists.

```sql
-- Most streamed album
SELECT album_name,
SUM(min_played) AS total_minutes_played
FROM streaming_history.sportify_history_2023
GROUP BY album_name
ORDER BY total_minutes_played DESC 
Limit 10;
```

This highlights my favorite albums, revealing the collective body of work I enjoyed the most.

- PLATFOM USE DISTRIBUTION:  Since I stream Spotify on multiple devices, I wanted to determine which one I used most frequently.

```sql
-- Most used platform/device by total_play_time
SELECT platform,
SUM(min_played) AS total_play_time
FROM streaming_history.sportify_history_2023
GROUP BY platform
ORDER BY total_play_time DESC
Limit 2;
```
This reveals my preferred streaming device, indicating which is most convenient for me.

- IDENTIFY PEAK LISTENING DAY: I wanted to discover the day when I listened to the most music and explore if it correlates with other metrics.

```sql
-- Peak streaming day on spotify using min_played
SELECT date_played,
	SUM(min_played) AS total_streamed_time
FROM streaming_history.sportify_history_2023
GROUP BY date_played
ORDER BY total_streamed_time DESC
Limit 1;
```

Understanding my peak streaming day may provide insight into significant events or activities that led to longer listening times.

- DAILY LISTENING PATTERNS: I analyzed daily patterns to see if there are specific days when I tend to listen to more music. 

```sql
-- Daily listening patterns
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
```

This query will show if you listen to more music on weekends or weekdays, helping you understand your listening patterns throughout the week.

- SHUFFLING PREFERENCES: Lastly, I aimed to understand if I prefer to shuffle my playlist or listen to it sequentially.

```sql
-- Shuffle or no shuffle? based on how often I use the feature 
SELECT shuffle,
COUNT(*) AS shuffle_count
FROM streaming_history.sportify_history_2023
GROUP BY shuffle
ORDER BY shuffle_count DESC
Limit 2;
```

To preview the summary of the queries i used in my analysis conducted using SQL [CLICK HERE]()


## DATA VISUALIZATION USING TABLEAU

Data visualizations tell compelling stories, are visually appealing, and most importantly, reveal insights that SQL queries alone may miss. This is why I chose Tableau—it highlights trends and patterns not immediately obvious in raw data or tables.

In my visualizations, I employed various chart types, each selected for their ability to effectively communicate the insights I was aiming to uncover. Below are some key chart types and the insights they reveal:

![INSIGHTS AT GLANCE ](https://github.com/user-attachments/assets/f98f603b-ce8d-475a-bfda-b7a145c65fd5)

- TOP 10 TRACKS: This bar chart represents my top 10 tracks by two metrics
	- total minutes played and
	- frequency of completion
 
![TOP 10 STREAMED TRACKS](https://github.com/user-attachments/assets/1403b4e8-b1bf-4ecc-aab2-fc9c2b095044)
	
 
![TOP 10 TRACKS BY FREQUENCY OF TRACK COMPLETION](https://github.com/user-attachments/assets/04297900-768e-4eb7-b713-5bcfdf3eafeb)

*MILFORD SOUND* was my top track with 602.6 minutes streamed, followed closely by *WE LOVE PT2* WITH 519.3 minutes by the total minutes played metric. *WE LOVE PT1* takes the top spot under the frequency of completion metric.  Most of these top tracks were from the artist *Caye*, whose default genre is *POP* suggesting that pop was my dominant genre during the period.


- TOP 10 ARTISTS: Similarly, I visualized my favorite artists by
	- minutes played and
	- track completion frequency.

 ![TOP 10 STREAMED ARTISTS](https://github.com/user-attachments/assets/5e1520fc-ce74-4dba-a474-497d627ed60c)

![TOP 10 ARTIST BY NUMBER OF COMPLETED STREAMS](https://github.com/user-attachments/assets/1aa33f4d-dcc7-4343-a907-4e2311833f7c)

*Caye* again ranked highest, with 4,523 minutes played and 1270 respectively; *Justin Bieber* coming in second with 883 minutes played and 265 respectively with a majority of artists in the top 10 being pop artists, reinforcing my preference for *POP* music.


- MOST STREAMED ALBUMS:  This is a bar chart representing my top 10 albums by total minutes played. The bars represent the albums and its corresponding height represents the total minutes spent playing the tracks it contains.

 ![MOST STREAMED ALBUMS ](https://github.com/user-attachments/assets/55581280-3298-4a34-b536-0f6eea3ae620)

*WE LOVE* album by *Caye* ranks the highest in this metric, with 3,908 minutes played, solidifying my earlier hypothesis made during my `top tracks` analysis, followed by *ENDS & BEGINS* by *Labrinth* with 723 minutes played. This implies that *POP* is indeed my favorite music genre with a mix of HipHop largely due to the *ENTERGALACTIC* album by *Kid Kuli* coming in 3rd with 698 minutes played.

- HOURLY ACTIVITY TIMELINE: A bar chart showing my streaming activity across different hours of the day. It reveals that my listening peaks during the day, ranging from around 9 am in the mornings, then peaks at 1pm, 4pm before hitting its highest point at 7pm reflecting that I stream music mostly while working or during daily routines.
 
![HOURLY ACTIVITY TIMELINE](https://github.com/user-attachments/assets/96622a15-7e7d-45d2-a26d-40ee1a125de6)


- DAILY LISTENING PATTERNS: Another bar chart that highlights streaming activity by day of the week. Monday and Thursday saw the highest streaming activity with 6265 and 6179 minutes streamed respectively as I listen to music while I work, while Sunday had the lowest, likely because I take time off from work on that day. 

 ![DAILY LISTENING PATTERNS ](https://github.com/user-attachments/assets/c1626e26-0946-4e05-a6fb-77b1d7799631)



- SHUFFLING PREFERENCES: I used a pie chart to visualize my shuffling preferences. The data shows that I prefer listening to songs in shuffle mode, likely because I enjoy the unpredictability.

![SHUFFLING PREFERNCE ](https://github.com/user-attachments/assets/b08bbd64-890c-4c33-ab1c-392a22c244e9)


- REASONS FOR TRACK END IN PERCENTAGES:  The packed bubble displayed the different reasons spotify documented as to why a track would end represented by the different sized and colored bubbles and the frequencies that they occurred represented by the sizes of the different bubbles.

![REASONS FOR TRACK END IN PERCENTAGES](https://github.com/user-attachments/assets/66c7f0b8-b4dd-44c6-a7cd-7456b4287386)


I let songs play till completion 84.92% of the time, which means that I rarely interfere with the app once I start playing music or I put my songs on repeat a lot.

For more visualizations and interactive dashbards in Tableau [CLICK HERE](https://public.tableau.com/app/profile/mgbecheta.paschal/viz/Myspotifyhistoryvisualization/INSIGHTSATGLANCE)
 

## CONCLUSIONS

Analyzing my Spotify streaming data has been an eye-opening experience, challenging my assumptions and revealing new insights. While I’ve always known that I enjoy listening to music, I was unaware of just how much time I spend streaming. Tracking my habits for the first time has provided valuable clarity.
  
1. The most significant discovery was that pop music is my default favorite genre. I previously paid little attention to specific genres, focusing only on whether I liked a song or not. This newfound knowledge has been empowering. Additionally, I always thought of myself as an Ed Sheeran fan, but the data revealed that I listen to Caye far more often. This insight has made me rethink how I identify my favorite artists and songs.

2. Another surprise was learning that I primarily stream music during the day, despite considering myself more nocturnal. The data shows that I tend to listen to music while working, building projects, or browsing the web, as it helps improve my concentration.

3. Other interesting revelations include my tendency to listen to tracks in full, my preference for shuffling songs, and the fact that I mostly stream music from my laptop.


## RECOMMENDATIONS

1. While Spotify’s AI already tailors my experience based on my music choices, as a data analyst, I recommend listening to more pop music from sub-genres like Afro Pop and Art Pop, as well as related genres such as rock and urban. This would add variety while staying aligned with my current preferences.

2. Public playlists featuring a blend of these genres could also enhance the user experience

3. It would be efficient to aggregate my most played or most repeated songs into a dedicated playlist for quick access.

4. Using the “smart shuffle” feature rather than regular shuffle could enhance my music experience as spotify's algorithm would play only the most relevant and related tracks, introducing me to even more artists within my preferred genre. 

5. Being able to listen to music offline would boost retention further because streaming music would no longer be solely determined by an internet connection.






















   
