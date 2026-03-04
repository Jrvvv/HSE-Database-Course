WITH RECURSIVE routes_path AS (
    -- Все рейсы из Каламы (CJC)
    SELECT
        r.departure_airport::text AS start_airport,
        r.arrival_airport::text AS current_airport,
        ARRAY[r.departure_airport::text, r.arrival_airport::text] AS path_airports,
        2 AS stops_count
    FROM routes r
    WHERE r.departure_airport = 'CJC'

    UNION ALL

    SELECT
        rp.start_airport,
        r.arrival_airport::text,
        rp.path_airports || r.arrival_airport::text,
        rp.stops_count + 1
    FROM routes_path rp
    JOIN routes r ON r.departure_airport::text = rp.current_airport
    WHERE NOT (r.arrival_airport::text = ANY(rp.path_airports))
        AND rp.stops_count < 8  -- Ограничение глубины (на большее число не хватает памяти)
)
SELECT
    start_airport AS departure_from,
    current_airport AS final_destination,
    stops_count AS airports_count,
    array_to_string(path_airports, ' -> ') AS full_route
FROM routes_path
WHERE stops_count = (SELECT MAX(stops_count) FROM routes_path WHERE stops_count <= 8)
ORDER BY stops_count DESC
LIMIT 1;
