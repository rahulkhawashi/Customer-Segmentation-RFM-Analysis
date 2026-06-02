use [online_retail]


--create cleaned view
CREATE OR ALTER VIEW vw_CleanedRetail AS
SELECT
    InvoiceNo,
    StockCode,
    Description,
    TRY_CAST(Quantity AS FLOAT) AS Quantity,
    InvoiceDate,
    TRY_CAST(UnitPrice AS FLOAT) AS UnitPrice,
    CustomerID,
    Country,
    TRY_CAST(Quantity AS FLOAT) * TRY_CAST(UnitPrice AS FLOAT) AS TotalPrice
FROM
    [dbo].[online_retail]
WHERE
    CustomerID IS NOT NULL
    AND InvoiceNo NOT LIKE 'C%'
    AND ISNUMERIC(Quantity) = 1
    AND ISNUMERIC(UnitPrice) = 1;

SELECT * 
FROM vw_CleanedRetail





SELECT top 100 *  FROM vw_CleanedRetail

--what is the overall revenue in the dataset ? 

select sum(TotalPrice) as Total_revenue
	FROM vw_CleanedRetail


-- which country generates the most revenue 

select
    country,
    sum(TotalPrice) as revenue 
from vw_CleanedRetail
group by country
order by  sum(TotalPrice) desc



--total customers 
select 
       count(distinct customerID) as total_customers 
from vw_CleanedRetail


-- who are your highest value customers ? top 10 customers by total spend 

select top 10  customerID, sum(TotalPrice) as Total_Spend
from vw_CleanedRetail
group by customerID
order by Total_Spend desc


-- monthly revenue trendds insight : Are there seasonal patterns or growth over time ? 
select 
	format(invoicedate,'yyyy-mm') as Month,
	sum(TotalPrice) as Revenue
from vw_CleanedRetail
group by format(invoicedate,'yyyy-mm')
order by month

-- most purchased products insight: Which products are the best sellers ? 
select 
	description,
	sum(quantity) as best_sellers
from vw_CleanedRetail
group by description 
order by best_sellers desc


--order by time 0f day insight : when do customer shop most (morning or evening) ? 
select 
	datepart(Hour,  Invoicedate) as TimeOfDay,
	count(distinct(invoiceNO)) as orders
from vw_CleanedRetail
group by datepart(Hour,  Invoicedate)
order by orders desc




--Are customers buying multiple items?
--avrage basket size


SELECT 
    AVG(ItemCount) AS AvgBasketSize
FROM (
    SELECT InvoiceNo, COUNT(*) AS ItemCount
    FROM [dbo].[Online_Retail]
    GROUP BY InvoiceNo
) t;


--Cohort Analysis (Retention)
SELECT 
    CustomerID,
    cast(MIN(InvoiceDate) as date) AS FirstPurchaseDate
FROM [dbo].[Online_Retail]
GROUP BY CustomerID;



-- Revenue Growth Rate (MoM)
SELECT 
    FORMAT(InvoiceDate, 'yyyy-MM') AS Month,
    SUM(Quantity * UnitPrice) AS Revenue
FROM [dbo].[Online_Retail]
GROUP BY FORMAT(InvoiceDate, 'yyyy-MM')
ORDER BY Month;

--avg order value by country
SELECT 
    Country,
    AVG(OrderValue) AS AvgOrderValue
FROM (
    SELECT 
        InvoiceNo,
        Country,
        SUM(Quantity * UnitPrice) AS OrderValue
    FROM [dbo].[Online_Retail]
    WHERE Quantity > 0
    GROUP BY InvoiceNo, Country
) t
GROUP BY Country
order by AvgOrderValue desc




