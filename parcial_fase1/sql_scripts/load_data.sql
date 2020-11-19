USE parcial1;

CREATE TABLE video_stats (
	id VARCHAR(30) NOT NULL,
	viewCount INT,
	likeCount INT,
	dislikeCount INT,
	favoriteCount INT,
	commentCount INT,
	PRIMARY KEY (id)
);

LOAD DATA INFILE '/var/lib/mysql-files/academatica_video_stats.csv'
INTO TABLE video_stats
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
