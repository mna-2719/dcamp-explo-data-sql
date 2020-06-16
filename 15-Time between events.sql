-- Compute the gaps
WITH request_gaps AS (
        SELECT date_created,
               -- lead or lag
              LAG(date_created) OVER (ORDER BY date_created) AS previous,
               -- compute gap as date_created minus lead or lag
              date_created - LAG(date_created) OVER (ORDER BY date_created) AS gap
          FROM evanston311)
-- Select the row with the maximum gap
SELECT *
  FROM request_gaps
-- Subquery to select maximum gap from request_gaps
 WHERE gap = (SELECT MAX(gap)
                FROM request_gaps);


-- Truncate the time to complete requests to the day
SELECT DATE_TRUNC('day', date_completed - date_created) AS completion_time,
-- Count requests with each truncated time
       COUNT(*)
  FROM evanston311
-- Where category is rats
 WHERE category = 'Rodents- Rats'
-- Group and order by the variable of interest
 GROUP BY completion_time
 ORDER BY completion_time;


SELECT category, 
       -- Compute average completion time per category
       AVG(date_completed - date_created) AS avg_completion_time
  FROM evanston311
-- Where completion time is less than the 95th percentile value
 WHERE (date_completed - date_created) < 
-- Compute the 95th percentile of completion time in a subquery
         (SELECT PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY (date_completed - date_created))
            FROM evanston311)
 GROUP BY category
-- Order the results
 ORDER BY avg_completion_time DESC;


-- Compute correlation (corr) between 
-- avg_completion time and count from the subquery
SELECT CORR(avg_completion, count)
  -- Convert date_created to its month with date_trunc
  FROM (SELECT DATE_TRUNC('month', date_created) AS month, 
               -- Compute average completion time in number of seconds           
               AVG(EXTRACT(epoch FROM date_completed - date_created)) AS avg_completion, 
               -- Count requests per month
               COUNT(*) AS count
          FROM evanston311
         -- Limit to rodents
         WHERE category='Rodents- Rats' 
         -- Group by month, created above
         GROUP BY month) 
         -- Required alias for subquery 
         AS monthly_avgs;


-- Compute monthly counts of requests created
WITH created AS (
       SELECT DATE_TRUNC('month', date_created) AS month,
              COUNT(*) AS created_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month),
-- Compute monthly counts of requests completed
      completed AS (
       SELECT DATE_TRUNC('month', date_completed) AS month,
              COUNT(*) AS completed_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month)
-- Join monthly created and completed counts
SELECT created.month, 
       created_count, 
       completed_count
  FROM created
       INNER JOIN completed
       ON created.month=completed.month
 ORDER BY created.month;