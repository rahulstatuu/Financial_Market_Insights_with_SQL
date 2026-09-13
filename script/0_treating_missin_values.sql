
-- Treating missing values --


CREATE TABLE market_data AS

WITH
gold_price_cte AS
(
    SELECT
        dt,

        CASE
            WHEN gold_price IS NOT NULL THEN gold_price
            ELSE (
                    COALESCE(LAG(gold_price,1) OVER(ORDER BY dt),
                             LAG(gold_price,2) OVER(ORDER BY dt))
                  +
                    COALESCE(LEAD(gold_price,1) OVER(ORDER BY dt),
                             LEAD(gold_price,2) OVER(ORDER BY dt))
                 ) / 2											 -- taking avg of nearest available previous & next obs
        END AS gold_price

    FROM market_data_raw
),

dollar_index_cte AS
(
    SELECT
        dt,

        CASE
            WHEN dollar_index IS NOT NULL THEN dollar_index
            ELSE (
                    COALESCE(LAG(dollar_index,1) OVER(ORDER BY dt),
                             LAG(dollar_index,2) OVER(ORDER BY dt))
                  +
                    COALESCE(LEAD(dollar_index,1) OVER(ORDER BY dt),
                             LEAD(dollar_index,2) OVER(ORDER BY dt))
                 ) / 2												-- taking avg of nearest available previous & next obs
        END AS dollar_index

    FROM market_data_raw
),

rate_cte AS
(
    SELECT
        dt,

        CASE
            WHEN rate IS NOT NULL THEN rate
            ELSE (
                    COALESCE(LAG(rate,1) OVER(ORDER BY dt),
                             LAG(rate,2) OVER(ORDER BY dt))
                  +
                    COALESCE(LEAD(rate,1) OVER(ORDER BY dt),
                             LEAD(rate,2) OVER(ORDER BY dt))
                 ) / 2										-- taking avg of nearest available previous & next obs
        END AS rate

    FROM market_data_raw
)

SELECT
    g.dt,
    ROUND(g.gold_price, 2) AS gold_price,
    ROUND(d.dollar_index, 4) AS dollar_index,
    ROUND(r.rate, 4) AS rate

FROM gold_price_cte g
JOIN dollar_index_cte d
    ON g.dt = d.dt
JOIN rate_cte r
    ON g.dt = r.dt

ORDER BY g.dt;