use konakart;


INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - update products');

/* Update the products information from price for any existing products*/
update products, price
set 
products.products_quantity = price.available_quantity,
products.products_model=price.part_description1,
products.products_price=price.customer_price,
products.products_date_available=Date(NOW()), 
products.products_last_modified = DATE(NOW()),
products.products_weight=price.weight,
products.products_status=1, 
products.products_tax_class_id=1, 
products.custom1=price.vendor_number,
products.custom2=concat(trim(price.part_description1),if(part_description2='','','-'),trim(price.part_description2)), 
products.custom4=price.mfgpartno, 
products.custom5=price.media_type,
products.custom6 = price.actionid,
products.products_price_1=price.retail_price, 
products.store_id=1, 
products.custom7=price.sku_status,
products.custom8=price.price_class,
products.custom9=price.manufacturer,
products.custom2Int=1,
products.custom1Dec = price.customer_price,
products.product_depth=price.height,
products.product_width=price.width,
products.product_length=price.length
where products.products_sku = price.sku ;  /* and (price.actionid='A' or price.actionid='C'); */



INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - insert new products');

/*Insert new product into products from price that did not exist*/
insert ignore into products (
products_quantity,products_model,
products_price,products_date_added,products_date_available,products_last_modified,
products_weight,products_status,products_tax_class_id,
custom1,custom2,custom4, custom5,custom6,
products_sku,products_price_1, store_id, 
custom7,custom8,custom9,custom2Int,custom1Dec,
product_depth,product_width,product_length
)
(select available_quantity,part_description1, customer_price, 
Date(NOW()),DATE(NOW()), DATE(NOW()),weight,
1,1,vendor_number,
concat(part_description1,'-',part_description2),mfgpartno,
media_type,actionid,sku,
retail_price,1,
sku_status,price_class,manufacturer,1,customer_price,
height,width,length
from price where actionid='A'
);  /* where actionid='A'); */




INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - create bcs_sku_join');

-- create  interim file for faster processing

TRUNCATE TABLE bcs_sku_join;
INSERT INTO `konakart`.`bcs_sku_join`
(`products_id`,
`products_sku`,
`products_custom4`
)
(
SELECT  
products_id,products_sku,custom4
FROM products
 );


UPDATE bcs_sku_join AS bsj
INNER JOIN price as prc on bsj.products_sku = prc.sku  
Set 
bsj.price_id = prc.price_id,
bsj.price_sku = prc.sku,
bsj.price_mfgpartno = prc.mfgpartno;

/* disable deleted products */

-- update price, products
-- set products.products_status = 0
-- where products.products_sku = price.sku and price.actionid = 'D';

INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - disable inactive products');

/*  make inactive (since no "D" in weekend run) products in file but not in Products -  */
UPDATE products AS prod
INNER JOIN bcs_sku_join  as bsj on prod.products_sku = bsj.products_sku  
Set prod.products_status = 0
WHERE  bsj.price_sku is null;

INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - add products_descriptions for Ingram');



/*Insert data into products_description for new products (in case they don't have Etilize data*/
Insert into products_description
select products.products_id, 1, products.products_model,
concat(TRIM(products.custom9), " - ",TRIM(products.custom2),' sku: ', products.products_sku) , null,0,null,1,1,null,null,null,null,null,null 
from products 
LEFT JOIN products_description as  pd on pd.products_id =  products.products_id
where pd.products_name is null;


INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - virtual, large items');


/*custom3 virtual flag*/
update products, price 
set
products.products_status = 1,
products.products_quantity = 100,
products.custom3 = 'V'
where products.products_sku = price.sku and (price.price_class='X' and 
(price.media_type IN ('LICS','SLIC','SVCS','VLIC')));

/* custom3 Large item */
update products
set custom3 =
case when products_weight > 115 then 'L' 
when product_depth > 36 then 'L' 
when product_width > 36 then 'L'
when product_length >36 then 'L' 
END;



INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - disable 0 qty, 0 price items etc');

/*update products - no quantity, not virtual */
update products
set products_status = 0
where products_quantity < 1;


/* Disable products_price = 0*/
update products
set products_status=0
where products_price =0.0 ;

/*Disable items if Backordered items will be stocked in more than 30 days : 
Action Indicator ='' and next_eta_date > 30 days*/
update products, total_temp 
set
products.products_status = 0
where products.products_sku = total_temp.sku and ETA  <> '' 
and STR_TO_DATE(ETA,'%m/%d/%Y') >  ADDDATE(NOW(), INTERVAL 30 DAY);

