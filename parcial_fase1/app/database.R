library(RMariaDB)
mydb <- dbConnect(RMariaDB::MariaDB(), user="test", password="test123", dbname="parcial1", host="172.28.1.1")
dbGetQuery(mydb, "show tables;")
videos <- dbReadTable(mydb, "videos")
videos_stats <- dbReadTable(mydb, "videos_stats")

