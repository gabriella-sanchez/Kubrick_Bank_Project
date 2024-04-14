--682 had loan payments

--loans info--

--loan status per region
with mycte
as
(
select distinct
a.account_id
, c.district_id
,l.date acceptance
, l.amount
,l.duration
,dd.A3
,dd.A8
,l.status loan_status
from pb_account a 
join  pb_client c
on a.district_id =c.district_id
join pb_loan l
on a.account_id = l.account_id
join pb_demographic_data dd
on c.district_id = dd.A1
)
select
A3
, loan_status
,count(*) no_clients
from mycte m
group by loan_status, A3


--data demographics--

--data demographics per region--
select
A3 region
,count(*) [no. districts ] 
, SUM( CASE WHEN A16< A15 THEN 1 ELSE 0 END) dis_less_crime
,CAST(SUM( CASE WHEN A16< A15 THEN 1 ELSE 0 END)/CAST(count(*) as decimal (10,2)) as decimal (10,2))as_perc
,avg((A15+A16)/2) avg_crime_rate
,avg((A12+A13)/2) avg_unemp_rate

from pb_demographic_data
where exists(
select 
 A2
, A11
, A3
, A15 [avg_no_crime95]
, A16 rime96
,A12
,A13
from pb_demographic_data
) 
group by A3
order by avg_unemp_rate desc

--data demographics for districts--

--top 10 districts order by avg unemployment rate
select top(10) 
A2 district
,A4 no_inhabitants
,A3 region
,(A15+A16)/2 avg_crime_rate
,(A12+A13)/2 avg_unemp_rate
from pb_demographic_data
where A15 is not null
and A3 IN ('south Moravia','central bohemia','north moravia','east bohemia')
order by avg_unemp_rate asc

--top 10 districts order by avg crime 
select top(10) 
A2 district
,A4 no_inhabitants
,A3 region
,(A15+A16)/2 avg_crime_rate
,(A12+A13)/2 avg_unemp_rate
from pb_demographic_data
where A15 is not null
and A3 IN ('south Moravia','central bohemia','north moravia','east bohemia')
order by avg_crime_rate asc


go
--loan status--
with loancte
as
(
select distinct
dd.A3
,dd.A1
,l.status
,CAST(l.amount as bigint) loan
from pb_account a 
join  pb_client c
on a.district_id =c.district_id
join pb_loan l
on a.account_id = l.account_id
join pb_demographic_data dd
on c.district_id = dd.A1
)
select
A3
,status
,count(*)no_clients
from loancte lc
group by A3, status


