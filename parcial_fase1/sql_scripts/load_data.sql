USE parcial1;

CREATE TABLE videos_stats (
	id_video VARCHAR(30) NOT NULL,
	viewCount INT,
	likeCount INT,
	dislikeCount INT,
	favoriteCount INT,
	commentCount INT,
	PRIMARY KEY (id_video)
);


LOAD DATA INFILE '/var/lib/mysql-files/academatica_video_stats.csv'
INTO TABLE videos_stats
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
