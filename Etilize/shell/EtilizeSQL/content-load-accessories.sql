LOAD DATA LOCAL INFILE 'EN_US_A_productaccessories.csv' INTO TABLE tempproductaccessories
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';
