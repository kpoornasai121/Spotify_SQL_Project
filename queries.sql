-- EDA
SELECT * FROM spotify;

SELECT count(*) FROM spotify;

SELECT count(distinct artist) FROM spotify;

SELECT distinct album_type FROM spotify;

SELECT max(duration_min) FROM spotify;
SELECT min(duration_min) FROM spotify;

SELECT * FROM spotify
where duration_min=0;

DELETE FROM spotify
where duration_min=0;

SELECT distinct most_played_on FROM spotify;


-- Data Analysis

-- ----------------------
-- Easy level
-- ----------------------

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.

select track from spotify
where stream > 1000000000;

-- 2. List all albums along with their respective artists.

select distinct album, artist 
from spotify
order by 1;

-- 3. Get the total number of comments for tracks where licensed = TRUE

select sum(comments) total_comments
from spotify
where licensed=True;

-- 4. Find all tracks that belong to the album type single.

select track from spotify
where album_type = 'single';

-- 5. Count the total number of tracks by each artist.

select artist , count(*) total_songs
from spotify
group by artist
order by 2 ;


-- ----------------------
-- Medium level
-- ----------------------

-- 6. Calculate the average danceability of tracks in each album.

SELECT album, avg(danceability) as avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 desc;

-- 7. Find the top 5 tracks with the highest energy values.

SELECT track, max(energy)
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 8. List all tracks along with their views and likes where official_video = TRUE

select distinct track, sum(views) total_views, sum(likes) total_likes
from spotify
where official_video=true
group by 1
order by 2 desc;

-- 9 For each album, calculate the total views of all associated tracks.

SELECT album, track, SUM (views)
FROM spotify
GROUP BY 1, 2
ORDER BY 3 DESC;

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM
(SELECT track, 
	coalesce(sum(case when most_played_on='Youtube' then stream end),0) as streamed_on_youtube,
	coalesce(sum(case when most_played_on='Spotify' then stream end),0) as streamed_on_spotify
from spotify
group by 1) t1
where streamed_on_youtube < streamed_on_spotify and streamed_on_youtube <>0;


-- ----------------------
-- Advance level
-- ----------------------

-- 11. Find the top 3 most-viewed tracks for each artist using window functions.

with ranking as(
SELECT artist, track, SUM (views) as total_view, dense_rank() over(partition by artist order by sum(views) desc) rank	
FROM spotify
GROUP BY 1, 2
ORDER BY 1, 3 DESC
)
select * from ranking where rank <=3;

-- 12. Write a query to find tracks where the liveness score is above the average.

SELECT track, artist, liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);

-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH cte
AS
(SELECT album,
MAX(energy) as highest_energy,
MIN (energy) as lowest_energy
FROM spotify
GROUP BY 1
)
SELECT album, highest_energy - lowest_energy as energy_diff
from cte
order by 2 desc;

