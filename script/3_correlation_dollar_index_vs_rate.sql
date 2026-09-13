
-- Pearson correlation between dollar_index and rate --

SELECT
    ROUND(
        (
            COUNT(*) * SUM(dollar_index * rate)
            - SUM(dollar_index) * SUM(rate)
        ) /
        SQRT(
            (
                COUNT(*) * SUM(dollar_index * dollar_index)
                - POWER(SUM(dollar_index), 2)
            ) *
            (
                COUNT(*) * SUM(rate * rate)
                - POWER(SUM(rate), 2)
            )
        ),
        2
    ) AS correlation
FROM market_data
WHERE dollar_index IS NOT NULL
  AND rate IS NOT NULL;