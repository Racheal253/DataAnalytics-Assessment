-- Assessment_Q4.sql
-- Estimate CLV per customer based on inflows and tenure

SELECT
    u.id AS customer_id,
    CONCAT(u.first_name,' ', u.last_name) AS name, 
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) * 12 * 0.001 * AVG(s.confirmed_amount),
        2
    ) AS calculated_clv
FROM users_customuser u
JOIN savings_savingsaccount s 
    ON s.owner_id = u.id
    AND s.transaction_type_id = 1
    AND s.transaction_status = 'Success'
GROUP BY u.id, u.name
ORDER BY calculated_clv DESC;
