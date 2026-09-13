
-- correlation between percentage change in gold_price and percentage change in rate --

WITH daily_changes AS
(
    SELECT
        dt,

        ((gold_price - LAG(gold_price) OVER(ORDER BY dt))
        / LAG(gold_price) OVER(ORDER BY dt)) * 100 AS gold_price_pct_chng,

        ((rate - LAG(rate) OVER(ORDER BY dt))
        / LAG(rate) OVER(ORDER BY dt)) * 100 AS rate_pct_chng

    FROM market_data
)

SELECT
    ROUND(
        (
            COUNT(*) * SUM(gold_price_pct_chng * rate_pct_chng)
            - SUM(gold_price_pct_chng) * SUM(rate_pct_chng)
        )
        /
        SQRT(
            (
                COUNT(*) * SUM(gold_price_pct_chng * gold_price_pct_chng)
                - POWER(SUM(gold_price_pct_chng),2)
            )
            *
            (
                COUNT(*) * SUM(rate_pct_chng * rate_pct_chng)
                - POWER(SUM(rate_pct_chng),2)
            )
        ),
        2
    ) AS gold_rate_pct_change_correlation

FROM daily_changes
WHERE gold_price_pct_chng IS NOT NULL
  AND rate_pct_chng IS NOT NULL;