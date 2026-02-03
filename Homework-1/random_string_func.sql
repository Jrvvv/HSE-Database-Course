CREATE OR REPLACE FUNCTION generate_random_string(length integer)
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
    chars text := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    chars_length integer := 62;
    result text := '';
    i integer;
    random_position integer;
BEGIN
    FOR i IN 1..length LOOP
        random_position := floor(random() * chars_length + 1);
        result := result || substr(chars, random_position, 1);
    END LOOP;
    
    RETURN result;
END;
$$;

