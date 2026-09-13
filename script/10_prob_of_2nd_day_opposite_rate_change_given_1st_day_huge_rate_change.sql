
-- probability of change in opposite direction of USD to SEK rate in 2nd day given that it changed substantially in 1st day --


WITH rate_movement AS
(
    SELECT
        dt,
        rate,

        (rate - LAG(rate) OVER(ORDER BY dt))
        / LAG(rate) OVER(ORDER BY dt) * 100 AS daily_change

    FROM market_data
),

large_move AS
(
    SELECT
        dt,
        daily_change,

        LEAD(daily_change) OVER(ORDER BY dt) AS next_day_change

    FROM rate_movement
)

SELECT

    COUNT(*) AS large_fluctuation_cases,

    SUM(
        CASE
            WHEN daily_change > 0 
                 AND next_day_change < 0 THEN 1

            WHEN daily_change < 0 
                 AND next_day_change > 0 THEN 1

            ELSE 0
        END
    ) AS reversal_cases,

    ROUND(
        SUM(
            CASE
                WHEN daily_change > 0 
                     AND next_day_change < 0 THEN 1

                WHEN daily_change < 0 
                     AND next_day_change > 0 THEN 1

                ELSE 0
            END
        )
        /
        COUNT(*),
        2
    ) AS reversal_probability

FROM large_move

WHERE ABS(daily_change) > 0.5;