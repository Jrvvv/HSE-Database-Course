CREATE FUNCTION add_one(integer)
RETURNS integer
AS '$libdir/ext_add', 'add_one'
LANGUAGE C STRICT;