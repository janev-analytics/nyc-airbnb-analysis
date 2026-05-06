-- ============================================
-- Project: NYC Airbnb Market Analysis
-- Author: Janev
-- Date: May 2026
-- Description: Exploratory Data Analysis
--              Business questions on pricing,
--              room types, and listing activity
-- ============================================


-- == Q1: Average price by borough

SELECT borough,
       ROUND(AVG(price), 2) AS avg_price,
       COUNT(*) AS total_listings
FROM price
GROUP BY borough
ORDER BY avg_price DESC;

-- FINDINGS: Manhattan highest avg price, followed by Brooklyn, 
-- Staten Island and Bronx significantly cheaper 

-- == Q2: Average price by room type, ordered highest to lowest.

SELECT r.room_type,
	   ROUND(AVG(p.price),2) AS avg_price
FROM room_type AS r
JOIN price AS p
ON p.listing_id = r.listing_id
GROUP BY r.room_type
ORDER BY avg_price DESC;

-- FINDINGS: Entire Home/Apt commands 2.4x the price of Private Room
-- Shared Room least profitable room type in isolation
-- Note: Shared rooms appear least profitable in isolation ($53 avg)
-- However, multi-room strategy changes the math:

SELECT r.room_type,
       ROUND(AVG(p.price), 2) AS avg_price,
       ROUND(AVG(p.price) * 3, 2) AS three_room_strategy
FROM room_type AS r
JOIN price AS p ON p.listing_id = r.listing_id
WHERE r.room_type != 'Entire Home/Apt'
GROUP BY r.room_type
ORDER BY avg_price DESC;


-- Multi private room strategy confirmed: 3 private rooms = $245/night
-- Outperforms Entire Home/Apt ($238) - data verified
-- Shared room 3x = $161/night -- does NOT beat Entire Home/Apt



-- == Q3: Which boroughs have the most active listings?

SELECT p.borough,
       COUNT(*) AS active_listings
FROM last_review AS l
JOIN price AS p ON p.listing_id = l.listing_id
WHERE l.last_review BETWEEN '2019-01-01' AND '2019-12-31'
GROUP BY p.borough
ORDER BY active_listings DESC;

-- FINDINGS: Brooklyn most active borough in 2019 (10,466 listings),
-- Manhattan close second (10,322) despite higher prices,
-- Bronx and Staten Island significantly less active 

-- == Q4: Price distribution by borough — MIN, MAX, AVG price per borough.


SELECT borough,
       ROUND(AVG(price), 2) AS avg_price,
	   MIN(price) AS min_price,
	   MAX(price) AS max_price,
       COUNT(*) AS total_listings
FROM price
GROUP BY borough
ORDER BY avg_price DESC;

-- FINDINGS:  Manhattan avg $184, highest in NYC,
-- Brooklyn and Bronx show $0 minimum price -- data quality issue, needs investigation,
-- Manhattan max $5,100 shows high-end luxury listings skewing the average 

SELECT COUNT(*) FROM price WHERE price = 0;

-- 7 listings with $0 price found -- deletion handled in cleaning script



-- == Q5: Top 10 neighbourhoods by number of listings.

SELECT borough,
	   neighbourhood,
	   COUNT(*) AS active_listings
FROM price
GROUP BY neighbourhood, borough
ORDER BY active_listings DESC
LIMIT 10;


-- FINDINGS: Brooklyn dominates top 10 with 4 neighbourhoods
-- Bedford-Stuyvesant most listed neighbourhood in NYC (2,206)
-- Williamsburg second (1,853) -- high demand tourist/young professional area 

-- == Q6: Top 10 neighbourhoods by average price.

SELECT borough,
	   neighbourhood,
	   ROUND(AVG(price),2) AS avg_price
FROM price
GROUP BY neighbourhood, borough
ORDER BY avg_price DESC
LIMIT 10;


-- FINDINGS:  Sea Gate (Brooklyn) anomaly -- $805 avg, likely few high-end listings skewing average
-- Manhattan dominates top 10 with 7 of 10 neighbourhoods
-- Tribeca, Flatiron, NoHo, SoHo confirm Manhattan premium neighbourhoods

-- == Q7: Average price by borough and room type combined.

SELECT p.borough,
	   r.room_type,
       ROUND(AVG(price), 2) AS avg_price
FROM price AS p
JOIN room_type AS r
ON r.listing_id = p.listing_id
GROUP BY borough, r.room_type
ORDER BY avg_price DESC;

-- FINDINGS: Manhattan Entire Home/Apt most profitable at $238/night
-- Brooklyn Entire Home/Apt strong second at $170 -- better value market for investors
-- Manhattan Private Room ($106) competes with outer borough Entire Home/Apt prices
-- Shared rooms lowest return across all boroughs -- least attractive investment type


