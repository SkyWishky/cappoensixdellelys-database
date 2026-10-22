# ==========================================
# Custom PostgreSQL image with initial schema & seed
# ==========================================
FROM postgres:16-alpine

# Copy seed SQL into PostgreSQL init directory (executed once upon volume creation)
COPY seed.sql /docker-entrypoint-initdb.d/01-seed.sql

EXPOSE 5432

# PostgreSQL healthcheck probe
HEALTHCHECK --interval=10s --timeout=5s --start-period=10s --retries=5 \
  CMD pg_isready -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" || exit 1
