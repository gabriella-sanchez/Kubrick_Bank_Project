
-- a key indicator of who a good customer for a loan is their credit scores
--accounts who hold gold - high creditworthiness, higher income, financially established, customers with long histories


--work out average credit history using datediff
--generally a longer credit history is viewed more favourably 
WITH cte AS
(
SELECT 
	card_id,
	disp_id,
	type,
	DATEDIFF(YEAR, issued, GETDATE()) AS cred_history_yrs
FROM card
)
SELECT 
	type,
	AVG(cred_history_yrs) AS avg_credit_hist_yrs
FROM cte
GROUP BY [type]

--Junior: 27 years
--Gold:26 years
--classic: 26 years


--Checking loan status depending on type of credit card clients hold
--A are those whose contracts are finished and no problems
SELECT 
	client_id, 
	disp.disp_id, 
	disp.account_id,
	disp.[type],
	card.[type],
	CAST(card.issued AS DATE) AS issue_date,
	loan.loan_id,
	loan.status
FROM card
JOIN disp
ON card.disp_id = disp.disp_id
JOIN loan
ON disp.account_id = loan.account_id
WHERE card.type = 'Gold'
ORDER BY card.type, loan.status
-- out of the 16 Gold credit card holders, 50% (8) had loan status A, 7 had C and only one in D

SELECT 
	client_id, 
	disp.disp_id, 
	disp.account_id,
	card.[type],
	CAST(card.issued AS DATE) AS issue_date,
	loan.loan_id,
	loan.amount,
	loan.status
FROM card
JOIN disp
ON card.disp_id = disp.disp_id
JOIN loan
ON disp.account_id = loan.account_id
WHERE card.type = 'classic'
AND loan.status = 'C'
ORDER BY card.type, loan.status
-- for classic credit card holders, 46/133 so 35% are A and 84/133 so 62% are C, 2/133 = D

SELECT 
	client_id, 
	disp.disp_id, 
	disp.account_id,
	disp.[type],
	card.[type],
	CAST(card.issued AS DATE) AS issue_date,
	loan.loan_id,
	loan.status
FROM card
JOIN disp
ON card.disp_id = disp.disp_id
JOIN loan
ON disp.account_id = loan.account_id
WHERE card.type = 'junior'
AND loan.status = 'C'
ORDER BY card.type, loan.status
-- junior: A = 6/21 = 29%, B = 1/21 so 4.8%, C = 14/21 = 66.7%

-- so generally, credit card holders, especially Gold and classic, are reliable
-- bit more difficult to say for junior as majoirity still have running contracts 

SELECT 
	client_id, 
	disp.disp_id, 
	disp.account_id,
	disp.[type],
	card.[type],
	CAST(card.issued AS DATE) AS issue_date,
	loan.loan_id,
	loan.status
FROM card
JOIN disp
ON card.disp_id = disp.disp_id
JOIN loan
ON disp.account_id = loan.account_id
WHERE loan.status in ('d','b')
ORDER BY card.type, loan.status
-- only two B's = classic and junior 
-- onlu 3 D's = two classic and one gold

-- few instances where classic and even a gold credit card holder is in debt 
--this is where we really need to cross-reference and explore diff factors 




-- are their clients with mutliple credit cards? - no
SELECT 
	client_id, 
	disp.disp_id, 
	disp.account_id,
	card.[type],
	CAST(card.issued AS DATE) AS issue_date,
	loan.loan_id,
	loan.status
FROM card
JOIN disp
ON card.disp_id = disp.disp_id
JOIN loan
ON disp.account_id = loan.account_id
ORDER BY client_id





--Joining disp, card and transation
SELECT 
	client_id, 
	disp.disp_id, 
	disp.account_id,
	disp.[type],
	card.[type],
	CAST(card.issued AS DATE) AS issue_date,
	trans.k_symbol
FROM card
JOIN disp
ON card.disp_id = disp.disp_id
JOIN trans
ON disp.account_id = trans.account_id
WHERE trans.k_symbol = 'SANKC. UROK'
AND card.type = 'gold'
ORDER BY card.type
-- GOLD credit card holders less frequently have 'sankc.urok' so less likely to have negative balance, safer for loans
--only 15 out of the 141 who recieved a santion interest for having a negative balance 

--count how many classics, golds and junions have sankc.urok
SELECT 
	client_id, 
	card_id,
	disp.disp_id, 
	disp.account_id,
	card.type,
	--CAST(card.issued AS DATE) AS issue_date,
	--trans.type,
	trans.k_symbol
	--COUNT(trans.k_symbol)
FROM card
JOIN disp
ON card.disp_id = disp.disp_id
JOIN trans
ON disp.account_id = trans.account_id
WHERE trans.k_symbol = 'SANKC. UROK'
AND card.type = 'classic'
--98 classic credit cad holders have sankc.urok

--out of all those who have SANKC.UROK - 141

SELECT 
	client_id, 
	card_id,
	disp.disp_id, 
	disp.account_id,
	card.type,
	--CAST(card.issued AS DATE) AS issue_date,
	--trans.type,
	trans.k_symbol
	--COUNT(trans.k_symbol)
