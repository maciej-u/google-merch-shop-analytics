-- verifying event_timestamp vs user_first_touch_timestamp 

SELECT
  event_name,
  FORMAT_TIMESTAMP('%Y-%m-%d', TIMESTAMP_MICROS(event_timestamp)) AS event_time,
  FORMAT_TIMESTAMP('%Y-%m-%d', TIMESTAMP_MICROS(user_first_touch_timestamp)) AS user_first_touch
FROM
  `turing_data_analytics.raw_events`;


-- checking MIN and MAX event_timestamp
SELECT
  MIN(FORMAT_TIMESTAMP('%Y-%m-%d %H:%M:%S', TIMESTAMP_MICROS(event_timestamp))) AS min_event_time,
  MAX(FORMAT_TIMESTAMP('%Y-%m-%d %H:%M:%S', TIMESTAMP_MICROS(event_timestamp))) AS max_event_time
FROM
  `turing_data_analytics.raw_events`

-- Selecting necessary data
SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d %H:%M:%S', TIMESTAMP_MICROS(event_timestamp)) AS event_time,
  user_pseudo_id,
  event_name,
  category,
  mobile_brand_name,
  operating_system,
  browser,
  browser_version,
  medium,
  name AS medium_2,
  traffic_source,
  campaign,
  country,
  total_item_quantity,
  purchase_revenue_in_usd,
  refund_value_in_usd
FROM
  `turing_data_analytics.raw_events`


-- Calculating average session duration

WITH
  user_sessions AS (
  SELECT
    user_pseudo_id,
    event_date,
    MIN(TIMESTAMP_MICROS(event_timestamp)) AS session_start,
    MAX(TIMESTAMP_MICROS(event_timestamp)) AS session_end
  FROM
    `turing_data_analytics.raw_events`
  GROUP BY
    user_pseudo_id,
    event_date ),
  session_durations AS (
  SELECT
    user_pseudo_id,
    event_date,
    TIMESTAMP_DIFF(session_end, session_start, SECOND) AS session_duration_seconds
  FROM
    user_sessions )
SELECT
  event_date,
  AVG(session_duration_seconds) AS avg_engagement_time_seconds,
  TIME_ADD( TIME(0, 0, 0), INTERVAL CAST(AVG(session_duration_seconds) AS INT64) SECOND ) AS avg_engagement_time
FROM
  session_durations
GROUP BY
  event_date
ORDER BY
  event_date;


-- Validating session duration for a user

SELECT
  user_pseudo_id,
  event_name,
  event_date,
  MIN(TIMESTAMP_MICROS(event_timestamp)) AS session_start,
  MAX(TIMESTAMP_MICROS(event_timestamp)) AS session_end
FROM
  `turing_data_analytics.raw_events`
WHERE
  user_pseudo_id = '3498060.3850720604'
GROUP BY
  ALL
ORDER BY
  session_start

-- Partial check of session duration count

WITH
  user_sessions AS (
  SELECT
    user_pseudo_id,
    FORMAT_TIMESTAMP('%Y-%m-%d', TIMESTAMP_MICROS(event_timestamp)) AS event_date,
    MIN(TIMESTAMP_MICROS(event_timestamp)) AS session_start,
    MAX(TIMESTAMP_MICROS(event_timestamp)) AS session_end
  FROM
    `turing_data_analytics.raw_events`
  GROUP BY
    user_pseudo_id,
    event_date )
SELECT
  event_date,
  SUM(TIMESTAMP_DIFF(session_end, session_start, SECOND)) AS total_engagement_seconds,
  COUNT(DISTINCT user_pseudo_id) AS session_count
FROM
  user_sessions
GROUP BY
  event_date
ORDER BY
  event_date


-- Calculating average time to purchase

