# DataAnalytics-Assessment

This repository contains solutions to a SQL Proficiency Assessment focused on solving business problems using structured queries across a relational database.

## Question Explanations

---

### Question 1: High-Value Customers with Multiple Products

**Goal:** Identify customers who have both a savings and an investment plan.

**Approach:**
- Joined `users_customuser` with both `savings_savingsaccount` and `plans_plan`.
- Filtered:
  - Savings plans where `is_regular_savings = 1`
  - Investment plans where `is_a_fund = 1`
  - Only include funded plans using `status_id = 1`
  - Aggregated:
    - `savings_count`, `investment_count`
    - `total_deposits` using `confirmed_amount`(convert from kobo to naira).  
- Grouped by customer ID and name.
- Ordered by `total_deposits` in descending order

---

###  Question 2: Transaction Frequency Analysis

**Goal:** Categorize customers based on how frequently they transact.

**Approach:**
- Used only deposit transactions: `transaction_type_id = 1` and `transaction_status = 'Success'`
- Counted number of transactions per customer.
- Calculated active months using `TIMESTAMPDIFF(MONTH, MIN(transaction_date), MAX(transaction_date))`.
- Divided total transactions by months to get average/month.
- Used a `CASE` statement to assign frequency categories.

---

### Question 3: Account Inactivity Alert

**Goal:** Identify active plans (savings or investment) with no deposits in the last 365 days.

**Approach:**
- Filtered plans where:
  - Savings: `is_regular_savings = 1`
  - Investment: `is_a_fund = 1`
  - Still active: `status_id = 1`
- Left joined with deposit transactions (`transaction_type_id = 1`)
- Used `MAX(transaction_date)` to find the most recent transaction.
- Calculated `inactivity_days` using `DATEDIFF(CURDATE(), last_transaction_date)`.
- Selected those with `inactivity_days > 365`.

---

###  Question 4: Customer Lifetime Value (CLV) Estimation

**Goal:** Estimate customer CLV based on tenure and transactions.

**Approach:**
- Calculated `tenure_months` from `date_joined` to `CURDATE()`.
- Counted total deposit transactions per customer.
- Used simplified CLV formula:  
  `CLV = (total_transactions / tenure_months) * 12 * (0.001 * avg(confirmed_amount))`
- Ensured division-by-zero was handled using `NULLIF`.
- Ordered results by `estimated_clv` descending.

---

##  Challenges & Resolutions

###  1. Schema Mapping from MySQL Dump
- **Challenge:** The provided SQL dump was in MySQL format and initially incompatible with Microsoft SQL Server.
- **Resolution:** Switched to MySQL (installed locally) and imported the database successfully.

###  2. Unclear Status Logic
- **Challenge:** Tables didn’t use clear status flags (like `status = 'Funded'`).
- **Resolution:** Used hint provided:
  - `is_regular_savings = 1` for savings
  - `is_a_fund = 1` for investment
  - `status_id = 1` to indicate active plans

###  3. Values in Kobo
- **Challenge:** All monetary values were in kobo, but results were expected in naira.
- **Resolution:** Converted by dividing all amounts by 100 in the final outputs.

###  4. Avoiding Division Errors
- **Challenge:** Division by zero in CLV calculation when tenure = 0 months.
- **Resolution:** Used `NULLIF(tenure, 0)` in the denominator to prevent runtime errors.



