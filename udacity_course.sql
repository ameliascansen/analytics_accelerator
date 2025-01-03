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

--AND operator:used within a WHERE statement to consider more than one logical clause at a time. Each time you link a new statement with an AND, you will need to specify the column you are interested in looking at. 
--BETWEEN operator:
  -- instead of: WHERE column >= 6 AND column <= 10
  -- can use: WHERE column BETWEEN 6 AND 10 (and will show endpoint values)
  -- BETWEEN is generally inclusive of endpoints, it assumes the time is at 00:00:00 (i.e. midnight) for dates so for yar 2016 do BETWEEN '2016-01-01' AND '2017-01-01'
--DESC newest to oldest / alphabetical order
select standard_qty, poster_qty, gloss_qty
from orders
where standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';

select occurred_at, gloss_qty
from orders
where gloss_qty between 24 and 29;

select id, channel
from web_events
where channel in ('organic', 'adwords') and occurred_at between '2016-01-01' AND '2017-01-01'
order by occured_at desc;

--OR operator: can combine multiple statements, need to specify the column you are interested in looking at.
  -- if you put parentheses around several logical statements, it will become one large logical statement that will resolve to true or false
    -- as long as one statement is true, the entire block in parentheses will be considered true
select id
from orders 
where gloss_qty > 4000 or poster_qty > 4000;

select id
from orders
where standard_qty = 0 AND (gloss_qty > 1000 or poster_qty > 1000);

SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') 
              AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') 
              AND primary_poc NOT LIKE '%eana%');

-- order of commands does matter: select, from, where, order by, limit
SELECT col1, col2
FROM table1
WHERE col3  > 5 AND col4 LIKE '%os%'
ORDER BY col5
LIMIT 10;

--JOINS: allow us to pull data from more than one table at a time.
--The FROM clause indicates the first table from which we're pulling data, and the JOIN indicates the second table. The ON* clause specifies the column on which you'd like to merge the two tables together.
--pull all the information from only the orders table:
SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

--pulls all the columns from both the accounts and orders table.
SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

--to only pull individual elements from either the orders or accounts table, we can do this by using the exact same information in the FROM and ON statements
  --The table name is always before the period.
  --The column you want from that table is always after the period.
--For example, if we want to pull only the account name and the dates in which that account placed an order, but none of the other columns, we can do this with the following query:
SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

SELECT orders.*, accounts.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

SELECT orders.standard_qty, orders.gloss_qty, 
          orders.poster_qty,  accounts.website, 
          accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id

--primary key: is a unique column in a particular table
--foreign key: is a column in one table that is a primary key in a different table

--alias
FROM tablename t1
JOIN tablename2 t2
