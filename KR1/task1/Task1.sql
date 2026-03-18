-- Создаем индексы столбцов отправления и прибытия для строк с ненулевым временем
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_flights_departure 
    ON flights (actual_departure) WHERE actual_departure IS NOT NULL;
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_flights_arrival 
    ON flights (actual_arrival) WHERE actual_arrival IS NOT NULL;

-- CTE со всеми изменениями числа самолетов в небе (именно дельта)
WITH events AS (
    SELECT actual_departure AS time, 1 AS delta
    FROM flights
    WHERE actual_departure IS NOT NULL
    UNION ALL
    SELECT actual_arrival AS time, -1 AS delta
    FROM flights
    WHERE actual_arrival IS NOT NULL
),

-- Для обработки кравеого случая, когда вылет/прилет произошли одновременно
-- В текущей версии БД таких записей нет
grouped_events AS (
    SELECT time, SUM(delta) AS total_delta
    FROM events
    GROUP BY time
)

-- Через оконную функцию считаем по дельте изменение числа самолетов в вохдухе
SELECT
    time,
    SUM(total_delta) OVER (ORDER BY time) AS planes_in_air
FROM grouped_events
ORDER BY time;