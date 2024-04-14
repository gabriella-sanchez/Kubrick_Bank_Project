
SELECT *
FROM DemographicData
-------------------how many clients are within each region:
SELECT  d.A3 AS Region,
COUNT ( client_id) AS NumberOfClients
FROM Client AS c
LEFT OUTER Join DemographicData AS D
ON c.district_id= d.A1
Group by d.A3
ORDER by (COUNT ( client_id)) DESC 
-------------------------
--looking at number of clients per district from each region
-- who is our target audience 
SELECT D.A1 AS DistrictCode
,D.A2 AS DistrictName
,D.A3 AS Region,
COUNT(client_id) NumberOfClients
FROM Client AS c
LEFT OUTER JOIN DemographicData AS D
ON c.district_id= d.A1
GROUP BY D.A1, D.A2, D.A3
ORDER by (COUNT ( client_id)) DESC 

--------------------------------------
--demographics of each region
--highly interested in districts 1, 74, 70, 54
--
----does correlate with number of inhabitants per district- top 4 client districts are the same
SELECT  D.A1 AS DistrictCode
, D.A2 AS DistrictName, 
D.A3 AS Region, 
D.A4 As NumberOfInhabitants
FROM  DemographicData AS D
GROUP By D.A1,D.A2, D.A3, D.A4
ORDER BY D.A4 desc

-----------------------
--look at our top clients where there are low number of inhabitants- 
--do we target these people? make sure out bank is being recommended?

--SELECT D. A1, D.A2,
--COUNT ( client_id) As numofclients
--FROM Client As C
--LEFT OUTER JOIN DemographicData AS D
--ON c.district_id= d.A1
--GROUP BY D.A1,D.A2, D.A5
--ORDER by (COUNT ( client_id)) DESC
-------------------------------------------
select TOP 5                               --these up and coming districts- lets target them for loan authorisiation
D.A1 AS DistrictCode
, D.A2 AS District
,
COUNT ( client_id) As NumOfClients
FROM Client As C
LEFT OUTER JOIN DemographicData AS D
ON c.district_id= d.A1
WHERE D.A5 >= 5
GROUP BY D.A1, D.A2
ORDER by (COUNT ( client_id)) DESC

--------------------------------------
-- districts with top avg salaraies 
-- deffo want ppl from these areas to be our customers/ more likely to be good customers
SELECT TOP 5
D.A1 AS District_id, 
D.A2 AS District_name, 
D.A11 AS AVG_salary
FROM DemographicData AS D
ORDER BY D.A11 DESC

-------
--so now look at our client base do clients who take out the most loans coincide with 
--clients who have the highest paying salaries 
--so are the most loans coming from areas where there is a higher avg salary 


SELECT d.A1, d.A2,
COUNT (l.loan_id) As NumofLoansPerDistrict
FROM Loan as l
LEFT OUTER JOIN Account AS a
ON l.account_id= a.account_id
LEFT OUTER JOIN DemographicData as D
ON a.district_id= d.A1
GROUP BY d.A1,d.A2
ORDER BY COUNT (l.loan_id) DESC

--^^number of loans per district

SELECT d.A1
AS District code, d.A2,
COUNT (l.loan_id) As NumofLoansPerDistrict
FROM Loan as l
LEFT OUTER JOIN Account AS a
ON l.account_id= a.account_id
LEFT OUTER JOIN DemographicData as D
ON a.district_id= d.A1
WHERE d.A1= 1 OR d.A1= 8 or d.A1= 26 OR d.A1= 74 OR d.A1=39
GROUP BY d.A1,d.A2
ORDER BY COUNT (l.loan_id) DESC


---lets just quickly look at avg age of clients

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
AVG(DATEDIFF(year, newdate, GETDATE())) AS AvgAgeOfClient
From mycte
-------------------------------------------------
SELECT A1,A2, A11
FROM DemographicData
GROUP BY A1,A2, A11
ORDER BY A11 DESC



SELECT*
FROM Client

----------------------------------------
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
	CreditCard.type
From mycte
JOIN Disposition
ON mycte.client_id = Disposition.disp_id
JOIN CreditCard
ON Disposition.disp_id = CreditCard.disp_id
WHERE CreditCard.type = 'junior'
GROUP BY CreditCard.type
ORDER BY AgeOfClient



