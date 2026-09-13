

-- correlation between previous day's gold_price and today's USD to SEK rate --

WITH lag_data AS
(
    SELECT
        rate,
        LAG(gold_price) OVER (ORDER BY dt) AS lag_gold_price
    FROM market_data
),

stats AS
(
    SELECT
        *,
        AVG(rate) OVER () AS avg_rate,
        AVG(lag_gold_price) OVER () AS avg_lag_gold_price
    FROM lag_data
)

SELECT
    ROUND(
        SUM((rate - avg_rate) * (lag_gold_price - avg_lag_gold_price))
        /
        SQRT(
            SUM(POWER(rate - avg_rate, 2))
            *
            SUM(POWER(lag_gold_price - avg_lag_gold_price, 2))
        ),
        2
    ) AS lag_correlation
FROM stats
WHERE lag_gold_price IS NOT NULL;