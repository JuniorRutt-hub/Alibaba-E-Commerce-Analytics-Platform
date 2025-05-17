-- Create database
CREATE DATABASE IF NOT EXISTS alibaba_analysis;
USE alibaba_analysis;

-- Shop dimension table
CREATE TABLE shops (
    shop_id BIGINT PRIMARY KEY,
    shop_review_num_level INT,
    shop_review_positive_rate DECIMAL(5,4),
    shop_star_level INT,
    shop_score_service DECIMAL(5,4),
    shop_score_delivery DECIMAL(5,4),
    shop_score_description DECIMAL(5,4),
    INDEX idx_shop_star (shop_star_level)
);

-- User dimension table
CREATE TABLE users (
    user_id BIGINT PRIMARY KEY,
    user_gender_id TINYINT,
    user_age_level INT,
    user_occupation_id INT,
    user_star_level INT,
    INDEX idx_user_gender (user_gender_id),
    INDEX idx_user_age (user_age_level)
);

-- Item dimension table
CREATE TABLE items (
    item_id BIGINT PRIMARY KEY,
    item_category_list TEXT,
    item_property_list TEXT,
    item_brand_id BIGINT,
    item_city_id BIGINT,
    item_price_level INT,
    item_sales_level INT,
    item_collected_level INT,
    item_pv_level INT,
    INDEX idx_brand (item_brand_id),
    INDEX idx_city (item_city_id)
);

-- Context dimension table
CREATE TABLE contexts (
    context_id BIGINT PRIMARY KEY,
    context_timestamp INT,
    context_page_id INT,
    predict_category_property TEXT,
    INDEX idx_timestamp (context_timestamp)
);

-- Fact table for clicked samples
CREATE TABLE clicked_samples (
    instance_id BIGINT PRIMARY KEY,
    is_trade TINYINT,
    item_id BIGINT,
    user_id BIGINT,
    context_id BIGINT,
    shop_id BIGINT,
    INDEX idx_is_trade (is_trade)
);


SET GLOBAL local_infile=1;
USE alibaba_analysis;
-- Load data from CSV files
LOAD DATA LOCAL INFILE '/Users/SWRF/Desktop/ISOM 671 Managing Big Data/final_project/shop_table.csv'
INTO TABLE shops
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/SWRF/Desktop/ISOM 671 Managing Big Data/final_project/user_table.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/SWRF/Desktop/ISOM 671 Managing Big Data/final_project/advertising_item.csv'
INTO TABLE items
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/SWRF/Desktop/ISOM 671 Managing Big Data/final_project/context_table.csv'
INTO TABLE contexts
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE '/Users/SWRF/Desktop/ISOM 671 Managing Big Data/final_project/clicked_sample.csv'
INTO TABLE clicked_samples
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
-- Add foreign key constraints
ALTER TABLE clicked_samples
ADD FOREIGN KEY (item_id) REFERENCES items(item_id),
ADD FOREIGN KEY (user_id) REFERENCES users(user_id),
ADD FOREIGN KEY (context_id) REFERENCES contexts(context_id),
ADD FOREIGN KEY (shop_id) REFERENCES shops(shop_id);

