-- ============================================
-- Project: NYC Airbnb Market Analysis
-- Author: Janev
-- Date: May 2026
-- Description: Data import and cleaning for
--              NYC Airbnb dataset (Kaggle)
--              Tables: price, last_review, room_type
-- ============================================

DROP TABLE last_review;

CREATE TABLE last_review (
    listing_id TEXT,
    host_name TEXT,
    last_review TEXT
);

COPY last_review (listing_id, host_name, last_review)
FROM 'C:\pgdata\Airbnb Rentals project\airbnb_last_review.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', QUOTE '"', ESCAPE '"');

SELECT COUNT(*) FROM last_review;



-- Data Exploration: Preview first 5 rows of each table

SELECT * FROM price LIMIT 5;
-- Findings: price stored as TEXT ('225 dollars'), needs numeric conversion,
-- nbhood_full is combined neighborhood column (borough and neighbourhood)

SELECT * FROM last_review LIMIT 5;
-- Findings: last_review date stored as TEXT, needs DATE conversion
-- listing_id is TEXT, needs to be INTEGER

SELECT * FROM room_type LIMIT 5;
-- Findings: room_type casing inconsistent, needs standardizing


-- Check for duplicates in room_type
SELECT COUNT(*) - COUNT(DISTINCT listing_id) AS duplicates
FROM room_type;

-- Confirming duplicates: checking which listing_ids appear more than once

SELECT listing_id, COUNT(*) 
FROM room_type 
GROUP BY listing_id 
HAVING COUNT(*) > 1
LIMIT 5;

-- room_type has 25,209 duplicate listing_ids (every listing appears twice)
-- Action needed: remove duplicates during cleaning

-- Converting listing_id in last_review from TEXT to INTEGER
-- Required for joining with price and room_type tables

ALTER TABLE last_review
ALTER COLUMN listing_id TYPE INTEGER
USING listing_id::INTEGER;

-- Convert last_review from TEXT to DATE for time-based analysis

ALTER TABLE last_review
ALTER COLUMN last_review TYPE DATE
USING TO_DATE(last_review, 'Month DD YYYY');


-- Confirming that all data types are correct within last_review table

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'last_review';

-- Convert price from TEXT to NUMERIC by stripping 'dollars' suffix
-- Required for aggregations (AVG, SUM, MIN, MAX)

ALTER TABLE price
ALTER COLUMN price TYPE NUMERIC
USING REPLACE(price, ' dollars', '')::NUMERIC;


-- Confirming that all data types are correct within price table 

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'price';


-- Split nbhood_full into borough and neighbourhood for granular analysis

ALTER TABLE price ADD COLUMN borough TEXT;
ALTER TABLE price ADD COLUMN neighbourhood TEXT;

UPDATE price
SET borough = SPLIT_PART(nbhood_full, ', ', 1),
    neighbourhood = SPLIT_PART(nbhood_full, ', ', 2);

-- Checking the split

SELECT * FROM price LIMIT 5;

-- Drop original combined column now that split is verified

ALTER TABLE price DROP COLUMN nbhood_full;	


-- Standardize room_type casing to title case
UPDATE room_type
SET room_type = INITCAP(room_type);

--Checking the casing

SELECT * FROM room_type LIMIT 5;

-- Remove duplicate listings, keep one row per listing_id

DELETE FROM room_type
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM room_type
    GROUP BY listing_id
);

-- Kept first occurrence of each listing_id using PostgreSQL's internal row identifier (ctid)
-- ctid is unique per row, allowing deletion of duplicates when data columns are identical



SELECT COUNT(*) FROM room_type;

-- Check for NULL values in all tables


SELECT COUNT(*) - COUNT(listing_id) AS listing_id_nulls,
       COUNT(*) - COUNT(price) AS price_nulls,
       COUNT(*) - COUNT(borough) AS borough_nulls,
       COUNT(*) - COUNT(neighbourhood) AS neighbourhood_nulls
FROM price;

SELECT COUNT(*) - COUNT(listing_id) AS listing_id_nulls,
       COUNT(*) - COUNT(host_name) AS host_name_nulls,
       COUNT(*) - COUNT(last_review) AS last_review_nulls
FROM last_review;

SELECT COUNT(*) - COUNT(listing_id) AS listing_id_nulls,
       COUNT(*) - COUNT(description) AS description_nulls,
       COUNT(*) - COUNT(room_type) AS room_type_nulls
FROM room_type;

-- Findings: No NULL values found in any table

-- Final verification: confirm cleaned state of all tables
SELECT * FROM price LIMIT 5;
SELECT * FROM last_review LIMIT 5;
SELECT * FROM room_type LIMIT 5;

-- Data quality issue discovered during EDA
-- 7 listings found with $0 price -- impossible value, Airbnb does not allow free listings
-- Removed during EDA phase

SELECT COUNT(*) FROM price WHERE price = 0;
DELETE FROM price WHERE price = 0;
