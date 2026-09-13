
-- finding monthy average gold_price, average dollar_index, agerage rate --

CREATE TABLE monthwise_market_data AS
SELECT
    DATE_FORMAT(dt, '%Y-%m') AS month,
    ROUND(AVG(gold_price), 2) AS avg_gold_price,
    ROUND(AVG(dollar_index), 4) AS avg_dollar_index,
    ROUND(AVG(rate), 4) AS avg_rate
FROM market_data
GROUP BY DATE_FORMAT(dt, '%Y-%m')
ORDER BY month;