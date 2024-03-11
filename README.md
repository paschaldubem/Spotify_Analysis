# Spotify_Analysis
Exploratory data analytics portfolio case study 

Between February 2023, and October 2023, I delved into my Spotify streaming data to gain insights into my music listening behavior since joining the platform last year.
Key Questions Explored:

•	Total unique tracks and artists.

•	Favorite track and artist of the year.

•	Top 10 tracks and most streamed artists.

•	Most streamed album and preferred streaming device.
•	Timeline of streaming activity, including most active day and time.
•	Usage of shuffle mode and skipped tracks.

Data Overview: 

I obtained my Spotify streaming history in JSON format and converted it to CSV using Excel. The dataset consists of 21 columns, including timestamps, user information, track details, and streaming metadata, outlined below
•	Ts - Date and time of when the stream ended in UTC format (Coordinated Universal Time zone).
•	Username – My Spotify username.
•	Platform - Platform used when streaming the track (e.g. Android OS, Google Chromecast)
•	Ms_played - For how many milliseconds the track was played.
•	Conn_country - Country code of the country where the stream was played.
•	Ip_addr_decrypted - IP address used when streaming the track.
•	User_agent_decrypted - User agent used when streaming the track (e.g. a browser, like Mozilla Firefox, or Safari).
•	Master_metadata_track_name - Name of the track.
•	Master_metadata_album_artist_name - Name of the artist, band or podcast.
•	Master_metadata_album_album_name - Name of the album of the track.
•	Spotify_track_uri - A Spotify Track URI, that is identifying the unique music track.
•	Episode_name - Name of the episode of the podcast.
•	Episode_show_name - Name of the show of the podcast.
•	Spotify_episode_uri - A Spotify Episode URI, that is identifying the unique podcast episode.
•	Reason_start - Reason why the track started (e.g. previous track finished or you picked it from the playlist).
•	Reason_end - Reason why the track ended (e.g. the track finished playing or you hit the next button).
•	Shuffle: null/true/false - Whether shuffle mode was used when playing the track.
•	Skipped: null/true/false - Information whether the user skipped to the next song.
•	Offline: null/true/false - Information whether the track was played in offline mode.
•	Offline_timestamp - Timestamp of when offline mode was used, if it was used.
•	Incognito_mode: null/true/false - Information whether the track was played during a private session.

Cleaning Process: 

I utilized SQL queries to clean and prepare the data for analysis, ensuring it suited my analytical needs and objectives.
For a detailed summary of my findings and visualization of the analysis, please refer to the "my_spotify_case_study_analysis.sql" file 
Click here to see Tableau dashboard to see my insights at a glance 
