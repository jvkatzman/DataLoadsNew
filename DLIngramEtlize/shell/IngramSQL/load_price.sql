use konakart;


INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'load_price.sql');


truncate price;


LOAD DATA LOCAL INFILE "PRICE.TXT"
                REPLACE INTO TABLE price
                FIELDS TERMINATED BY ',' 
                ENCLOSED BY '"' 
                LINES TERMINATED BY '\r\n'
                (  `actionid`, `sku`, `vendor_number`,`manufacturer`,`part_description1`,`part_description2`,`retail_price`,`mfgpartno`,`weight`,`upc_code`,
              `length`,`width`,  `height`,  `price_change_flag`,  `customer_price`,  `special_price_flag`,  `availability_flag`,  `sku_status`,  `cpu_code`,  `media_type`,
                `category`,  `item_receipt_flag`,  `instant_rebate_flag`, `sub_part_number` ,`available_quantity`,  `price_category`,`price_class`);


UPDATE `price` AS p SET sku = TRIM(p.sku);




