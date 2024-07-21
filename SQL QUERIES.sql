


SELECT * 
FROM dbo.[Financial  Data]



--2: Data Review
SELECT TOP 10 * FROM [Financial  Data];

--3:Start with simple queries to understand data:

--Calculate the total of a amount column  
SELECT SUM(amount) AS TotalAmount FROM [Financial  Data]; (--ÇÌãÇáí ãÈáÛ ÇáãÇá ÇáÐí Êã ÇáÊÚÇãá ãÚå)

-- Total number of rows in the table
SELECT COUNT(*) AS TotalRows FROM [Financial  Data];

--Review the distinctive values in a particular column
SELECT DISTINCT type FROM [Financial  Data];

SELECT * FROM [Financial  Data] WHERE type = 'TRANSFER';

--What are the total number of transactions and average transaction amount 
--for each type of financial operation in the 'Financial_Dataset?
SELECT type, COUNT(*) AS TransactionCount, AVG(amount) AS AvgAmount 
FROM [Financial  Data]
GROUP BY type;

select *
from [Financial  Data]
order by amount desc



select type,sum(amount) as total_amount
from [Financial  Data]
group by type
order by total_amount


--Count transactions by type
select type,count(*) as transaction_count
from [Financial  Data]
group by type

--Fraudulent transactions (isFraud = 1):
select *
from [Financial  Data]
where isFraud=1


--Transactions flagged as fraud by the system (isFlaggedFraud = 1):
select *
from [Financial  Data]
where isFlaggedFraud=1

--Transactions flagged as fraud involving transfers or cash outs (isFlaggedFraud = 1):
select *
from [Financial  Data]
where (type='transfer' or type='cash_out') and isFlaggedFraud=1

--Transactions flagged as fraud with high amounts (isFraud = 1 and amount > 100000):

select *
from [Financial  Data]
where  isFraud=1 and amount>100000

--Top 10 accounts with the highest total amounts:  (NAME ORIG--ÇÓã ÇáãÑÓá)
select TOP 10 nameOrig  ,sum(amount) as total_amount
from [Financial  Data]
group by nameOrig
order by total_amount desc



--Find accounts (nameOrig) with more than 2 transactions:


SELECT nameOrig,count(*) as num_of_transactions
from [Financial  Data]
group by nameOrig
Having count(*)>2

--Identify destination accounts (nameDest) involved in transfers (TRANSFER) where the total amount exceeds 1000:

select nameDest,sum(amount) as tota_amount
from [Financial  Data]
group by nameDest
having sum(amount)>1000

--List accounts (nameOrig) that have transferred more than their original balance (oldbalanceOrg):(oldbalanceOrg--ÇáÑÕíÏ ÇáÞÏíã ááãÑÓá ÞÈá ÇáãÚÇãáå)
select nameOrig,SUM(AMOUNT) AS total_transferred,oldbalanceOrg
from [Financial  Data]
group by nameOrig,oldbalanceOrg
having sum(amount)>oldbalanceOrg

--This query will provide a list of accounts (nameOrig) along with the total amount transferred (total_transferred) 
--and their original balance (oldbalanceOrg), filtered to include only those accounts 
--where the total transferred amount exceeds their original balance. 
--Adjust the table name (financial data) and column names (nameOrig, amount, oldbalanceOrg) according to your actual database schema.

--Inserting a new transaction into the financial data table.
INSERT INTO [Financial  Data](step, type, amount, nameOrig, oldbalanceOrg, newbalanceOrig, nameDest, oldbalanceDest, newbalanceDest, isFraud, isFlaggedFraud)
VALUES (2, 'PAYMENT', 5000.50, 'C987654321', 10000.00, 4999.50, 'M123456789', 0, 0, 0, 0);


--Updating the newbalanceOrig for a specific transaction.
update [Financial  Data]
set newbalanceOrig=4678.00
where step=3 and type='payment'

