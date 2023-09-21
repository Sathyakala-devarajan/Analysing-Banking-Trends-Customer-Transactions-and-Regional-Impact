create database bank;
use bank;

select * from user_nodes;
select * from user_transactions;
select * from world_regions;

# 1. List all regions along with the number of users assigned to each region.
SELECT wr.region_name, COUNT(DISTINCT un.consumer_id) AS user_count
FROM world_regions wr
LEFT JOIN user_nodes un ON wr.region_id = un.region_id
GROUP BY wr.region_name
ORDER BY user_count DESC;

# 2. Find the user who made the largest deposit amount and the transaction type for that deposit.
SELECT ut.consumer_id, ut.transaction_type, MAX(ut.transaction_amount) AS largest_deposit_amount
FROM user_transactions ut
WHERE ut.transaction_type = 'deposit'
GROUP BY ut.consumer_id, ut.transaction_type
ORDER BY largest_deposit_amount DESC
Limit 2;

# 3. Calculate the total amount deposited for each user in the "Europe" region.
SELECT un.consumer_id, SUM(ut.transaction_amount) AS total_deposited_amount
FROM user_nodes un
INNER JOIN user_transactions ut ON un.consumer_id = ut.consumer_id
INNER JOIN world_regions wr ON un.region_id = wr.region_id
WHERE wr.region_name = 'Europe' AND ut.transaction_type = 'deposit'
GROUP BY un.consumer_id;

# 4. Calculate the total number of transactions made by each user in the "United States" region.
SELECT un.consumer_id, COUNT(ut.transaction_type) AS total_transactions
FROM user_nodes un
INNER JOIN user_transactions ut ON un.consumer_id = ut.consumer_id
INNER JOIN world_regions wr ON un.region_id = wr.region_id
WHERE wr.region_name = 'United States'
GROUP BY un.consumer_id;

# 5. Calculate the total number of users who made more than 5 transactions.
SELECT consumer_id, COUNT(*) AS transaction_count
FROM user_transactions
GROUP BY consumer_id
HAVING transaction_count > 5;

# 6. Find the regions with the highest number of nodes assigned to them.
SELECT wr.region_name, COUNT(un.node_id) AS node_count
FROM world_regions wr
LEFT JOIN user_nodes un ON wr.region_id = un.region_id
GROUP BY wr.region_name
HAVING node_count > 0
ORDER BY node_count DESC;

# 7. Find the user who made the largest deposit amount in the "Australia" region.
SELECT un.consumer_id, MAX(ut.transaction_amount) AS largest_deposit
FROM user_transactions ut
INNER JOIN user_nodes un ON ut.consumer_id = un.consumer_id
INNER JOIN world_regions wr ON un.region_id = wr.region_id
WHERE wr.region_name = 'Australia' AND ut.transaction_type = 'deposit'
GROUP BY ut.transaction_type, un.consumer_id
ORDER BY largest_deposit DESC
LIMIT 1;

# 8. Calculate the total amount deposited by each user in each region.
SELECT un.consumer_id, wr.region_name, SUM(ut.transaction_amount) AS total_amount_deposited
FROM user_nodes un
INNER JOIN user_transactions ut ON un.consumer_id = ut.consumer_id
INNER JOIN world_regions wr ON un.region_id = wr.region_id
WHERE ut.transaction_type = 'deposit'
GROUP BY un.consumer_id, wr.region_name;

# 9. Retrieve the total number of transactions for each region.
SELECT wr.region_name, COUNT(ut.transaction_type) AS total_transactions
FROM world_regions wr
LEFT JOIN user_nodes un ON wr.region_id = un.region_id
LEFT JOIN user_transactions ut ON un.consumer_id = ut.consumer_id
WHERE ut.transaction_type IS NOT NULL
GROUP BY wr.region_name;

# 10. Write a query to find the total deposit amount for each region (region_name) in the user_transaction table. Consider only those transactions where the consumer_id is associated with a valid region in the user_nodes table.
SELECT wr.region_name, SUM(ut.transaction_amount) AS total_deposit_amount
FROM world_regions wr
INNER JOIN user_nodes un ON wr.region_id = un.region_id
INNER JOIN user_transactions ut ON un.consumer_id = ut.consumer_id
WHERE ut.transaction_type = 'deposit'
GROUP BY wr.region_name;

# 11. Write a query to find the top 5 consumers who have made the highest total transaction amount (sum of all their deposit transactions) in the user_transaction table.
SELECT ut.consumer_id, SUM(ut.transaction_amount) AS total_transaction_amount
FROM user_transactions ut
WHERE ut.transaction_type = 'deposit'
GROUP BY ut.consumer_id
ORDER BY total_transaction_amount DESC
LIMIT 5;

# 12. How many consumers are allocated to each region?
SELECT wr.region_id, wr.region_name, COUNT(DISTINCT un.consumer_id) AS consumers_in_region
FROM world_regions wr
LEFT JOIN user_nodes un ON wr.region_id = un.region_id
GROUP BY wr.region_id, wr.region_name
HAVING consumers_in_region > 0
ORDER by consumers_in_region DESC;

# 13. What is the unique count and total amount for each transaction type?
SELECT 
    transaction_type,
    COUNT(DISTINCT consumer_id) AS unique_count,
    SUM(transaction_amount) AS total_amount
FROM user_transactions
GROUP BY transaction_type;

# 14. What are the average deposit counts and amounts for each transaction type ('deposit') across all customers, grouped by transaction type?
# (Hint:You can achieve this by using a CTE to calculate deposit counts and amounts for each customer, and then in the main query, group by transaction type ('deposit') to find the rounded average deposit counts and amounts. Use the ROUND() function for rounding.)
WITH DepositInfo AS (
    SELECT 
        transaction_type,
        consumer_id,
        COUNT(*) AS deposit_count,
        SUM(transaction_amount) AS deposit_amount
    FROM user_transactions
    WHERE transaction_type = 'deposit'
    GROUP BY transaction_type, consumer_id
)

SELECT 
    'deposit' AS transaction_type,
    ROUND(AVG(deposit_count)) AS average_deposit_count,
    ROUND(AVG(deposit_amount)) AS average_deposit_amount
FROM DepositInfo;

# 15. How many transactions were made by consumers from each region?
SELECT wr.region_name, COUNT(*) AS transaction_count
FROM world_regions wr
INNER JOIN user_nodes un ON wr.region_id = un.region_id
INNER JOIN user_transactions ut ON un.consumer_id = ut.consumer_id
GROUP BY wr.region_name;
