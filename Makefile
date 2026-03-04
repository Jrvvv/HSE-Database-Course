DB_NAME = demo
DEMO_DUMP = flights-db/demo-20250901-3m.sql

.PHONY: create reset load-demo recreate-with-demo connect backup

create:
	@echo "Creating database $(DB_NAME)..."
	bash init-user.sh || true
	createdb $(DB_NAME) || true

reset: drop create

drop:
	@echo "Dropping database $(DB_NAME)..."
	-dropdb $(DB_NAME) 2>/dev/null || true

load-demo:
	@echo "Loading demo data..."
	@if [ ! -f $(DEMO_DUMP) ]; then \
		echo "Error: Demo file not found!"; \
		exit 1; \
	fi
	psql $(DB_NAME) < $(DEMO_DUMP)

recreate-with-demo: reset
	@echo "Creating fresh database with demo data..."
	psql $(DB_NAME) < $(DEMO_DUMP)

connect:
	psql $(DB_NAME)

backup:
	mkdir dump || true
	pg_dump $(DB_NAME) > dump/db_dump_$$(date +%Y%m%d).sql