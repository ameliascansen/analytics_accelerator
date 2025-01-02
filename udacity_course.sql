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

--Logical operators
--LIKE This allows you to perform operations similar to using WHERE and =, but for cases when you might not know exactly what you are looking for.
  -- % before or after to represent characters
--IN This allows you to perform operations similar to using WHERE and =, but for more than one condition.
--NOT This is used with IN and LIKE to select all of the rows NOT LIKE or NOT IN a certain condition.
--AND & BETWEEN These allow you to combine operations where all combined conditions must be true.
--OR This allows you to combine operations where at least one of the combined conditions must be true.

SELECT name
FROM accounts
WHERE name LIKE 'C%';

select name
from accounts
where name like '%one%';

select name
from accounts
where name like '%s';

--IN: allows you to use = but for more than 1 item of that particular column
select name, primary_poc, sales_rep_id
from accounts
where name in ('Walmart', 'Target', 'Nordstrom');

select *
from web_events
where channel in ('organic', 'adwords');

--NOT operator: useful operator for working with IN and LIKE, can grab rows that do not meet particular criteria
select name, primary_poc, sales_rep_id
from accounts
where name NOT in ('Walmart', 'Target', 'Nordstrom');

select * 
from web_events
where channel NOT IN ('organic', 'adwords');

select name
from accounts
where name NOT like ('C%');

SELECT name
FROM accounts
WHERE name NOT LIKE '%one%';


