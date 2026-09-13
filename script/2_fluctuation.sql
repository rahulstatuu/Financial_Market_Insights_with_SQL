
-- severe fluctuation table (more than 2% fluctuation in a day --

CREATE TABLE severe_fluctuations AS

WITH fluctuation AS
(
    SELECT
        dt,
        gold_price,
        dollar_index,
        rate,

        ROUND(
            (gold_price - LAG(gold_price) OVER (ORDER BY dt))
            / LAG(gold_price) OVER (ORDER BY dt) * 100,
            2
        ) AS gold_price_fluctuation,

        ROUND(
            (dollar_index - LAG(dollar_index) OVER (ORDER BY dt))
            / LAG(dollar_index) OVER (ORDER BY dt) * 100,
            2
        ) AS dollar_index_fluctuation,

        ROUND(
            (rate - LAG(rate) OVER (ORDER BY dt))
            / LAG(rate) OVER (ORDER BY dt) * 100,
            2
        ) AS rate_fluctuation

    FROM market_data
)

SELECT *
FROM fluctuation
WHERE
      ABS(gold_price_fluctuation) > 2
   OR ABS(dollar_index_fluctuation) > 2
   OR ABS(rate_fluctuation) > 2
ORDER BY dt;