-- Assessment_Q3.sql
-- Find active savings or investment accounts with no inflow in the last 365 days
use adashi_staging;
SELECT
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE(), MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s 
    ON s.plan_id = p.id 
    AND s.transaction_type_id = 1  -- deposit
    AND s.transaction_status = 'Success'
WHERE 
    p.status_id = 1 
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
GROUP BY p.id, p.owner_id, type
HAVING MAX(s.transaction_date) IS NULL 
    OR DATEDIFF(CURRENT_DATE(), MAX(s.transaction_date)) > 365
ORDER BY inactivity_days DESC;


