--CREATING TABLE
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
SELECT * FROM BIGBASKET;

--Q1.TOP PRODUCTS BASED ON RATING AND SALES
     --Write a query to find the top 10 products with the 
     --highest average rating, along with their sale price, market price, and discount percentage.
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

--Q2.Category-Wise Discount Analysis
     --Use aggregation functions to calculate the average discount percentage by category and brand, 
	 --and identify the categories with the highest discounts.
SELECT 
    category,
	brand,
	AVG((market_price-sale_price)/(market_price) *100) as avg_discount_percentage
FROM BIGBASKET
GROUP BY category ,brand
ORDER BY avg_discount_percentage DESC;

--Q3. Price vs Rating Correlation
      --Write a query that compares the sale price and ratings for products, 
	  --possibly grouped by price range, to analyze if there's any trend.
SELECT 
	sale_price,
	rating
FROM BIGBASKET
WHERE rating IS NOT NULL AND sale_price IS NOT NULL
ORDER BY sale_price;

--Q4.Top Selling Brands and Products
     --  Identify the top-selling brands and calculate their total revenue based on sale prices..
SELECT
     brand,
     COUNT(product) AS total_products_sold,
	 SUM(sale_price) AS total_revenue
FROM BIGBASKET
WHERE product IS NOT NULL AND brand IS NOT NULL AND rating IS NOT NULL
GROUP BY brand
ORDER BY total_revenue DESC;

--Q5.Sub-Category Wise Performance
     --Aggregate products by subcategory, 
	 --calculate the average sale price, market price, and discount percentage for each subcategory.
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

--Q6.Most Discounted Products
     --Create a query that ranks products based on the highest discount percentage, 
	 --showing product names, discount, and sale prices.
SELECT 
   product,
   sale_price,
   (market_price-sale_price)/(market_price)*100 AS highest_discount_percentage
FROM BIGBASKET
ORDER BY highest_discount_percentage DESC;

--Q7.Impact of Ratings on Sale Price
     --Study whether products with higher ratings tend to be priced higher
SELECT 
    product , rating , sale_price
FROM BIGBASKET
WHERE product IS NOT NULL AND rating IS NOT NULL AND sale_price IS NOT NULL AND rating >=4.5
--ORDER BY rating DESC
ORDER BY sale_price DESC;

--Q8.Discount and Rating Correlation
     --Investigate the relationship between discount percentages and product ratings.
SELECT
    rating,
	(market_price-sale_price)/(market_price) *100 AS discount_percentages
FROM BIGBASKET
WHERE rating IS NOT NULL
ORDER BY rating DESC , discount_percentages DESC;

--Q9.Customer Segmentation Based on Product Preferences
   --Use SQL queries to segment products by rating ranges and price brackets, 
   --and analyze how each segment performs in terms of sales.
SELECT 
     product , rating , MAX(sale_price) as maximum_saleprice
FROM BIGBASKET
WHERE rating IS NOT NULL
GROUP BY product , rating
ORDER BY rating DESC , maximum_saleprice DESC;

--Q10.Product Demand Insights
     -- on the basis of rating , analyse which product is in more demand
SELECT product , rating
FROM BIGBASKET 
WHERE rating IS NOT NULL
ORDER BY rating DESC
LIMIT 10;

--Q11.Brand Performance Comparison
      --Which brand offers the best value for money based on the difference between market price and sale price, 
	  --factoring in customer ratings?
SELECT 
    brand,
	MIN(market_price - sale_price) AS value_for_money,
	rating
FROM BIGBASKET
WHERE rating IS NOT NULL
GROUP BY brand , rating 
ORDER BY value_for_money DESC;

--Q12.Impact of Description Length on Sales
      --Does a longer product description correlate with better sales or higher ratings?
SELECT 
    LENGTH(description) as length_of_description, 
	rating,
	product,
	(market_price - sale_price)/(market_price)*100 AS discount_percent
FROM BIGBASKET
WHERE LENGTH(description) IS NOT NULL AND rating IS NOT NULL
ORDER BY length_of_description DESC;

--Q13.Discount and Rating Correlation
      --Is there a trend where products with higher discounts tend to have higher ratings? 
	  --Or do customers prefer products with smaller discounts?
SELECT 
    (market_price - sale_price) / market_price * 100 AS discount_percentage,
    AVG(rating) AS avg_rating,
    COUNT(*) AS product_count
FROM BIGBASKET
WHERE rating IS NOT NULL AND market_price > 0
GROUP BY discount_percentage
ORDER BY discount_percentage DESC;

--Q14.Price Range and Rating Distribution
      --How do ratings and prices distribute across different price ranges? 
	  --Do products in higher price ranges tend to have lower ratings?
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

--Q15.Category-Wise Rating Analysis
      --Which categories have the highest average ratings, and which have the most variation in ratings?
SELECT 
    category,
    AVG(rating) AS avg_rating,
    STDDEV(rating) AS rating_variability,
    COUNT(*) AS product_count
FROM BIGBASKET
WHERE rating IS NOT NULL
GROUP BY category
ORDER BY avg_rating DESC, rating_variability DESC;


	