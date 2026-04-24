CREATE FUNCTION hello_world()
RETURNS TEXT AS $$
  SELECT 'Hello, world!';
$$ LANGUAGE SQL;
