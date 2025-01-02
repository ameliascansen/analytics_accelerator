--selecting top 10 from High file
select *
from High
limit 10;

--WHERE, nonnumeric use single quotes
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

--Derived Columns: give name to new column  by using the AS keyword, derived column only exists for duration of query
SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders
LIMIT 10;

SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM orders
LIMIT 10;

SELECT id, account_id, 
poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders
LIMIT 10;
