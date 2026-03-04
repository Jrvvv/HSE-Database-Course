WITH RECURSIVE
-- Список всех возможных перелетов
flight_routes AS (
    SELECT DISTINCT
        departure_airport::text AS depart,
        arrival_airport::text AS arrive
    FROM routes
),

all_possible_routes AS (
    -- Базовые маршруты (прямые перелеты)
    SELECT
        depart AS start_point,
        depart AS current_point,
        arrive AS next_point,
        ARRAY[depart, arrive] AS full_path,
        2 AS route_length
    FROM flight_routes

    UNION ALL

    -- Рекурсивное добавление новых сегментов
    SELECT
        r.start_point,
        r.next_point AS current_point,
        f.arrive AS next_point,
        r.full_path || f.arrive AS full_path,
        r.route_length + 1 AS route_length
    FROM all_possible_routes r
    JOIN flight_routes f ON f.depart = r.next_point
    WHERE NOT (f.arrive = ANY(r.full_path))  -- Исключение повторений
        AND r.route_length < 7  -- Ограничение глубины (на большее число не хватает памяти)
)

SELECT
    route_length AS number_of_airports,
    array_to_string(full_path, ' -> ') AS route_description,
    start_point AS departure_airport,
    full_path[array_length(full_path, 1)] AS arrival_airport
FROM all_possible_routes
WHERE route_length = (SELECT MAX(route_length) FROM all_possible_routes)
ORDER BY route_length DESC;