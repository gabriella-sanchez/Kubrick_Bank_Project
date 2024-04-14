SELECT 
	  tr.[trans_id]
      ,tr.[date] as date_of_transaction
		 ,CASE when type = 'Prijem' THEN 'credit' WHEN type = 'Vydaj' THEN 'Withdrawl' WHEN type = 'Vyber' THEN 'Mysterious third thing'
		ELSE 'Thats new' END as type_translation
		,CASE WHEN operation = 'vyber kartou' THEN 'Credit card withdrawl' WHEN operation = 'vklad' THEN 'Credit in cash'
		WHEN operation = 'prevod z uctu' THEN 'Collection from another bank'WHEN operation = 'vyber' THEN 'Withdrawl in cash'
		WHEN operation = 'prevod na ucet' THEN 'Reimttance to another bank'	ELSE  'That is new!' END as operation_translation
		,CASE WHEN k_symbol = 'pojistne' THEN 'Insurance payment' WHEN k_symbol = 'sluzby' THEN 'Payment for statement'
		WHEN k_symbol = 'urok' THEN 'Interest credited'	WHEN k_symbol = 'SankC.Urok' THEN 'Sanction interest if negative balance'
		WHEN k_symbol = 'Sipo' THEN 'Household'	WHEN k_symbol = 'Duchod' THEN 'Old-age pension'	WHEN k_symbol = 'UVER' THEN 'Loan payment'
		WHEN k_symbol IS NULL THEN 'Null value'	WHEN k_symbol = '' THEN 'Empty value'	ELSE  'That is new!' END as K_symbol_translation 
      ,tr.[bank]
      ,tr.[account] 
	    ,CASE WHEN frequency = 'POPLATEK MESICNE' THEN 'Monthly Issuance' WHEN frequency = 'POPLATEK TYDNE' THEN 'Weekly Issuance'
		WHEN frequency = 'POPLATEK PO OBRATU' THEN 'Issuance after transaction' ELSE  'That is new!' END as freq_translation
	  ,ac.date as date_acct_created
	  ,cast(sum(tr.amount) OVER(partition by tr.account_id ORDER BY tr.trans_id) as decimal(10,2)) running_sum
	  FROM [datalab_de35].[jamesmillar].[1transaction] as tr
	  JOIN [jamesmillar].[1account] as ac  ON ac.account_id = tr.account_id
	  WHERE tr.type = 'vydaj' AND bank is not null AND k_symbol IS NOT NULL AND k_symbol != ''
	  ORDER BY tr.amount desc;