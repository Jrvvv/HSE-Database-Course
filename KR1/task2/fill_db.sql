INSERT INTO employee (name, hired) VALUES ('Директор', '2016-01-01');

-- Подчиненные (99 человек) со случайными датами приёма начиная с 2016-01-01
INSERT INTO employee (name, hired)
SELECT 'Имя_' || i, date '2016-01-01' + (random()*3650)::int
FROM generate_series(2, 100) i;

-- Уровень 2: начальники (id 2..6) подчиняются директору (id=1)
INSERT INTO hierarchy (employee_id, manager_id, start_date)
SELECT id, 1, hired
FROM employee
WHERE id BETWEEN 2 AND 6;

-- Уровень 3: сотрудники id 7..26 подчиняются случайному начальнику из уровня 2,
-- он уже работает на дату их приёма (иначе директор)
INSERT INTO hierarchy (employee_id, manager_id, start_date)
SELECT 
    e.id,
    COALESCE(
        (SELECT id FROM employee WHERE id BETWEEN 2 AND 6 AND hired <= e.hired ORDER BY random() LIMIT 1),
        1  -- если никто из уровня 2 не подходит, назначаем директора
    ),
    e.hired
FROM employee e
WHERE e.id BETWEEN 7 AND 26;

-- Уровень 4: сотрудники id 27..100 подчиняются случайному начальнику из уровня 3 (id 7..26),
-- он уже работает на дату их приёма (иначе директор)
INSERT INTO hierarchy (employee_id, manager_id, start_date)
SELECT 
    e.id,
    COALESCE(
        (SELECT id FROM employee WHERE id BETWEEN 7 AND 26 AND hired <= e.hired ORDER BY random() LIMIT 1),
        1  -- если никто из уровня 3 не подходит, назначаем директора
    ),
    e.hired
FROM employee e
WHERE e.id BETWEEN 27 AND 100;

-- Отпуска (пример)
INSERT INTO vacation (employee_id, start_date, end_date, substitute_id) VALUES
(2, '2026-07-01', '2026-07-15', 7),
(3, '2026-08-01', '2026-08-10', 8);