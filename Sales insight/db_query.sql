SELECT DISTINCT(currency)
FROM transactions;

-- for currency, there are 4 distinct currencies 'USD' 'USD/r' 'INR/r' INR'

SELECT COUNT(*)
FROM transactions
WHERE currency = 'INR\r';

SELECT COUNT(*)
FROM transactions
WHERE currency = 'USD\r';

-- we need to update the rows so that currency = 'USD' or 'INR' only

UPDATE transactions
SET currency = 'USD'
WHERE currency = 'USD\r';

UPDATE transactions
SET currency = 'INR'
WHERE currency = 'INR\r';


SELECT DISTINCT product_type
from products