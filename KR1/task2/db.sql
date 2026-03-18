-- Сотрудники
CREATE TABLE employee (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    hired DATE NOT NULL,
    fired DATE,
    CHECK (fired IS NULL OR fired >= hired)
);

-- Иерархия (историческая)
CREATE TABLE hierarchy (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES employee(id),
    manager_id INTEGER NOT NULL REFERENCES employee(id),
    start_date DATE NOT NULL,
    end_date DATE,
    CHECK (start_date < COALESCE(end_date, 'infinity')),
    CHECK (employee_id <> manager_id),
    UNIQUE (employee_id, start_date)
);

CREATE INDEX ON hierarchy (employee_id, start_date, end_date);
CREATE INDEX ON hierarchy (manager_id, start_date, end_date);

-- Отпуска и замещения
CREATE TABLE vacation (
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL REFERENCES employee(id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    substitute_id INTEGER NOT NULL REFERENCES employee(id),
    CHECK (start_date < end_date),
    CHECK (employee_id <> substitute_id),
    UNIQUE (employee_id, start_date)
);

CREATE INDEX ON vacation (employee_id, start_date, end_date);
CREATE INDEX ON vacation (substitute_id);