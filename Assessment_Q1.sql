 -- Assessment_Q1.sql
-- customers with at least one funded savings and one funded investment plan

SELECT 
    u.id AS owner_id,
	CONCAT(u.first_name,' ', u.last_name) AS name, 
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
	ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits   -- converting kobo to naira
FROM users_customuser u
JOIN savings_savingsaccount s 
    ON s.owner_id = u.id 
    AND s.transaction_status = 'Success'
    AND s.transaction_type_id = 1              -- assuming this means "deposit"
JOIN plans_plan p 
    ON p.owner_id = u.id 
    AND p.status_id = 1
    AND p.is_a_fund = 1
GROUP BY u.id, u.name
ORDER BY total_deposits DESC;
