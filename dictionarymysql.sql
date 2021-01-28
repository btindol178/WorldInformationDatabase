-- Create an empty table and load csv into this table
-- CREATE TABLE dictionary(word varchar(20),definition1 varchar(200))
-- TABLE dictionary;
-- CREATE TABLE dictionary2 (word varchar(200),definition1 varchar(1000))
TABLE dictionary2;

-- count all from dictionary2
SELECT COUNT(*)
FROM dictionary2;

ALTER TABLE dictionary2
RENAME COLUMN word TO Expression;