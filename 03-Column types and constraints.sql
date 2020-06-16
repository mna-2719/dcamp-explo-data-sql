-- Select the original value
SELECT profits_change, 
	   -- Cast profits_change
       CAST(profits_change AS integer) AS profits_change_int
  FROM fortune500;


-- Divide 10 by 3
SELECT 10/3, 
       -- Cast 10 as numeric and divide by 3
       10::numeric/3;


SELECT '3.2'::numeric,
       '-123'::numeric,
       '1e3'::numeric,
       '1e-3'::numeric,
       '02314'::numeric,
       '0002'::numeric;


-- Select the count of each value of revenues_change
SELECT revenues_change, count(*)
  FROM fortune500
 GROUP BY revenues_change
 -- order by the values of revenues_change
 ORDER BY revenues_change;


-- Select the count of each revenues_change integer value
SELECT revenues_change::integer, count(*)
  FROM fortune500
 GROUP BY revenues_change::integer
 -- order by the values of revenues_change
 ORDER BY revenues_change;


-- Count rows 
SELECT count(*)
  FROM fortune500
 -- Where...
 WHERE revenues_change > 0;
 
