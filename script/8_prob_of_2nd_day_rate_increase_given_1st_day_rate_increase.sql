
-- probability of rate increase on 2nd day given it increased on 1st day --


WITH rate_change AS
(
    SELECT
        dt,
        rate,

        CASE
            WHEN rate > LAG(rate) OVER(ORDER BY dt)
            THEN 1
            ELSE 0
        END AS increase_flag

    FROM market_data
),

continuation AS
(
    SELECT
        dt,
        increase_flag,
        LEAD(increase_flag) OVER(ORDER BY dt) AS next_day_increase

    FROM rate_change
)

SELECT

    COUNT(*) AS total_increase_days,

    SUM(
        CASE
            WHEN next_day_increase = 1 THEN 1
            ELSE 0
        END
    ) AS consecutive_increase_days,

    ROUND(
        SUM(
            CASE
                WHEN next_day_increase = 1 THEN 1
                ELSE 0
            END
        )
        /
        COUNT(*),
        2
    ) AS probability

FROM continuation

WHERE increase_flag = 1;