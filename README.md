# Spotify_Analysis
<p> Exploratory data analytics portfolio case study <br>
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
