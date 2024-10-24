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

The dataset was structured in a single table with 21 columns, capturing various aspects of my Spotify experience. To ensure that all the information from the original file was correctly imported, I wrote a query to view the data and verify its completeness. 

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

Since the "ms_played" column was in milliseconds, I converted it to minutes for easier analysis. I added a new column, "min_played," with the converted data and dropped the redundant "ms_played" column. Afterward, I verified that the changes were applied correctly.

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

I also added two new columns, "date_played" and "time_played," to show the exact dates and times I streamed music

```sql
-- Adding new columns 'date_played' and 'time_played'
ALTER TABLE sportify_history_2023
ADD date_played date
AFTER ts;
ALTER TABLE sportify_history_2023
ADD time_played time
AFTER ts;
```

MySQL incorrectly identified the "ts" column as a text format, so I created a new column, "TS_NEW," with the TIMESTAMP datatype to ensure proper identification and querying. I then populated it with the values from the "ts" column, converting them to the DATETIME format.

```sql
-- Adding a new column "TS_NEW" with a data format timestamp recognized by MySQL
ALTER TABLE sportify_history_2023
ADD TS_NEW TIMESTAMP
AFTER ts;

-- Updating "TS_NEW" column with the converted values by transforming the datatype from STR to DATETIME
UPDATE sportify_history_2023
SET TS_NEW = STR_TO_DATE(ts, '%Y-%m-%dT%H:%i:%sZ');
```

I updated the "date_played" and "time_played" columns with values extracted from the "TS_NEW" column to display exact streaming dates and times.

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

I then dropped redundant columns, such as the "ts" column.

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

## DATA VISUALIZATION USING TABLEAU

## CONCLUSIONS

## RECOMMENDATIONS























Between February 2023 and October 2023, I delved into my Spotify streaming data to gain insights into my music listening behavior since joining the platform last year.</P> <br>
 <p> 
    <ul">
          Key Questions Explored
          <li>Total unique tracks and artists.</li>
          <li>Favorite track and artist of the year.</li>
          <li>Top 10 tracks and most streamed artists.</li>
          <li>Most streamed album and preferred streaming device.</li>
          <li>Timeline of streaming activity, including most active day and time.</li>
          <li>Usage of shuffle mode and skipped tracks.</li>
 </ul>
  </p>                                                                                                                                     
<p style="text-align: justify;"><strong>Data Overview:</strong> 
          <br> I obtained my Spotify streaming history in JSON format and converted it to CSV using Excel. 
        </p>
        <p style="text-align: justify;"> The data was in JSON format, and I 
          converted it to CSV using Excel
        </p>  
        <ul class="after-boat-list">
          The dataset consists of 21 columns, including timestamps, user information, track details, and streaming metadata, outlined below:
        <li>Ts - Date and time of when the stream ended in UTC format (Coordinated Universal Time zone).</li>
         <li>Username – My Spotify username.</li>
        <li>trackName - Name of items listened to or watched (e.g., the title 
            of music track or name of the video)</li>
        <li>Platform - Platform used when streaming the track (e.g. Android OS, Google Chromecast)</li>
        </ul>
         <li>Ms_played - For how many milliseconds the track was played.</li>
        </ul>
         <li>Conn_country - Country code of the country where the stream was played.</li>
        </ul>
         <li>Ip_addr_decrypted - IP address used when streaming the track.</li>
        </ul>
         <li>User_agent_decrypted - User agent used when streaming the track (e.g. a browser, like Mozilla Firefox, or Safari)</li>
        </ul>
         <li>Master_metadata_track_name - Name of the track.</li>
        </ul>
         <li>Master_metadata_album_artist_name - Name of the artist, band or podcast.</li>
        </ul>
         <li>Master_metadata_album_album_name - Name of the album of the track.</li>
        </ul>
         <li>Spotify_track_uri - A Spotify Track URI, that is identifying the unique music track.</li>
        </ul>
         <li>	Episode_name - Name of the episode of the podcast</li>
        </ul>
         <li>	Episode_show_name - Name of the show of the podcast.</li>
        </ul>
         <li>Spotify_episode_uri - A Spotify Episode URI, that is identifying the unique podcast episode.</li>
        </ul>
         <li>Reason_start - Reason why the track started (e.g. previous track finished or you picked it from the playlist).</li>
        </ul>
         <li>	Reason_end - Reason why the track ended (e.g. the track finished playing or you hit the next button).</li>
        </ul>
         <li>Shuffle: null/true/false - Whether shuffle mode was used when playing the track.</li>
        </ul>
         <li>Skipped: null/true/false - Information whether the user skipped to the next song.</li>
        </ul>
         <li>Offline: null/true/false - Information whether the track was played in offline mode.</li>
        </ul>
         <li>Offline_timestamp - Timestamp of when offline mode was used, if it was used.</li>
        </ul>
         <li>Incognito_mode: null/true/false - Information whether the track was played during a private session.</li>
  </ul>
  </p>   
        <p style="text-align: justify;"><strong> Cleaning Process: </strong> 
        <p style="text-align: justify;">
         I utilized SQL queries to clean and prepare the data for analysis, ensuring it suited my analytical needs and objectives. For a detailed summary of my findings and visualization of the analysis, please refer to the <strong>""my_spotify_case_study_analysis.sql" file"</strong> 
        </p>
                                                                      <p>       
<a href="https://public.tableau.com/app/profile/mgbecheta.paschal/viz/SPOTIFYSTREAMINGHISTORYDASHBOARD/Dashboard3?publish=yes" target="_blank">Click Here </a> to see Tableau dashboard for my insights at a glance 
 <p> 
