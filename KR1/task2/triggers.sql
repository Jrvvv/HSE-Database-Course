CREATE OR REPLACE FUNCTION check_hierarchy()
RETURNS TRIGGER AS $$
BEGIN
    -- 1. Сотрудник и начальник должны работать на дату начала
    IF NOT EXISTS (SELECT 1 FROM employee WHERE id = NEW.employee_id AND hired <= NEW.start_date AND (fired IS NULL OR fired >= NEW.start_date)) THEN
        RAISE EXCEPTION 'Employee % does not work on %', NEW.employee_id, NEW.start_date;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM employee WHERE id = NEW.manager_id AND hired <= NEW.start_date AND (fired IS NULL OR fired >= NEW.start_date)) THEN
        RAISE EXCEPTION 'Manager % does not work on %', NEW.manager_id, NEW.start_date;
    END IF;

    -- 2. Нет пересечения периодов у одного подчинённого
    IF EXISTS (SELECT 1 FROM hierarchy WHERE employee_id = NEW.employee_id AND id <> NEW.id
               AND daterange(start_date, end_date, '[)') && daterange(NEW.start_date, NEW.end_date, '[)')) THEN
        RAISE EXCEPTION 'Intersection of hierarchy periods for employee %', NEW.employee_id;
    END IF;

    -- 3. Нет цикла (новый начальник не может быть подчинённым данного сотрудника)
    -- Не придумал как..

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_hierarchy BEFORE INSERT OR UPDATE ON hierarchy
    FOR EACH ROW EXECUTE FUNCTION check_hierarchy();


CREATE OR REPLACE FUNCTION check_vacation()
RETURNS TRIGGER AS $$
BEGIN
    -- 1. Оба сотрудника работают в период отпуска
    IF NOT EXISTS (SELECT 1 FROM employee WHERE id = NEW.employee_id AND hired <= NEW.start_date AND (fired IS NULL OR fired >= NEW.end_date)) THEN
        RAISE EXCEPTION 'Employee % does not work on vacation period', NEW.employee_id;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM employee WHERE id = NEW.substitute_id AND hired <= NEW.start_date AND (fired IS NULL OR fired >= NEW.end_date)) THEN
        RAISE EXCEPTION 'Substitute % does not work on vacation period', NEW.substitute_id;
    END IF;

    -- 2. Нет пересечения отпусков у одного сотрудника
    IF EXISTS (SELECT 1 FROM vacation WHERE employee_id = NEW.employee_id AND id <> NEW.id
               AND daterange(start_date, end_date, '[)') && daterange(NEW.start_date, NEW.end_date, '[)')) THEN
        RAISE EXCEPTION 'Intersection of vacation periods for employee %', NEW.employee_id;
    END IF;

    -- 3. Заместитель не в отпуске в это же время
    IF EXISTS (SELECT 1 FROM vacation WHERE employee_id = NEW.substitute_id
               AND daterange(start_date, end_date, '[)') && daterange(NEW.start_date, NEW.end_date, '[)')) THEN
        RAISE EXCEPTION 'Substitute % is on vacation for the sane period of time', NEW.substitute_id;
    END IF;

    -- 4. Сотрудник не замещает другого в этот период
    IF EXISTS (SELECT 1 FROM vacation WHERE substitute_id = NEW.employee_id
               AND daterange(start_date, end_date, '[)') && daterange(NEW.start_date, NEW.end_date, '[)')) THEN
        RAISE EXCEPTION 'Employee % already substitute somone on the same period of time', NEW.employee_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_vacation BEFORE INSERT OR UPDATE ON vacation
    FOR EACH ROW EXECUTE FUNCTION check_vacation();