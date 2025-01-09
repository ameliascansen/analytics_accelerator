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
-- inner joins pulls rows only if they exist as a match across two tables.
-- a left join and right join do the same thing if we change the tables that are in the from and join statements
-- a left join will at least return all the rows that are in an inner join
-- join and inner join are the same
-- a left outer join is the same as left join
--The FROM clause indicates the first table from which we're pulling data, and the JOIN indicates the second table. The ON* clause specifies the column on which you'd like to merge the two tables together.
--the on statememt should always occur with the foreign key being equal to the primary key
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

Select t1.column1 aliasname, t2.column2 aliasname2
FROM tablename AS t1
JOIN tablename2 AS t2

--Provide a table for all the for all web_events associated with account name
of Walmart. There should be three columns. Be sure to include the primary_poc,
time of the event, and the channel for each event. 
Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.

SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';

--Provide a table that provides the region for each sales_rep along with their 
associated accounts. Your final table should include three columns: 
the region name, the sales rep name, and the account name. 
Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;

Provide the name for each region for every order, as well as the account name 
and the unit price they paid (total_amt_usd/total) for the order. 
Your final table should have 3 columns: 
region name, account name, and unit price. 
A few accounts have 0 for total, so I divided by (total + 0.01) 
to assure not dividing by zero.

SELECT r.name region, a.name account, 
           o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;

--LEFT and RIGHT table joins
--left table join:
  --select, from left table, left join right table

--1. Provide a table that provides the region for each sales_rep along with 
their associated accounts. This time only for the Midwest region. Your final
table should include three columns: the region name, the sales rep name, 
and the account name. Sort the accounts alphabetically (A-Z) according to 
account name.
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest'
ORDER BY a.name;

--2. Provide a table that provides the region for each sales_rep along with 
their associated accounts. This time only for accounts where the sales rep 
has a first name starting with S and in the Midwest region. Your final table
should include three columns: the region name, the sales rep name, and the 
account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;

--3. Provide a table that provides the region for each sales_rep along with 
their associated accounts. This time only for accounts where the sales rep 
has a last name starting with K and in the Midwest region. Your final table 
should include three columns: the region name, the sales rep name, and the 
account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;

--4. Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. However, 
you should only provide the results if the standard order quantity exceeds 
100. Your final table should have 3 columns: region name, account name, and 
unit price.
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100;

--5. Provide the name for each region for every order, as well as the account name 
and the unit price they paid (total_amt_usd/total) for the order. However, 
you should only provide the results if the standard order quantity exceeds 
100 and the poster order quantity exceeds 50. Your final table should have 3 
columns: region name, account name, and unit price. Sort for the smallest 
unit price first.
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;

--6. Provide the name for each region for every order, as well as the account name
and the unit price they paid (total_amt_usd/total) for the order. However, 
you should only provide the results if the standard order quantity exceeds 
100 and the poster order quantity exceeds 50. Your final table should have 3
columns: region name, account name, and unit price. Sort for the largest 
unit price first.
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;

--7. What are the different channels used by account id 1001? Your final table 
should have only 2 columns: account name and the different channels. You can 
try SELECT DISTINCT to narrow down the results to only the unique values.
SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = '1001';

--8. Find all the orders that occurred in 2015. Your final table should have 4 
columns: occurred_at, account name, order total, and order total_amt_usd.
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;


