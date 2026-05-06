# NYC Airbnb Market Analysis

## Overview
Analysis of the NYC Airbnb market using PostgreSQL to identify pricing patterns, 
neighbourhood demand, and investment opportunities across New York City boroughs.

## Dataset
- Source: Kaggle — - Source: [NYC Airbnb Market — Kaggle](https://www.kaggle.com/datasets/ebrahimelgazar/new-york-city-airbnb-market)
- Tables: price, last_review, room_type
- 25,209 listings after cleaning

## Tools
- PostgreSQL 18
- pgAdmin 4

## Project Structure
- `nyc_airbnb_cleaning.sql` — data import, type conversion, deduplication, null checks
- `nyc_airbnb_eda.sql` — exploratory analysis answering 7 business questions

## Key Findings
- Manhattan has the highest average price ($184/night)
- Brooklyn has the most active listings despite lower prices
- Entire Home/Apt earns 2.4x more than Private Room on average
- Multi private room strategy (3 rooms) generates ~$245/night — outperforms Entire Home/Apt
- Bedford-Stuyvesant and Williamsburg are the most listed neighbourhoods in NYC

## Business Questions Answered
1. Which boroughs have the highest average prices?
2. Which room types are most profitable?
3. Which boroughs have the most active listings?
4. What is the price distribution across boroughs?
5. Which neighbourhoods have the most listings?
6. Which neighbourhoods command the highest prices?
7. How does price vary by borough and room type combined?

## Limitations

Data sourced from 2019, pre-COVID. NYC short-term rental market has changed significantly since — results reflect pre-pandemic conditions and should not be used for current investment decisions.

## Data Quality Notes

Sea Gate (Brooklyn) shows an anomaly — $805 average price. Follow-up query confirmed only a small number of listings in this neighbourhood, meaning a few high-priced listings skew the average significantly. Neighbourhoods with fewer than 20 listings were not excluded from analysis but should be interpreted with caution.

## Next Steps

With Python and visualization tools, this analysis could be extended to include:
- Geographic price mapping by neighbourhood
- Time series analysis of listing activity
- Predictive pricing models based on room type, borough, and amenities
