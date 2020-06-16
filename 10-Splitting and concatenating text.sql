-- Concatenate house_num, a space, and street
-- and trim spaces from the start of the result
SELECT LTRIM(CONCAT (house_num,' ',street), ' ') AS address
  FROM evanston311;


-- Select the first word of the street value
SELECT SPLIT_PART(street, ' ', 1) AS street_name, 
       COUNT(*)
  FROM evanston311
 GROUP BY street_name
 ORDER BY COUNT DESC
 LIMIT 20;


-- Select the first 50 chars when length is greater than 50
SELECT CASE WHEN length(description) > 50
            THEN LEFT(description, 50) || '...'
       -- otherwise just select description
       ELSE description
       END
  FROM evanston311
 -- limit to descriptions that start with the word I
 WHERE description LIKE 'I %'
 ORDER BY description;


