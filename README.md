# 🛒 Customer Segmentation Using RFM Analysis

### SQL Server → Power BI | Data Analytics Project

\---

## 👋 About This Project

As a data analyst, one of the most powerful questions a business can ask is:
**"Who are our best customers — and who are we about to lose?"**

That's exactly what this project answers.

I built an end-to-end RFM (Recency, Frequency, Monetary) segmentation system using the **UCI Online Retail Dataset**, writing SQL queries in **Microsoft SQL Server** to score and classify 4,000+ customers, then visualizing the segments in an interactive **Power BI dashboard** — the kind of output a marketing or sales team can actually use to make decisions.

\---

## 🧠 The Business Problem

The marketing team needs to stop treating all customers the same.

Sending the same email campaign to a customer who bought yesterday and one who hasn't purchased in 8 months is wasted budget. This project solves that by answering three core business questions:

* **Recency →** How recently did this customer buy from us?
* **Frequency →** How often do they purchase?
* **Monetary →** How much have they spent in total?

By scoring every customer across these three dimensions, we can segment them into actionable groups — and give the business a clear picture of where to focus retention, re-engagement, and reward efforts.

Q . Find the percentage of custormers can churn

\---

## &#x20;Dataset

|Detail|Info|
|-|-|
|**Source**|[UCI Machine Learning Repository — Online Retail Dataset](https://archive.ics.uci.edu/ml/datasets/Online+Retail)|
|**Records**|\~541,000 transactions|
|**Customers**|\~4,300 unique customers|
|**Period**|Dec 2010 – Dec 2011|
|**Region**|UK-based online retailer|

\---

## &#x20;Tools Used

|Tool|Purpose|
|-|-|
|**MS SQL Server**|Data cleaning, RFM calculation, customer scoring|
|**SQL Server Management Studio (SSMS)**|Query writing and execution|
|**Power BI Desktop**|Dashboard design and visualization|
|**DAX**|Calculated measures in Power BI|
|**GitHub**|Version control and portfolio sharing|

\---

## How It Works — Step by Step

### Step 1 — Data Cleaning in SQL

Removed cancelled orders





### Step 2 — RFM Calculation

Calculated the three core metrics per customer using CTEs and aggregate functions.





### Step 3 — RFM Scoring with NTILE

Scored each customer 1–4 on each dimension using SQL window functions.





### Step 4 — Customer Segmentation

Combined scores into a single RFM string and mapped to human-readable segments.





### Step 5 — Power BI Dashboard

Connected SQL Server output directly to Power BI and built a understandable dashboard.



## 📈 Key Business Insights



After segmenting 4,300+ customers, here's what the data revealed:

* 🏆 **Champions (top \~18%)** accounted for over **60% of total revenue** — a classic 80/20 pattern
* ⚠️ **At-Risk customers (\~36%)** were once high-frequency buyers but haven't purchased in 90+ days — prime candidates for a win-back campaign
* 🌱 **Potential Loyalists (\~20%)** bought recently but infrequently — a targeted loyalty offer could convert them into Champions

**Bottom line:** The marketing team can now send different campaigns to different segments instead of one-size-fits-all blasts — directly impacting retention and revenue.

\---

## 📊 Power BI Dashboard Preview

This dashboard provides a comprehensive overview of the online retail business by visualizing key performance indicators and sales patterns.



It highlights total revenue, regional performance, product demand, and customer purchasing behavior in a clear and interactive format.



🔍 Dashboard Insights

Total Revenue:

Displays overall revenue (\~9M), giving a quick snapshot of business performance.



Revenue by Country:

A horizontal bar chart shows country-wise revenue distribution, with the United Kingdom as the dominant market, followed by other European countries.



Revenue Trend (Monthly):

A line chart illustrates revenue fluctuations across months, helping identify growth patterns and seasonal peaks.



Sales by Time of Day:

An area chart represents average product sales across different hours, highlighting peak purchasing time during mid-day hours.



Top Selling Products:

A bar chart showcases bestselling products, helping identify high-demand items contributing most to sales.





The dashboard is designed to:



Monitor overall business performance

Identify top-performing regions and products

Understand customer buying patterns

Support data-driven decision-making



## &#x20;

&#x20;What I Learned

* How to translate a **business problem into SQL logic** — not just write queries for the sake of it
* The importance of **data cleaning before analysis** — over 20% of raw records were unusable
* How **window functions (NTILE)** create fair, percentile-based scoring at scale
* How to connect **SQL Server directly to Power BI** for a live, refreshable pipeline
* That the most impactful insight isn't the query — it's the **business decision it enables**

\---

## 🔗 References

* Dataset: [UCI Online Retail Dataset](https://archive.ics.uci.edu/ml/datasets/Online+Retail)





## 🙋 About Me

**\[Rahul Khawshi]**
Aspiring Data Analyst | SQL • Power BI • Excel • Python

📧 \[khawashirahul@gmail.com]
💼 \[linkedin.com/in/rahul-khawshi-514b83278/]
🐙 \[github.com/rahulkhawashi]



