USE proyecto_pd;

CREATE TABLE covid19_confirmed (
	id INT NOT NULL AUTO_INCREMENT,
	province VARCHAR(90),
	country VARCHAR(90),
	lat DECIMAL(16,7),
	lon DECIMAL(16,7),
	event_date DATE,
	accumulated INT,
	PRIMARY KEY (id)
);

CREATE TABLE covid19_deaths (
        id INT NOT NULL AUTO_INCREMENT,
        province VARCHAR(90),
        country VARCHAR(90),
        lat DECIMAL(16,7),
        lon DECIMAL(16,7),
        event_date DATE,
        accumulated INT,
        PRIMARY KEY (id)
);

CREATE TABLE covid19_recovered (
        id INT NOT NULL AUTO_INCREMENT,
        province VARCHAR(90),
        country VARCHAR(90),
        lat DECIMAL(16,7),
        lon DECIMAL(16,7),
        event_date DATE,
        accumulated INT,
        PRIMARY KEY (id)
);