--Update the transaction amount (amount) for transactions of type PAYMENT.
UPDATE [Financial  Data]
set amount=amount*1.05
where type='payment'



--INNER JOIN
--Retrieve all transactions (amount) with details of the sender (nameOrig) and receiver (nameDest) where the transaction type is PAYMENT.
SELECT nameOrig,AMOUNT,TYPE,nameDest
FROM [Financial  Data]
WHERE TYPE='payment'

--left join
-- Display all transactions (amount) with details of the sender (nameOrig), even if they have no transactions, and show transaction details if available.
select D.nameOrig,t.amount,t.type
from [Financial  Data] t
left join [Financial  Data] D
on D.nameOrig=t.nameOrig


-- Display all accounts that have performed transactions of type PAYMENT or TRANSFER, removing duplicates
select nameOrig,amount,type
from dbo.[Financial  Data]
where type='PAYMENT'
UNION
select nameOrig,amount,type
from dbo.[Financial  Data]
where type='transfer'

-- This query combines the results of the two SELECT statements and removes any duplicate rows. 
--It retrieves all transactions of type PAYMENT or TRANSFER without showing duplicates.


--Display all accounts that have performed transactions of type PAYMENT or TRANSFER, including duplicates.
select nameOrig,amount,type
from dbo.[Financial  Data]
where type='PAYMENT'
UNION ALL
select nameOrig,amount,type
from dbo.[Financial  Data]
where type='transfer'

--This query combines the results of the two SELECT statements and retains all rows, including duplicates. 
--It retrieves all transactions of type PAYMENT or TRANSFER and shows every instance, even if they are identical.


--List accounts (nameOrig) that have performed both PAYMENT and TRANSFER transactions

select nameOrig,amount,type
from dbo.[Financial  Data]
where type='PAYMENT'
intersect
select nameOrig,amount,type
from dbo.[Financial  Data]
where type='transfer'

--This query uses INTERSECT to find accounts that appear in both the PAYMENT and TRANSFER transactions.


--Display the total amount transacted by each account (nameOrig), either as PAYMENT or CASH_OUT, removing duplicates.

select nameorig,sum(amount) as total_amount
from(
select nameOrig,amount,type
from dbo.[Financial  Data]
where type='PAYMENT'
UNION
select nameOrig,amount,type
from dbo.[Financial  Data]
where type='transfer'
)as combined_transactions
group by nameOrig

--This query first combines PAYMENT and CASH_OUT transactions, removing duplicates, 
--and then calculates the total amount transacted by each account.

--Find pairs of transactions where the same account (nameOrig) is involved in different types of transactions.
select a.nameOrig,a.type as type_1,b.type as type_2,a.amount as amount_1,b.amount as amount_2
from dbo.[Financial  Data] a
--INNER JOIN: Returns records that have matching values in both tables.
inner join [Financial  Data] b
on a.nameOrig=b.nameOrig
and a.type!=b.type

--This query joins the table with itself where the nameOrig column matches but the transaction types are different.


--Generate all possible pairs of transactions.
SELECT a.nameOrig, a.type AS type1, b.nameOrig, b.type AS type2
FROM [Financial  Data] a
CROSS JOIN [Financial  Data] b;

--This query returns the Cartesian product of the two tables, meaning it returns all possible combinations of rows.



--Find all transactions where the amount is greater than the average transaction amount.
select *
from [Financial  Data]
where amount >(select AVG(amount) from [Financial  Data])
--This query uses a subquery to calculate the average transaction amount and 
--then filters the main query to include only those transactions where the amount is greater than this average.

--Display each transaction and the total amount transacted by the same account (nameOrig).

select step,type,amount,nameorig,

(select sum (amount) 
from [Financial  Data] t2
where t1.nameOrig =t2.nameOrig) as toatl_transacted

from [Financial  Data] as t1

--This query uses a subquery to calculate the total amount transacted by the same account (nameOrig) for each row in the main query.


