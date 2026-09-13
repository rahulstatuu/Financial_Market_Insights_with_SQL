
-- correlation between percentage change in dollar_index and percentage change in rate --

WITH daily_changes AS
(
    SELECT
        dt,
        dollar_index,
        rate,

        (dollar_index - LAG(dollar_index) OVER(ORDER BY dt))
        / LAG(dollar_index) OVER(ORDER BY dt) AS dollar_index_pct_chng,

        (rate - LAG(rate) OVER(ORDER BY dt))
        / LAG(rate) OVER(ORDER BY dt) AS rate_pct_chng

    FROM market_data
)

SELECT
    ROUND(
        (
            COUNT(*) * SUM(dollar_index_pct_chng * rate_pct_chng)
            - SUM(dollar_index_pct_chng) * SUM(rate_pct_chng)
        ) /
        SQRT(
            (
                COUNT(*) * SUM(dollar_index_pct_chng * dollar_index_pct_chng)
                - POWER(SUM(dollar_index_pct_chng),2)
            )
            *
            (
                COUNT(*) * SUM(rate_pct_chng * rate_pct_chng)
                - POWER(SUM(rate_pct_chng),2)
            )
        ),
        2
    ) AS correlation_pct_chng
FROM daily_changes
WHERE dollar_index_pct_chng IS NOT NULL
  AND rate_pct_chng IS NOT NULL;