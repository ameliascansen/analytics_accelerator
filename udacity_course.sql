--selecting top 10 from High file
select *
from High
limit 10;

--WHERE, nonnumeric use single quotes
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';
