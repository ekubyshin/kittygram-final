#!/bin/sh
set -e

# Ожидание PostgreSQL
until nc -z "$DB_HOST" "$DB_PORT"; do
  echo "Waiting for postgres..."
  sleep 1
done
echo "PostgreSQL started"

mkdir -p /app/collected_static /app/media

python manage.py collectstatic --noinput

python manage.py migrate --noinput

exec gunicorn --bind 0.0.0.0:8000 kittygram_backend.wsgi