--Find the accounts (nameOrig) that have made more than one transaction.
select nameOrig,count(*)
from [Financial  Data]
group by nameOrig
having count(*)>1

--2
SELECT nameOrig
FROM (SELECT nameOrig, COUNT(*) AS transaction_count
      FROM [Financial  Data]
      GROUP BY nameOrig) as sub
WHERE transaction_count > 1;
--This query uses a subquery to first group the transactions by nameOrig and count them,
--then filters the results in the outer query to include only those accounts with more than one transaction.


--how you can display each transaction and the total amount transacted by the same account (nameOrig) using a window function:
SELECT step, type, amount, nameOrig, 
       SUM(amount) OVER (PARTITION BY nameOrig) AS total_transacted
FROM [Financial  Data];

-- How can I rank the transaction amounts within each type of transaction?

select step,type,amount,nameorig,
              rank() over (partition by type order by amount desc)as rank_within_type
from [Financial  Data]


-- How can I display each transaction along with the total number of transactions and total amount transacted by the same account?
select step,type,amount,nameorig,
                   count(*) over (partition by nameorig)as transaction_count,
				   sum(amount) over (partition by nameorig)as total_amount
from [Financial  Data]

--This query uses the COUNT and SUM functions as window functions to calculate the total number of transactions  
--and total amount transacted by each account.



-- How can I classify each transaction as 'Small', 'Medium', or 'Large' based on the amount?
select step,type,amount,nameorig,
         case
		    when amount<1000 then 'small'
			when amount between 1000 and 100000 then 'medium'
			else 'large'
		end as amount_classification
from [Financial  Data]

--This query uses a CASE statement to classify the transactions based on the amount. 
--Transactions less than 1000 are classified as 'Small', between 1000 and 10000 as 'Medium', and greater than 10000 as 'Large'.


--How can I mark transactions as 'Suspicious' if they are CASH_OUT or TRANSFER and the amount is greater than 5000?
select step,type,amount,nameorig,
       
	   case
	       when(type='CASH_OUT' OR TYPE='TRANSFER')AND AMOUNT>5000 THEN 'Suspicious'
		   else 'Not Suspicious'
		   end as suspicious_flag


from [Financial  Data]


--How can I calculate the total amount transacted by each account (nameOrig) using a CTE?
with total_transacted as(
       select nameorig,sum(amount)as total_amount
	   from [Financial  Data]
	   group by nameOrig
)

SELECT nameOrig, total_amount
FROM total_transacted;

--This CTE calculates the total amount transacted by each account (nameOrig). 
--The WITH clause defines the CTE named TotalTransacted, which computes the sum of the amount for each nameOrig.

-- How can I identify accounts (nameOrig) that have performed more than one type of transaction?
                
with Transaction_Types as(
          select nameorig,count(distinct type) as transaction_types
		  from [Financial  Data]
		  group by nameOrig
)

select nameorig,transaction_types
from Transaction_Types
where transaction_types>1

--This CTE counts the distinct transaction types for each account (nameOrig). 
--The main query then filters accounts that have more than one type of transaction.      




--How can I list the top 3 largest transactions per account (nameOrig) using a CTE?

with Rank_Transactions as (
          select step,type,amount,nameorig,
		          ROW_NUMBER()over(partition by  nameorig order by amount desc) as rn

				  from [Financial  Data]

)

select step,type,amount,nameorig
from Rank_Transactions
where rn<=3


--This CTE assigns a row number to each transaction for each account (nameOrig), ordered by amount in descending order. The main query filters the top 3 transactions per account.


--How can I calculate the average transaction amount per account (nameOrig) for transactions above a certain threshold (e.g., 5000)?
with average_transactions as (
     select nameorig,amount
	 from [Financial  Data]
	 where amount>5000

)
select nameorig,avg(amount) as average_amount
from average_transactions
group by nameOrig

--This CTE filters transactions where the amount is greater than 5000. The main query then calculates the average amount for each account (nameOrig).


