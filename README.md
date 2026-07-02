<div align="center">

# 🎯 Customer Segmentation using RFM Analysis
### *Turning raw transactions into a boardroom-ready customer strategy — powered entirely by T-SQL*

[![SQL Server](https://img.shields.io/badge/Microsoft%20SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)](https://www.microsoft.com/en-us/sql-server)
[![T-SQL](https://img.shields.io/badge/T--SQL-Advanced-blue?style=for-the-badge)](#-the-sql-engine-room)
[![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)](#)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)](#-license)

**[📊 Explore the Queries](#-the-sql-engine-room) · [🧩 Segments](#-meet-your-customer-segments) · [💼 Business Impact](#-why-a-client-would-care) · [🚀 Run It Yourself](#-run-it-yourself)**

</div>

---

## 📌 The Business Problem

> *"We have thousands of customers. We're spending the same marketing budget on all of them. Some are about to leave us — and we don't know who."*

That's the brief this project answers. Instead of treating every customer the same, this repository uses **RFM Analysis (Recency, Frequency, Monetary)** — a battle-tested, Pareto-principle-backed segmentation technique — to answer three questions every client actually cares about:

| Client Question | RFM Metric | What It Reveals |
|---|---|---|
| 🕒 "Are we losing them?" | **Recency** | Days since their last purchase |
| 🔁 "How loyal are they?" | **Frequency** | How often they buy from us |
| 💰 "How much are they worth?" | **Monetary** | Total revenue they've generated |

The output isn't a chart nobody reads — it's a **segment label per customer** (`Champions`, `At Risk`, `Lost`, `Loyal`, etc.) that a marketing team can plug straight into a campaign tool tomorrow morning.

---

## 🧠 Why RFM? (The 80/20 Rule, in Data Form)

RFM is built on the Pareto principle: **roughly 80% of revenue tends to come from ~20% of customers.** Blasting the same email to everyone wastes budget on customers who were never going to convert, and — worse — ignores the high-value customers quietly drifting away.

This project scores **every customer on all three dimensions simultaneously**, using SQL Server's `NTILE()` window function to bucket customers into quintiles — no external BI tool, no Python, no black box. Just clean, auditable, production-style T-SQL that any data/BI team can drop straight into a SQL Server environment.

---

## 🗺️ Solution Architecture

```
                    ┌─────────────────────┐
                    │   Raw Sales Table    │
                    │ (Orders / Invoices)  │
                    └──────────┬──────────┘
                               │
                     ① Data Cleaning & Validation
                     (nulls, cancellations, negative qty)
                               │
                    ┌──────────▼──────────┐
                    │   Base RFM Metrics   │
                    │  Recency | Frequency │
                    │       | Monetary     │
                    └──────────┬──────────┘
                               │
                    ② NTILE(5) Scoring per Metric
                               │
                    ┌──────────▼──────────┐
                    │   RFM Score String   │
                    │     e.g. "5-4-5"     │
                    └──────────┬──────────┘
                               │
                    ③ CASE-based Segment Mapping
                               │
                    ┌──────────▼──────────┐
                    │  Business Segments   │
                    │ Champions, At Risk,  │
                    │   Loyal, Lost, etc.  │
                    └──────────┬──────────┘
                               │
                    ④ Actionable Marketing Output
                    (export → CRM / email tool)
```

---

## 🛠️ The SQL Engine Room

All logic lives in **Microsoft SQL Server (T-SQL)** — CTEs, window functions, and `CASE` expressions doing the heavy lifting that would otherwise need a whole ML pipeline.

<details>
<summary><b>① Base Metrics — Recency, Frequency, Monetary per customer</b> (click to expand)</summary>

```sql
-- Step 1: Calculate raw RFM metrics for each customer
WITH CustomerBase AS (
    SELECT
        CustomerID,
        MAX(OrderDate)                         AS LastPurchaseDate,
        COUNT(DISTINCT OrderID)                AS Frequency,
        SUM(Quantity * UnitPrice)              AS Monetary
    FROM dbo.Sales
    WHERE Quantity > 0                         -- exclude returns
      AND CustomerID IS NOT NULL               -- exclude guest/anonymous orders
    GROUP BY CustomerID
),
CustomerRFM AS (
    SELECT
        CustomerID,
        DATEDIFF(DAY, LastPurchaseDate, GETDATE()) AS Recency,
        Frequency,
        Monetary
    FROM CustomerBase
)
SELECT * FROM CustomerRFM;
```

**Client translation:** *"This tells us, for every single customer, how long ago they last bought something, how many times they've bought from us, and how much money they've handed us in total."*

</details>

<details>
<summary><b>② Quintile Scoring — ranking customers 1 (worst) to 5 (best)</b></summary>

```sql
-- Step 2: Score each metric into quintiles using NTILE()
-- Note: Recency is scored in REVERSE — fewer days = better = higher score
WITH CustomerScores AS (
    SELECT
        CustomerID,
        Recency,
        Frequency,
        Monetary,
        NTILE(5) OVER (ORDER BY Recency DESC)   AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency ASC)  AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary ASC)   AS M_Score
    FROM CustomerRFM
)
SELECT
    CustomerID,
    R_Score, F_Score, M_Score,
    CAST(R_Score AS VARCHAR) + CAST(F_Score AS VARCHAR) + CAST(M_Score AS VARCHAR) AS RFM_Cell
FROM CustomerScores;
```

**Client translation:** *"Every customer now gets a score out of 5 on each dimension — like a report card: Recency, Frequency, Monetary."*

</details>

<details>
<summary><b>③ Segment Mapping — turning scores into a language marketing understands</b></summary>

```sql
-- Step 3: Translate RFM scores into human-readable business segments
SELECT
    CustomerID,
    R_Score, F_Score, M_Score,
    (R_Score + F_Score + M_Score) AS RFM_Total,
    CASE
        WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions'
        WHEN R_Score >= 4 AND F_Score >= 3                  THEN 'Loyal Customers'
        WHEN R_Score >= 4 AND F_Score <= 2                  THEN 'New Customers'
        WHEN R_Score = 3 AND F_Score >= 3                   THEN 'Potential Loyalists'
        WHEN R_Score <= 2 AND F_Score >= 4 AND M_Score >= 4  THEN 'At Risk'
        WHEN R_Score <= 2 AND F_Score >= 3                  THEN 'Cannot Lose Them'
        WHEN R_Score = 2 AND F_Score <= 2                   THEN 'About to Sleep'
        WHEN R_Score = 1 AND F_Score <= 2                   THEN 'Lost'
        ELSE 'Needs Attention'
    END AS CustomerSegment
FROM CustomerScores
ORDER BY RFM_Total DESC;
```

**Client translation:** *"This is the deliverable — a single label per customer that your marketing team can act on today."*

</details>

<details>
<summary><b>④ Business Reporting Queries — the questions stakeholders actually ask</b></summary>

```sql
-- 4a. How much revenue sits in each segment? (Where's the 80/20 split?)
SELECT
    CustomerSegment,
    COUNT(*)                       AS CustomerCount,
    SUM(Monetary)                  AS TotalRevenue,
    ROUND(AVG(Monetary), 2)        AS AvgSpendPerCustomer,
    ROUND(100.0 * SUM(Monetary) / SUM(SUM(Monetary)) OVER (), 1) AS PctOfTotalRevenue
FROM dbo.CustomerSegments
GROUP BY CustomerSegment
ORDER BY TotalRevenue DESC;

-- 4b. Who are our top 20 highest-value "Champions"? (VIP list for account managers)
SELECT TOP 20
    CustomerID, Monetary, Frequency, Recency, CustomerSegment
FROM dbo.CustomerSegments
WHERE CustomerSegment = 'Champions'
ORDER BY Monetary DESC;

-- 4c. Which customers are "At Risk" and worth a win-back campaign?
SELECT
    CustomerID, Recency, Frequency, Monetary
FROM dbo.CustomerSegments
WHERE CustomerSegment IN ('At Risk', 'Cannot Lose Them')
ORDER BY Monetary DESC;

-- 4d. Month-over-month tracking: is our churn segment growing or shrinking?
SELECT
    FORMAT(GETDATE(), 'yyyy-MM')   AS SnapshotMonth,
    CustomerSegment,
    COUNT(*)                       AS CustomerCount
FROM dbo.CustomerSegments
GROUP BY CustomerSegment;
```

**Client translation:** *"These are the exact numbers you'd put in a monthly retention report or hand to the marketing team as a target list."*

</details>

---

## 🧩 Meet Your Customer Segments

<div align="center">

| Segment | 🕒 R | 🔁 F | 💰 M | Business Meaning | Recommended Action |
|:---:|:---:|:---:|:---:|---|---|
| 🏆 **Champions** | High | High | High | Your best, most loyal, highest-spending customers | Reward, upsell, ask for referrals/reviews |
| 💎 **Loyal Customers** | High | High | Mid | Buy often and recently, room to grow spend | Cross-sell, loyalty perks |
| 🌱 **Potential Loyalists** | Mid | Mid | Mid | Recent buyers, building a habit | Personalized offers to nudge frequency |
| 🆕 **New Customers** | High | Low | Any | Just made their first purchase(s) | Onboarding journey, welcome discount |
| ⚠️ **At Risk** | Low | High | High | Used to be great, now going quiet | Urgent, personal win-back outreach |
| 🚨 **Cannot Lose Them** | Low | High | High | Big spenders about to churn | VIP retention offer, personal call |
| 😴 **About to Sleep** | Low | Low | Low | Fading engagement | Reactivation email / limited-time offer |
| 👻 **Lost** | Very Low | Very Low | Low | Haven't purchased in a long time | Low-cost re-engagement or deprioritize |

</div>

---

## 💼 Why a Client Would Care

This isn't an academic exercise — it directly answers three things every business stakeholder asks a data team:

- **"Where should we spend our marketing budget?"** → Segment revenue contribution query shows exactly which 20% of customers drive 80% of revenue.
- **"Who's about to leave us?"** → The `At Risk` / `Cannot Lose Them` segments are a ready-made target list for a retention campaign.
- **"Is our customer base healthy?"** → Tracking segment sizes over time reveals whether the business is gaining Champions or bleeding customers into `Lost`.

Because it's built in **native T-SQL**, this logic can be scheduled as a SQL Agent job, wrapped in a stored procedure, and refreshed nightly/weekly — feeding straight into Power BI, Tableau, or a CRM export, with zero external dependencies.

---

## 🚀 Run It Yourself

```bash
# 1. Clone the repository
git clone https://github.com/rahulkhawashi/Customer-Segmentation-RFM-Analysis.git

# 2. Open the .sql script(s) in SQL Server Management Studio (SSMS) or Azure Data Studio
# 3. Point the queries at your Sales/Orders table (update table & column names if needed)
# 4. Run scripts sequentially: Base Metrics → Scoring → Segmentation → Reporting
```

**Requirements:** Microsoft SQL Server 2016+ (for `NTILE()` / window function support) · SSMS or Azure Data Studio

---

## 📂 Repository Structure

```
Customer-Segmentation-RFM-Analysis/
│
├── 📜 RFM_Analysis.sql        # Core T-SQL script: metrics → scoring → segmentation
├── 📊 Business_Reports.sql    # Stakeholder-ready reporting queries
└── 📄 README.md               # You are here
```

---

## 🧗 What This Project Demonstrates

- ✅ Advanced **T-SQL**: CTEs, window functions (`NTILE`, `OVER`), `CASE` logic, aggregate reporting
- ✅ Translating a **business problem** (customer retention) into a **data solution**
- ✅ Writing SQL that's **client-readable** — segment names, not just numbers
- ✅ Building analysis that plugs directly into a **marketing/CRM workflow**

---

## 🤝 Let's Connect

<div align="center">

[![GitHub](https://img.shields.io/badge/GitHub-rahulkhawashi-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/rahulkhawashi)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Rahul%20Khawashi-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/rahulkhawshi)
[![LeetCode](https://img.shields.io/badge/LeetCode-rahulkhawashi28-FFA116?style=for-the-badge&logo=leetcode&logoColor=white)](https://leetcode.com/u/rahulkhawashi28/)

*If this project helped you understand RFM segmentation in SQL Server, consider giving it a ⭐!*

</div>

---

## 📄 License

This project is open-sourced for learning and portfolio purposes. Feel free to fork, adapt, and build on it.
