/* In SQL:
CREATE FUNCTION add_one(integer)
  RETURNS integer
  AS '$libdir/my_extension', 'add_one'
  LANGUAGE C STRICT;
*/
#include "postgres.h"
#include "fmgr.h"

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(add_one);

Datum
add_one(PG_FUNCTION_ARGS)
{
    int32 arg = PG_GETARG_INT32(0);
    PG_RETURN_INT32(arg + 1);
}
