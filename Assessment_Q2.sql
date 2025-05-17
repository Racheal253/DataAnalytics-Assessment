use adashi_staging;

select * from users_customuser;
  
WITH user_tx_summary AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_txns,
        COUNT(DISTINCT DATE_FORMAT(s.transaction_date, '%Y-%m')) AS months_active
    FROM savings_savingsaccount s
    WHERE s.transaction_status = 'Success'
    GROUP BY s.owner_id
),
user_avg_txn AS (
    SELECT 
        owner_id,
        total_txns,
        months_active,
        ROUND(total_txns / months_active, 2) AS avg_txn_per_month,
        CASE
            WHEN total_txns / months_active >= 10 THEN 'High Frequency'
            WHEN total_txns / months_active >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM user_tx_summary
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM user_avg_txn
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
