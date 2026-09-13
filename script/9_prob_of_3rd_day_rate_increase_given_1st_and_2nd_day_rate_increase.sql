
-- probability of  rate increase on 3rd day given it increased on 1st and 2nd day --


WITH rate_change AS
(
    SELECT
        dt,
        rate,

        CASE 
            WHEN rate > LAG(rate) OVER(ORDER BY dt)
            THEN 1
            ELSE 0
        END AS rate_increase

    FROM market_data
),

pattern AS
(
    SELECT
        dt,

        LAG(rate_increase,2) OVER(ORDER BY dt) AS day1_increase,
        LAG(rate_increase,1) OVER(ORDER BY dt) AS day2_increase,
        rate_increase AS day3_increase

    FROM rate_change
)

SELECT
    COUNT(*) AS total_two_cons_day_increase_cases,

    SUM(
        CASE 
            WHEN day3_increase = 1 THEN 1
            ELSE 0
        END
    ) AS next_day_also_increased,

    ROUND(
        SUM(
            CASE 
                WHEN day3_increase = 1 THEN 1
                ELSE 0
            END
        )
        /
        COUNT(*),
        2
    ) AS probability_percent

FROM pattern

WHERE day1_increase = 1
AND day2_increase = 1;