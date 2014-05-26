use konakart;


INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'load_stock.sql');


TRUNCATE TABLE total_temp;

LOAD DATA LOCAL INFILE "TOTAL.TXT"
  REPLACE INTO TABLE total_temp 
  FIELDS TERMINATED BY ','
  ENCLOSED BY '"'
  LINES TERMINATED BY '\r\n'
  (`sku`, `quantity`, `ETA`);

UPDATE `total_temp` AS p SET sku = TRIM(p.sku);

Update price, total_temp 
set
price.available_quantity = total_temp.quantity
where price.sku = total_temp.sku;

