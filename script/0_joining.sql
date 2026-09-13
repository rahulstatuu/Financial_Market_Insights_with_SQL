
-- Joining 3 tables on date --


CREATE TABLE market_data_raw AS
SELECT 
    d.dt,
    g.gold_price,
    d.dollar_index,
    r.rate
FROM gold_price_table g
LEFT JOIN dollar_index_table d
    ON g.dt = d.dt
LEFT JOIN rate_table r
    ON g.dt = r.dt;