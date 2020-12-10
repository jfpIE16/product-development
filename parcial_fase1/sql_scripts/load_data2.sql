USE parcial1;

CREATE TABLE videos (
	kind VARCHAR(255),
	etag VARCHAR(255),
	list_id VARCHAR(255),
	video_id VARCHAR(255) NOT NULL,
	published_date VARCHAR(255)
);

LOAD DATA INFILE '/var/lib/mysql-files/academatica_videos.csv'
INTO TABLE videos
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

