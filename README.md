# Big-Basket Data Analysis Using SQL
![BIGBASKET](https://github.com/Kanan-Shah/Big-Basket-Data-Analysis-Using-SQL/blob/main/bigbasket.jpeg)
## Project Overview
This project focuses on analyzing the Big Basket dataset, which includes various attributes related to products sold on an e-commerce platform. 
The dataset offers a wealth of information about product categories, pricing, brands, ratings, discounts, and more. 
The goal of this project is to leverage SQL to extract valuable insights, perform data analysis, and visualize key trends from the dataset.
## Objective
The objective of this project is to utilize SQL queries to:

**Analyze Pricing and Discounts:** Explore how products are priced and analyze the discount percentages based on market and sale prices.

**Examine Rating Patterns:** Investigate how product ratings relate to factors like pricing, category, and brand.

**Evaluate Brand and Category Performance:** Compare the performance of products from different brands and categories based on sale prices, discounts, and ratings.

**Derive Business Insights:** Help businesses understand which product categories, brands, or price ranges are performing the best and where discounts have the greatest impact.

**Optimize Pricing Strategies:** Provide insights that can assist in making data-driven decisions for pricing strategies, product placements, and marketing efforts.

By achieving these objectives, this project aims to provide actionable insights that can improve decision-making and strategy formulation for e-commerce businesses.
## Dataset Description

The dataset contains the following columns:

1.index: A unique identifier for each row (serial number).

2.product: The name of the product as listed on the site.

3.category: The broader classification to which the product belongs.

4.sub_category: A more specific classification within the category.

5.brand: The brand of the product.

6.sale_price: The price at which the product is being sold.

7.market_price: The original market price of the product.

8.type: The type of product (e.g., new, refurbished).

9.rating: The average rating provided by consumers.

10.description: Detailed description of the product.

[DATASET LINK](https://www.kaggle.com/datasets/surajjha101/bigbasket-entire-product-list-28k-datapoints)
## Key Features of the Project

**Data Exploration:** Understanding the relationships between various product attributes such as pricing, ratings, discounts, and categories.

**SQL Queries:** Writing complex SQL queries to analyze the data, extract insights, and perform aggregations, filtering, and sorting.

**Discount Analysis:** Creating a new feature (discount percentage) to understand how much consumers are saving on each product.

**Category and Brand Performance:** Analyzing how products in different categories and brands perform based on ratings, pricing, and discounts.

**Rating and Price Correlation:** Studying the relationship between product prices and their ratings to determine if higher-priced products tend to have better ratings.

**Market Insights:** Drawing conclusions that can help businesses optimize pricing strategies and marketing efforts.
## Conclusion
In this project, we analyzed the Big Basket dataset using SQL to gain insights into the e-commerce product landscape. 
By performing various data analysis tasks, we were able to uncover several key trends and patterns that can influence business strategies, pricing models, and marketing efforts.


## Schema

```sql
CREATE TABLE BIGBASKET(
     index INT,
	 product VARCHAR(255),
	 category VARCHAR(255),
	 sub_category VARCHAR(255),
	 brand VARCHAR(255),
	 sale_price FLOAT,
	 market_price FLOAT,
	 type VARCHAR(255),
	 rating FLOAT,
	 description VARCHAR(5000)
);
```

## Problems and Solutions

### 1. TOP PRODUCTS BASED ON RATING AND SALES

```sql
SELECT 
    product,
	sale_price,
	market_price,
	rating,
	(market_price-sale_price)/(market_price) * 100 as discount_percentage
FROM BIGBASKET
WHERE rating IS NOT NULL
ORDER BY rating DESC
LIMIT 10;
```



### 2. Category-Wise Discount Analysis

```sql
SELECT 
    category,
	brand,
	AVG((market_price-sale_price)/(market_price) *100) as avg_discount_percentage
FROM BIGBASKET
GROUP BY category ,brand
ORDER BY avg_discount_percentage DESC;
```



### 3. Price vs Rating Correlation

```sql
SELECT 
	sale_price,
	rating
FROM BIGBASKET
WHERE rating IS NOT NULL AND sale_price IS NOT NULL
ORDER BY sale_price;
```



### 4. Top Selling Brands and Products

```sql
SELECT
     brand,
     COUNT(product) AS total_products_sold,
	 SUM(sale_price) AS total_revenue
FROM BIGBASKET
WHERE product IS NOT NULL AND brand IS NOT NULL AND rating IS NOT NULL
GROUP BY brand
ORDER BY total_revenue DESC;
```



### 5. Sub-Category Wise Performance

```sql
SELECT
    product,
	sub_category,
	AVG(sale_price) AS avg_revenue , 
	AVG(market_price) AS avg_market_price,
	AVG((market_price-sale_price)/(market_price)*100) AS avg_discount_percentage
FROM BIGBASKET
WHERE product IS NOT NULL AND sub_category IS NOT NULL AND sale_price IS NOT NULL AND market_price IS NOT NULL 
GROUP BY product,sub_category
ORDER BY avg_discount_percentage DESC;
```



### 6. Most Discounted Products

```sql
SELECT 
   product,
   sale_price,
   (market_price-sale_price)/(market_price)*100 AS highest_discount_percentage
FROM BIGBASKET
ORDER BY highest_discount_percentage DESC;
```



### 7. Impact of Ratings on Sale Price

```sql
SELECT 
    product , rating , sale_price
FROM BIGBASKET
WHERE product IS NOT NULL AND rating IS NOT NULL AND sale_price IS NOT NULL AND rating >=4.5
--ORDER BY rating DESC
ORDER BY sale_price DESC;
```



### 8. Discount and Rating Correlation

```sql
SELECT
    rating,
	(market_price-sale_price)/(market_price) *100 AS discount_percentages
FROM BIGBASKET
WHERE rating IS NOT NULL
ORDER BY rating DESC , discount_percentages DESC;
```



### 9. Customer Segmentation Based on Product Preferences

```sql
SELECT 
     product , rating , MAX(sale_price) as maximum_saleprice
FROM BIGBASKET
WHERE rating IS NOT NULL
GROUP BY product , rating
ORDER BY rating DESC , maximum_saleprice DESC;
```


### 10.Product Demand Insights

```sql
SELECT product , rating
FROM BIGBASKET 
WHERE rating IS NOT NULL
ORDER BY rating DESC
LIMIT 10;
```



### 11. Brand Performance Comparison

```sql
SELECT 
    brand,
	MIN(market_price - sale_price) AS value_for_money,
	rating
FROM BIGBASKET
WHERE rating IS NOT NULL
GROUP BY brand , rating 
ORDER BY value_for_money DESC;
```



### 12. Impact of Description Length on Sales

```sql
SELECT 
    LENGTH(description) as length_of_description, 
	rating,
	product,
	(market_price - sale_price)/(market_price)*100 AS discount_percent
FROM BIGBASKET
WHERE LENGTH(description) IS NOT NULL AND rating IS NOT NULL
ORDER BY length_of_description DESC;
```



### 13. Discount and Rating Correlation

```sql
SELECT 
    (market_price - sale_price) / market_price * 100 AS discount_percentage,
    AVG(rating) AS avg_rating,
    COUNT(*) AS product_count
FROM BIGBASKET
WHERE rating IS NOT NULL AND market_price > 0
GROUP BY discount_percentage
ORDER BY discount_percentage DESC;
```



### 14. Price Range and Rating Distribution

```sql
SELECT 
    price_bracket,
    AVG(rating) AS avg_rating,
    COUNT(*) AS product_count,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
FROM (
    SELECT 
        CASE 
            WHEN sale_price < 100 THEN 'Under 100'
            WHEN sale_price BETWEEN 100 AND 500 THEN '100-500'
            WHEN sale_price BETWEEN 500 AND 1000 THEN '500-1000'
            WHEN sale_price > 1000 THEN 'Above 1000'
        END AS price_bracket,
        rating
    FROM BIGBASKET
    WHERE sale_price > 0 AND rating IS NOT NULL
) AS price_brackets
GROUP BY price_bracket
ORDER BY 
    CASE 
        WHEN price_bracket = 'Under 100' THEN 1
        WHEN price_bracket = '100-500' THEN 2
        WHEN price_bracket = '500-1000' THEN 3
        WHEN price_bracket = 'Above 1000' THEN 4
    END;
```



### 15. Category-Wise Rating Analysis

```sql
SELECT 
    category,
    AVG(rating) AS avg_rating,
    STDDEV(rating) AS rating_variability,
    COUNT(*) AS product_count
FROM BIGBASKET
WHERE rating IS NOT NULL
GROUP BY category
ORDER BY avg_rating DESC, rating_variability DESC;
```
