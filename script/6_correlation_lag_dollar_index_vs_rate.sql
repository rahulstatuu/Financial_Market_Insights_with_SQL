

-- correlation between previous day's dollar_index and today's USD to SEK rate --

WITH lag_data AS
(
    SELECT
        rate,
        LAG(dollar_index) OVER (ORDER BY dt) AS lag_dollar_index
    FROM market_data
),

stats AS
(
    SELECT
        *,
        AVG(rate) OVER () AS avg_rate,
        AVG(lag_dollar_index) OVER () AS avg_lag_dollar_index
    FROM lag_data
)

SELECT
    ROUND(
        SUM((rate - avg_rate) * (lag_dollar_index - avg_lag_dollar_index))
        /
        SQRT(
            SUM(POWER(rate - avg_rate, 2))
            *
            SUM(POWER(lag_dollar_index - avg_lag_dollar_index, 2))
        ),
        2
    ) AS lag_correlation
FROM stats
WHERE lag_dollar_index IS NOT NULL;