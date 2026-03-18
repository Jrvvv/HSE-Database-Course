-- Проверка, подчиняется ли сотрудник с id 21 директору с id 1
WITH RECURSIVE actual_subordination AS (
    -- Определяем фактического начальника для каждого сотрудника на текущий момент
    SELECT
        h.employee_id,
        COALESCE(v.substitute_id, h.manager_id) AS actual_manager_id
    FROM hierarchy h
    LEFT JOIN vacation v ON v.employee_id = h.manager_id
        AND CURRENT_DATE BETWEEN v.start_date AND v.end_date
    WHERE h.start_date <= CURRENT_DATE 
        AND (h.end_date IS NULL OR h.end_date >= CURRENT_DATE)

), chain AS (
    -- Начинаем с сотрудника с произвольным id 21
    SELECT employee_id FROM actual_subordination WHERE employee_id = 21
    UNION ALL
    SELECT asub.actual_manager_id
    FROM chain c
    JOIN actual_subordination asub ON asub.employee_id = c.employee_id
)
SELECT EXISTS (SELECT 1 FROM chain WHERE employee_id = 1) AS is_manager; -- проверяем директора


-- Выбранная дата '01.01.2026' -- проверка ирерахии на данный момент
WITH RECURSIVE actual_subordination AS (
    SELECT
        e.id,
        e.name,
        COALESCE(v.substitute_id, h.manager_id) AS actual_manager_id
    FROM employee e
    LEFT JOIN hierarchy h ON h.employee_id = e.id
        AND h.start_date <= '01.01.2026'
        AND (h.end_date IS NULL OR h.end_date >= '01.01.2026')
    LEFT JOIN vacation v ON v.employee_id = h.manager_id
        AND '01.01.2026' BETWEEN v.start_date AND v.end_date
    WHERE e.hired <= '01.01.2026' AND (e.fired IS NULL OR e.fired >= '01.01.2026')

), tree AS (
    SELECT id, name, 0 AS level, '' AS indent, id::TEXT AS path
    FROM actual_subordination
    WHERE actual_manager_id IS NULL

    UNION ALL

    SELECT s.id, s.name, t.level+1, t.indent || '  ', t.path || '.' || s.id
    FROM actual_subordination s
    JOIN tree t ON s.actual_manager_id = t.id
)
SELECT indent || name AS employee_tree
FROM tree
ORDER BY path;