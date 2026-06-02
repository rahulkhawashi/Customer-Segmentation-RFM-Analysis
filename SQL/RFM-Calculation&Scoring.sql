



CREATE OR ALTER VIEW vw_RFM AS
SELECT 
    CustomerID,

    -- Recency: Days since last purchase (using snapshot date 2011-12-09)
    DATEDIFF(DAY, MAX(InvoiceDate), '2011-12-09') AS Recency,

    -- Frequency: Count of unique invoices
    COUNT(DISTINCT InvoiceNo) AS Frequency,

    -- Monetary: Total spent
    SUM(TotalPrice) AS Monetary

FROM vw_CleanedRetail
GROUP BY CustomerID;


select *
from vw_RFM






WITH RankedRFM AS (
    SELECT
        CustomerID,
        Recency,
        Frequency,
        Monetary,

        -- Scoring using NTILE (5 bins)
        NTILE(5) OVER (ORDER BY Recency DESC) AS R_Score,   -- Lower Recency = higher score
        NTILE(5) OVER (ORDER BY Frequency DESC) AS F_Score, -- Higher Frequency = higher score
        NTILE(5) OVER (ORDER BY Monetary asc) AS M_Score   -- Higher Monetary = higher score

    FROM vw_RFM
)
--save result to physical table
select 
    customerid,
    recency,
    frequency,
    monetary ,
    R_Score,
    F_Score,
    M_Score,
    CAST(R_SCORE AS VARCHAR) + CAST(F_Score AS VARCHAR)+CAST(M_Score AS VARCHAR) As RFM_Score --concatinate the score
into RFM_Scored
from RankedRFM ; 




select * from RFM_Scored





select * from RFM_Scored
order by RFM_Score desc





--RFM Score Distribution
SELECT 
    RFM_Score,
    COUNT(*) AS Customers
FROM RFM_Scored
GROUP BY RFM_Score
ORDER BY RFM_Score DESC;




--At-Risk Customers (((Customers likely to churn)))

SELECT 
    count(distinct customerid) 
FROM [dbo].[RFM_Scored]
WHERE Recency > 100

