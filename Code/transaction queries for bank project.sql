--for bank project
--look at transactions


SELECT 
--CASE WHEN operation = 'vyber kartou' THEN 'Credit card withdrawl'
--	  WHEN operation = 'vklad' THEN 'Credit in cash'
--	  WHEN operation = 'prevod z uctu' THEN 'Collection from another bank'
--	  WHEN operation = 'vyber' THEN 'Withdrawl in cash'
--	  WHEN operation = 'prevod na ucet' THEN 'Reimttance to another bank' ELSE '' END as operation,
SELECT account_id,
year(date) AS yr
,month(date) as mnth
,count(*) as row_count
FROM transactions
WHERE operation IS NOT NULL 
GROUP BY   year(date),month(date), account_id
ORDER BY  count(*) desc



WITH MonthlyOperationCounts AS 
(
SELECT 
CASE WHEN operation = 'vyber kartou' THEN 'Credit card withdrawl'
	  WHEN operation = 'vklad' THEN 'Credit in cash'
	  WHEN operation = 'prevod z uctu' THEN 'Collection from another bank'
	  WHEN operation = 'vyber' THEN 'Withdrawl in cash'
	  WHEN operation = 'prevod na ucet' THEN 'Reimttance to another bank' ELSE '' END as operation,
MONTH(date) AS mnth,
COUNT(*) AS row_count
FROM 
transactions
WHERE 
operation IS NOT NULL 
AND account_id = '10650'
AND YEAR(date) = '1998'
GROUP BY MONTH(date), operation
)

SELECT 
operation,
SUM(row_count) AS total_count_over_year
FROM 
MonthlyOperationCounts
GROUP BY 
operation;


--------how many credit card withdrawals per month?
--per client?
-- this is for example - how many credit card withdrawals is each account completing a month
--then create an average across the yr to determine if they are good or bad customers
-- what does the bank consider to be a good or bad customer?

SELECT t.operation, t.account_id, t.amount,
year(t.date) as yr
,month(t.date) as mnth
,count(*) as row_count
FROM transactions as t

WHERE t.operation = 'VYBER KARTOU' AND t.account_id= '10650'
GROUP BY  year(date), month(date), t.operation, t.account_id, t.amount
ORDER BY count(*) DESC

-------------------------
-- look at who have the largest balance in their accounts after transactions a year?
-- ie look at 1997- who has the largest balance


SELECT account_id, 
YEAR(date) AS yr,
SUM(balance) AS yearly_balance
FROM transactions
WHERE YEAR(date)= 1997
GROUP BY account_id,YEAR(date)
ORDER BY  SUM(balance) DESC

---look at who has the largest balance every year consecutively :
-- look at individual accounts and see where they rank each yr based on their bank balance
With yearlybalances
As
(SELECT account_id, 
YEAR(date) AS yr,
SUM(balance) AS yearly_balance,
--COUNT(account_id) As totalaccounts,
RANK() OVER (PARTITION BY YEAR(date) ORDER BY SUM(balance) DESC) as ranks
FROM transactions
GROUP BY account_id,YEAR(date)
--ORDER BY YEAR(date), SUM(balance) DESC
)
SELECT account_id, yr, yearly_balance, ranks
FROM yearlybalances
WHERE account_id= 5622 
ORDER BY ranks asc, yr ASC


-----------------------------------------
SELECT 
	client_id, 
	card_id,
	Disposition.disp_id, 
	Disposition.account_id,
	CreditCard.type,
	CAST(CreditCard.issued AS DATE) AS issue_date,
	transactions.type
	--transactions.k_symbol
FROM CreditCard
JOIN Disposition
ON CreditCard.disp_id = Disposition.disp_id
JOIN Transactions
ON Disposition.account_id = transactions.account_id
WHERE CreditCard.type = 'gold' 
--AND transactions.type = 'VYBER KARTOU'