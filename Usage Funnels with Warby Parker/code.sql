 -- Content of the survey table
 SELECT *
 FROM survey
 ORDER BY user_id
 LIMIT 10;
 
 -- Number of people who responded
 SELECT COUNT(DISTINCT user_id) AS 'Total number of responders'
 FROM survey;
 
 -- Number of responses per question.
 SELECT question, COUNT(DISTINCT user_id)
 FROM survey
 GROUP BY question;

 
 -- Content of each of the funnel tables and others
 -- Quiz table:
 SELECT *
 FROM quiz
 ORDER BY user_id
 LIMIT 5;
 
 -- From Quiz table: Number of request per style
 SELECT style, COUNT(DISTINCT user_id)
 FROM quiz
 GROUP BY style;
 
 -- Home_try_on table
 SELECT *
 FROM home_try_on
 ORDER BY user_id
 LIMIT 5;
 
 -- Purchase table
 SELECT *
 FROM purchase
 ORDER BY user_id
 LIMIT 5;
 
 -- Funnel relation table (point 5) with an additional columns
 SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on', q.style, q.fit, q.shape, q.color,
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
   LIMIT 10;
   
-- funnel convertion ratio
 WITH convertion AS 
 (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on', q.style, q.fit, q.shape, q.color,
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
 )
 SELECT COUNT(DISTINCT user_id) AS '# of Quiz Responders', SUM(is_home_try_on), 1.0 * sum(is_home_try_on)/COUNT(DISTINCT user_id) AS 'Try_on_to_quiz_ratio', SUM(is_purchase), 1.0 * SUM(is_purchase) /SUM(is_home_try_on) AS 'Trying_on_Purchase_Ratio' 
 FROM convertion;
 
  -- Home_try_on to purchase by pairs-tried on
  WITH convertion AS 
 (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on', q.style, q.fit, q.shape, q.color,
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
 )
 SELECT number_of_pairs, SUM(is_home_try_on) AS 'home_try_on_by_pairs', SUM(is_purchase) AS 'purchaser_by_pairs', ROUND((1.0 * SUM(is_purchase) / SUM(is_home_try_on)),2) AS 'conversion_rate'
 FROM convertion
 GROUP BY number_of_pairs;
 
 -- Home_try_on to purchase by style
  WITH convertion AS 
 (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on', q.style, q.fit, q.shape, q.color,
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
 )
 SELECT style, SUM(is_home_try_on) AS 'home_try_on_by_style', SUM(is_purchase) AS 'purchaser_by_style', ROUND((1.0 * SUM(is_purchase) / SUM(is_home_try_on)),2) AS 'conversion_rate'
 FROM convertion
 GROUP BY style;
 
 
 
 --Home_try_on to purchase by fit
  WITH convertion AS 
 (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on', q.style, q.fit, q.shape, q.color,
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
 )
 SELECT fit, SUM(is_home_try_on) AS home_try_on_by_fit, SUM(is_purchase) AS purchaser_by_fit, ROUND((1.0 * SUM(is_purchase) / SUM(is_home_try_on)),2) AS 'conversion_rate'
 FROM convertion
 GROUP BY fit;
 
 --Home_try_on to purchase by shape
  WITH convertion AS 
 (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on', q.style, q.fit, q.shape, q.color,
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
 )
 SELECT shape, SUM(is_home_try_on) AS home_try_on_by_shape, SUM(is_purchase) AS purchaser_by_shape, ROUND((1.0 * SUM(is_purchase) / SUM(is_home_try_on)),2) AS 'conversion_rate'
 FROM convertion
 GROUP BY shape;
 
 --Home_try_on to purchase by color
  WITH convertion AS 
 (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on', q.style, q.fit, q.shape, q.color,
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
 )
 SELECT color, SUM(is_home_try_on) AS home_try_on_by_color, SUM(is_purchase) AS purchaser_by_color, ROUND((1.0 * SUM(is_purchase) / SUM(is_home_try_on)),2) AS 'conversion_rate'
 FROM convertion
 GROUP BY color;
 