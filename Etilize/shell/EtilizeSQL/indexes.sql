CREATE  INDEX attributenames_attributeID ON tempattributenames (attributeid);
 
CREATE  INDEX attributenames_localeID ON tempattributenames (localeid);
 
# CREATE  INDEX catery_categoryID ON tempcategory (categoryid);
 
CREATE  INDEX caterydisplayattributes_hID ON tempcategorydisplayattributes (headerid);
 
CREATE  INDEX caterydisplayattributes_cID ON tempcategorydisplayattributes (categoryid);
 
CREATE  INDEX caterydisplayattributes_aID ON tempcategorydisplayattributes (attributeid);
 
CREATE  INDEX cateryheader_headerID ON tempcategoryheader (headerid);
 
CREATE  INDEX cateryheader_categoryID ON tempcategoryheader (categoryid);
 
CREATE  INDEX caterynames_categoryID ON tempcategorynames (categoryid);
 
CREATE  INDEX caterynames_localeID ON tempcategorynames (localeid);
 
CREATE  INDEX caterysearchattributes_aID ON tempcategorysearchattributes (attributeid);
 
CREATE  INDEX caterysearchattributes_cID ON tempcategorysearchattributes (categoryid);
 
CREATE  INDEX headernames_headerID ON tempheadernames (headerid);
 
CREATE  INDEX headernames_localeID ON tempheadernames (localeid);
 
CREATE  INDEX locales_languageCode ON templocales (languagecode);
 
Alter table templocales ADD CONSTRAINT templocales_PK PRIMARY KEY(localeid);

CREATE  INDEX locales_countryCode ON templocales (countrycode);
 
Alter table tempmanufacturer ADD CONSTRAINT tmanufacturer_PK PRIMARY KEY(manufacturerid);

Alter table tempproduct ADD CONSTRAINT tempproduct_PK PRIMARY KEY(productid);

CREATE  INDEX product_isAccessory ON tempproduct (isaccessory);
 
CREATE  INDEX product_manufacturerID ON tempproduct (manufacturerID);
 
CREATE  INDEX product_categoryID ON tempproduct (categoryID);
 
CREATE  INDEX productaccessories_productID ON tempproductaccessories (productid);
 
CREATE  INDEX productaccessories_isPreferred ON tempproductaccessories (ispreferred);
 
CREATE  INDEX productacesories_acesoryPID ON tempproductaccessories (accessoryproductid);
 
CREATE  INDEX productattribute_productID ON tempproductattribute (productid);
 
CREATE  INDEX productattribute_categoryID ON tempproductattribute (categoryid);
 
CREATE  INDEX productattribute_attributeID ON tempproductattribute (attributeid);
 
CREATE  INDEX productattribute_localeID ON tempproductattribute (localeid);
 
CREATE  INDEX productdescriptions_productID ON tempproductdescriptions (productid);
 
CREATE  INDEX productdescriptions_localeID ON tempproductdescriptions (localeid);
 
CREATE  INDEX productimages_productID ON tempproductimages (productid);
 
# CREATE  INDEX productkeywords_productID ON tempproductkeywords (productid);
 
# CREATE  INDEX productkeywords_keywords ON tempproductkeywords (keywords(255));
 
# CREATE  INDEX productkeywords_localeID ON tempproductkeywords (localeid);
 
CREATE  INDEX productlocales_productID ON tempproductlocales (productid);
 
CREATE  INDEX productlocales_localeID ON tempproductlocales (localeid);
 
CREATE  INDEX productlocales_status ON tempproductlocales (status);
 
CREATE  INDEX productsimilar_productID ON tempproductsimilar (productid);
 
CREATE  INDEX productsimilar_spID ON tempproductsimilar (similarproductid);
 
CREATE  INDEX productsimilar_localeID ON tempproductsimilar (localeid);
 
CREATE  INDEX productskus_productID ON tempproductskus (productid);
 
CREATE  INDEX productskus_localeID ON tempproductskus (localeid);
 
CREATE  INDEX productupsell_productID ON tempproductupsell (productid);
 
CREATE  INDEX productupsell_upsellProductID ON tempproductupsell (upsellproductid);
 
CREATE  INDEX productupsell_localeID ON tempproductupsell (localeid);
 
CREATE  INDEX unitnames_unitID ON tempunitnames (unitid);
 
CREATE  INDEX unitnames_localeID ON tempunitnames (localeid);
 
CREATE  INDEX units_baseUnitID ON tempunits (baseunitid);
 
# Alter table tempsearch_attribute_values ADD CONSTRAINT tempsearch_attribute_values_PK PRIMARY KEY(valueid);
 
# CREATE  INDEX search_attribute_productID ON tempsearch_attribute (productid);
 
# CREATE  INDEX search_attribute_attributeID ON tempsearch_attribute (attributeid);
 
# CREATE  INDEX search_attribute_valueID ON tempsearch_attribute (valueid);
 
# CREATE  INDEX search_attribute_absoluteValue ON tempsearch_attribute (absolutevalue);
 
# Alter table tempsearch_keyword_values ADD CONSTRAINT tempsearch_keyword_values_PK PRIMARY KEY(valueid);

# CREATE  INDEX search_attribute_isAbsolute ON tempsearch_attribute (isabsolute);
 
#CREATE  INDEX search_attribute_localeID ON tempsearch_attribute (localeid);
 
#CREATE  INDEX search_attrval_value ON tempsearch_attribute_values (value);
 
#CREATE  INDEX search_keyword_productID ON tempsearch_keyword (productid);
 
#CREATE  INDEX search_keyword_valueID ON tempsearch_keyword (valueid);
 
#CREATE  INDEX search_keyword_localeID ON tempsearch_keyword (localeid);
 
#CREATE  INDEX search_keyval_value ON tempsearch_keyword_values (value);
 
Alter table tempunits ADD CONSTRAINT tunits_PK PRIMARY KEY(unitid);