FROM card
JOIN disp
ON card.disp_id = disp.disp_id
JOIN trans
ON disp.account_id = trans.account_id
WHERE trans.k_symbol = 'SANKC. UROK'
AND card.type = 'junior'
--28/141 have 

SELECT * FROM trans
WHERE k_symbol = 'SANKC. UROK'

--what is the most common type of transaction for diff credit card holders
SELECT 
	client_id, 
	card_id,
	disp.disp_id, 
	disp.account_id,
	card.type,
	CAST(card.issued AS DATE) AS issue_date,
	trans.type,
	trans.k_symbol
FROM card
JOIN disp
ON card.disp_id = disp.disp_id
JOIN trans
ON disp.account_id = trans.account_id
WHERE card.type = 'gold' 
and trans.type = 'PRIJEM'
--WHERE trans.type = 'VYBER KARTOU'
--for junior card holders, 20,849 made withdrawals, 14,681 credit
--for gold card holders, 15,803 made withdrawals, 9,333 credit


SELECT 
	district.A11 AS average_salary,
	district.district_id,
	card.card_id,
	card.type
FROM district
Join client
ON district.district_id = client.district_id
JOIN disp
ON disp.client_id = client.client_id
JOIN card
ON card.disp_id = disp.disp_id


--average age of client and their credit card type
with mycte
AS
(
SELECT client_id, birth_number,
CAST(
CONCAT(
19, LEFT ( birth_number, 2),
CASE WHEN CAST(SUBSTRING(CAST(birth_number AS VARCHAR), 3, 1) AS INT )=5 THEN 0 
	WHEN CAST( SUBSTRING(CAST(birth_number AS VARCHAR), 3, 1)AS INT) = 6 THEN 1 
	ELSE SUBSTRING(CAST(birth_number AS VARCHAR), 3, 1)
	END ,
RIght (birth_number, 3) 
)AS DATE) AS newdate
FROM client
GROUP BY client_id, birth_number
)
Select 
	AVG(DATEDIFF(year, newdate, GETDATE())) AS AgeOfClient,
	COUNT(card.type) AS no_client_with_card,
	card.type
From mycte
JOIN disp
ON mycte.client_id = disp.disp_id
JOIN card
ON disp.disp_id = card.disp_id
WHERE card.type = 'gold'
GROUP BY card.type
ORDER BY AgeOfClient 
-- avg is 69 for gold

--average age of client and their credit card type
with mycte
AS
(
SELECT client_id, birth_number,
CAST(
CONCAT(
19, LEFT ( birth_number, 2),
CASE WHEN CAST(SUBSTRING(CAST(birth_number AS VARCHAR), 3, 1) AS INT )=5 THEN 0 
	WHEN CAST( SUBSTRING(CAST(birth_number AS VARCHAR), 3, 1)AS INT) = 6 THEN 1 
	ELSE SUBSTRING(CAST(birth_number AS VARCHAR), 3, 1)
	END ,
RIght (birth_number, 3) 
)AS DATE) AS newdate
FROM client
GROUP BY client_id, birth_number
)
Select 
	AVG(DATEDIFF(year, newdate, GETDATE())) AS AgeOfClient,
	COUNT(card.type) AS no_client_with_card,
	card.type
From mycte
JOIN disp
ON mycte.client_id = disp.disp_id
JOIN card
ON disp.disp_id = card.disp_id
WHERE card.type = 'junior'
GROUP BY card.type
ORDER BY AgeOfClient 
-- avg is 45 for junior

--average age of client and their credit card type
with mycte
AS
(
SELECT client_id, birth_number,
CAST(
CONCAT(
19, LEFT ( birth_number, 2),
CASE WHEN CAST(SUBSTRING(CAST(birth_number AS VARCHAR), 3, 1) AS INT )=5 THEN 0 
	WHEN CAST( SUBSTRING(CAST(birth_number AS VARCHAR), 3, 1)AS INT) = 6 THEN 1 
	ELSE SUBSTRING(CAST(birth_number AS VARCHAR), 3, 1)
	END ,
RIght (birth_number, 3) 
)AS DATE) AS newdate
FROM client
GROUP BY client_id, birth_number
)
Select 
	AVG(DATEDIFF(year, newdate, GETDATE())) AS AgeOfClient,
	COUNT(card.type) AS no_client_with_card,
	card.type
From mycte
JOIN disp
ON mycte.client_id = disp.disp_id
JOIN card
ON disp.disp_id = card.disp_id
WHERE card.type = 'classic'
GROUP BY card.type
ORDER BY AgeOfClient 
-- avg is 69 for classic

with mycte3
as
(
select 
c.client_id
, a.account_id
, c.district_id
, dd.A3
,dd.A11
,cc.type
from pb_client c
join pb_disp d
on c.client_id = d.client_id
join pb_card cc
on d.disp_id = cc.disp_id
join pb_demographic_data dd
on c.district_id = dd.A1
join pb_account a
on d.account_id = a.account_id
)select 
A3
, avg(A11) avg_sal
,type
,count(*)[no of cards]
,avg(DATEDIFF(year,l.date,GETDATE())) [avg card length per region]
, avg(l.amount) avg_loan_amount
from mycte3 m