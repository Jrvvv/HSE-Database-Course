create_db:
	bash ../init-user.sh
	createdb students

dump_db:
	pg_dump students > db_dump.db

drop_current_db:
	psql -U ${USER} -d postgres -a -c "DROP DATABASE IF EXISTS students;"

init_from_dump_db: create_db
	psql students < db_dump.db

init_db: create_db
	psql -U ${USER} -d students -a -f create_table.sql
	psql -U ${USER} -d students -a -f random_string_func.sql
	psql -U ${USER} -d students -a -f fill_database.sql

setup_db: drop_current_db init_db

run_db:
	psql -U ${USER} -d students
