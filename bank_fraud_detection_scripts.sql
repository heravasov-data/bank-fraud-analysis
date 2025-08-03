-- Bank Fraud Detection SQL Scripts

-- 1. Detect Sudden Spike in Transaction Amounts
WITH avg_spend AS (
    SELECT 
        customer_id,
        AVG(transaction_amount) AS avg_amount,
        STDDEV(transaction_amount) AS std_dev
    FROM transactions
    WHERE transaction_date >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY customer_id
)
SELECT 
    t.customer_id,
    t.transaction_id,
    t.transaction_amount,
    a.avg_amount,
    a.std_dev,
    t.transaction_date
FROM transactions t
JOIN avg_spend a ON t.customer_id = a.customer_id
WHERE t.transaction_amount > a.avg_amount + (3 * a.std_dev)
  AND t.transaction_date = CURRENT_DATE;

-- 2. Identify Transactions from Unusual Locations
WITH usual_locations AS (
    SELECT 
        customer_id,
        location,
        COUNT(*) AS cnt
    FROM transactions
    WHERE transaction_date >= CURRENT_DATE - INTERVAL '60 days'
    GROUP BY customer_id, location
    HAVING COUNT(*) > 5
)
SELECT 
    t.customer_id,
    t.transaction_id,
    t.location,
    t.transaction_date
FROM transactions t
LEFT JOIN usual_locations u 
  ON t.customer_id = u.customer_id AND t.location = u.location
WHERE u.location IS NULL
  AND t.transaction_date >= CURRENT_DATE - INTERVAL '7 days';

-- 3. Multiple Failed Login Attempts
SELECT 
    customer_id,
    COUNT(*) AS failed_attempts,
    MAX(login_time) AS last_attempt
FROM login_attempts
WHERE success = FALSE
  AND login_time >= CURRENT_DATE - INTERVAL '1 day'
GROUP BY customer_id
HAVING COUNT(*) >= 5;

-- 4. Rapid Multiple Transactions
SELECT 
    customer_id,
    COUNT(*) AS txn_count,
    MIN(transaction_time) AS first_txn,
    MAX(transaction_time) AS last_txn
FROM transactions
WHERE transaction_time >= CURRENT_TIMESTAMP - INTERVAL '10 minutes'
GROUP BY customer_id
HAVING COUNT(*) > 5;

-- 5. Transaction Amount Just Below Approval Threshold
SELECT *
FROM transactions
WHERE transaction_amount >= 4900 AND transaction_amount < 5000
  AND transaction_date >= CURRENT_DATE - INTERVAL '30 days';

-- 6. Unusual Merchant Category Use
WITH normal_mcc AS (
    SELECT 
        customer_id,
        merchant_category_code,
        COUNT(*) AS cnt
    FROM transactions
    WHERE transaction_date >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY customer_id, merchant_category_code
    HAVING COUNT(*) >= 3
)
SELECT 
    t.customer_id,
    t.transaction_id,
    t.merchant_category_code,
    t.transaction_date
FROM transactions t
LEFT JOIN normal_mcc n
  ON t.customer_id = n.customer_id AND t.merchant_category_code = n.merchant_category_code
WHERE n.merchant_category_code IS NULL
  AND t.transaction_date >= CURRENT_DATE - INTERVAL '7 days';

-- 7. Velocity Check - Same Card Used in Distant Locations
SELECT 
    t1.customer_id,
    t1.transaction_id AS txn1_id,
    t2.transaction_id AS txn2_id,
    t1.location AS location1,
    t2.location AS location2,
    t1.transaction_time AS time1,
    t2.transaction_time AS time2
FROM transactions t1
JOIN transactions t2 
  ON t1.customer_id = t2.customer_id 
  AND t1.transaction_id < t2.transaction_id
  AND ABS(EXTRACT(EPOCH FROM (t2.transaction_time - t1.transaction_time))) < 1800
WHERE t1.location != t2.location;

-- 8. Aggregate Fraud Score (Combining Heuristics)
SELECT 
    t.customer_id,
    COUNT(CASE WHEN t.transaction_amount > 10000 THEN 1 END) AS high_value_txns,
    COUNT(CASE WHEN t.location NOT IN (
        SELECT location FROM transactions WHERE customer_id = t.customer_id GROUP BY location HAVING COUNT(*) > 2
    ) THEN 1 END) AS unusual_location_txns,
    COUNT(CASE WHEN t.transaction_time BETWEEN '00:00:00' AND '05:00:00' THEN 1 END) AS night_txns
FROM transactions t
WHERE t.transaction_date >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY t.customer_id
HAVING high_value_txns > 2 OR unusual_location_txns > 1 OR night_txns > 3;