WITH
  user_daily_events AS (
  SELECT
    user_pseudo_id,
    FORMAT_TIMESTAMP('%Y-%m-%d', TIMESTAMP_MICROS(event_timestamp)) AS event_date,
    MIN(TIMESTAMP_MICROS(event_timestamp)) AS first_arrival,
    MIN(
    IF
      (event_name = 'purchase', TIMESTAMP_MICROS(event_timestamp), NULL)) AS first_purchase
  FROM
    `turing_data_analytics.raw_events`
  GROUP BY
    user_pseudo_id,
    FORMAT_TIMESTAMP('%Y-%m-%d', TIMESTAMP_MICROS(event_timestamp)) )
SELECT
  event_date,
  user_pseudo_id,
  AVG(TIMESTAMP_DIFF(first_purchase, first_arrival, SECOND)) AS avg_time_to_purchase_seconds,
  COUNT(first_purchase) AS users_with_purchase
FROM
  user_daily_events
WHERE
  first_purchase IS NOT NULL
GROUP BY
  event_date,
  user_pseudo_id
ORDER BY
  event_date


-- Validating conversion rate

SELECT
  ROUND(SUM(purchase_number / total_users_number) * 100, 2) AS conversion_rate
FROM (
  SELECT
    COUNT(purchase_revenue_in_usd) AS purchase_number,
    COUNT(user_pseudo_id) AS total_users_number,
  FROM
    `turing_data_analytics.raw_events` );

-- Browser version funnel analysis

WITH
  browser_funnel_data AS (
  SELECT
    event_name,
    COUNT(DISTINCT
      CASE
        WHEN browser_version = '87.0' THEN user_pseudo_id
    END
      ) AS version_87,
    COUNT(DISTINCT
      CASE
        WHEN browser_version = '86.0' THEN user_pseudo_id
    END
      ) AS version_86
  FROM
    `tc-da-1.turing_data_analytics.raw_events`
  WHERE
    mobile_brand_name = 'Apple'
    AND event_name IN ('session_start',
      'view_item',
      'add_to_cart',
      'begin_checkout',
      'add_shipping_info',
      'add_payment_info',
      'purchase')
    AND browser = 'Chrome'
    AND browser_version IN ('87.0',
      '86.0')
  GROUP BY
    event_name )
SELECT
  event_name,
  version_87,
  version_86,
  ROUND(version_87 * 100.0 / MAX(version_87) OVER (), 2) AS percentage_87,
  ROUND(version_86 * 100.0 / MAX(version_86) OVER (), 2) AS percentage_86
FROM
  browser_funnel_data
ORDER BY
  version_87 DESC,
  version_86

-- Total unique events funnel analysis

WITH
  earliest_user_events AS (
  SELECT
    user_pseudo_id,
    event_name,
    MIN(event_timestamp) AS earliest_timestamp
  FROM
    `turing_data_analytics.raw_events`
  WHERE
    event_name IN ('session_start',
      'view_item',
      'add_to_cart',
      'begin_checkout',
      'add_shipping_info',
      'add_payment_info',
      'purchase')
  GROUP BY
    user_pseudo_id,
    event_name )
SELECT
  event_name,
  COUNT(*) AS event_count,
  ROUND(COUNT(*) * 100.0 / MAX(COUNT(*)) OVER (), 2) AS event_percentage
FROM
  earliest_user_events
GROUP BY
  event_name
ORDER BY
  event_count DESC;


-- Cheching campaings time

SELECT
  campaign,
  MIN(FORMAT_TIMESTAMP('%Y-%m-%d', TIMESTAMP_MICROS(event_timestamp))) AS campaign_start,
  MAX(FORMAT_TIMESTAMP('%Y-%m-%d', TIMESTAMP_MICROS(event_timestamp))) AS campaign_end,
FROM
  `turing_data_analytics.raw_events`
GROUP BY
  campaign
ORDER BY
  campaign;


-- Checkin purchase values

SELECT
  FORMAT_TIMESTAMP('%Y-%m-%d', TIMESTAMP_MICROS(event_timestamp)) AS event_date,
  event_name,
  purchase_revenue_in_usd,
  refund_value_in_usd
FROM
  `turing_data_analytics.raw_events`
WHERE
  event_name = 'purchase'
  AND purchase_revenue_in_usd = 0

-- 5692 total purchases
-- 450 purchases with value 0