/*
save the view in case it gets lost
CREATE ALGORITHM=UNDEFINED DEFINER=`konakart`@`localhost` SQL SECURITY DEFINER VIEW `vwingetlprodmfg` AS select `ing`.`products_id` AS `products_id`,`ing`.`custom9` AS `ingmfgname`,`ing`.`custom4` AS `ingmfgpartno`,`ing`.`custom9` AS `ingmfgmfgname`,`map`.`Et_mfg_ID` AS `Et_mfg_ID` from (`products` `ing` join `EtilizeMfgMap` `map` on((convert(`map`.`Mfg_name` using utf8) = `ing`.`custom9`))) where (`ing`.`custom1Int` is not null);
*/

INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - get product Id and Etilize ID');

drop table pidtmp;
create table pidtmp (
	products_id int(11),
	pid int(11),
	KEY `idx_products_id` (`products_id`)
	);
        
INSERT INTO `konakart`.`pidtmp`
(`products_id`,
`pid`)
        
SELECT vwingetlprodmfg.products_id ,EtlProd.productid
-- , 	vwingetlprodmfg.ingmfgname, vwingetlprodmfg.ingmfgpartno, vwingetlprodmfg.ingmfgmfgname,vwingetlprodmfg.ingmfgmfgname
from vwingetlprodmfg 
INNER JOIN product as EtlProd on EtlProd.manufacturerid = vwingetlprodmfg.Et_mfg_ID 
	and vwingetlprodmfg.ingmfgpartno = EtlProd.mfgpartno; 



update products, pidtmp
set products.custom1Int = pidtmp.pid
where products.products_id = pidtmp.products_id;

drop table pidtmp;

/*   2nd method to get Etilize product ID */

INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - get product Id via sku');


update products
INNER JOIN `konakart`.`productskus` prodsku on prodsku.sku = products.products_sku
set products.custom1Int = prodsku.productid
where store_id=1 and custom1Int is null and
	prodsku.name = 'Ingram Micro USA';

/*   Add products to categories */

/* missing products to categories with Etilize data */

INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - missing products to categories');


INSERT INTO `konakart`.`products_to_categories`
(`products_id`,
`categories_id`,
`store_id`)
SELECT products.products_id, categoryid, products.store_id
-- , custom1Int ,pc.products_id
FROM `konakart`.products
LEFT JOIN products_to_categories pc on pc.products_id=products.products_id
INNER JOIN product on product.productid = products.custom1Int
where custom1Int>0  and products.store_id=1 and pc.products_id is null;

/* missing products to categories  from older products*/

INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - updating products to categories');

update products_to_categories
INNER JOIN products on products.products_id = products_to_categories.products_id
INNER JOIN product on product.productid = products.custom1Int
SET products_to_categories.categories_id = product.categoryid
where products_to_categories.categories_id = 999999999 and `products_to_categories`.`store_id` = 1;

/* missing products to categories  - add dummy*/

INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - default missing products to categories');

INSERT INTO `konakart`.`products_to_categories`
(`products_id`,
`categories_id`,
`store_id`)
SELECT products.products_id, 999999999, products.store_id
-- , custom1Int ,pc.products_id
FROM `konakart`.products
LEFT JOIN products_to_categories pc on pc.products_id=products.products_id
where custom1Int is null  and products.store_id=1 and pc.products_id is null;

/* Manufactuerer data */

/* update any missing used Ingram manufacturers */

INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - update any missing used Ingram manufacturers');

INSERT INTO `konakart`.`manufacturers`
(
`manufacturers_name`,
`date_added`,
`last_modified`,
`custom1`,
`custom2`,
`store_id`)
select distinct manufacturer,now(),now(), manufacturer,vendor_number,1
from price
LEFT JOIN manufacturers mfg on mfg.custom1 = price.vendor_number
where mfg.custom1 is null;

/* update products' manufacturer id for new products */

INSERT INTO `konakart`.`bcs_log_for_loads` (`system_name`, `load_datetime`, `module`)
VALUES ('DLIngramEtlize.sh',now(), 'update_products_from_price.sql - update products manufacturer id for new products');


update products
INNER JOIN manufacturers mfg on mfg.custom1 =  products.custom1 and mfg.custom2 =  products.custom9
SET products.manufacturers_id = mfg.manufacturers_id
where products.manufacturers_id is null and `products`.`store_id` = 1;




