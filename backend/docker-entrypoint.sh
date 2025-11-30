#!/bin/sh
set -e

# Ожидание PostgreSQL
until nc -z "$DB_HOST" "$DB_PORT"; do
  echo "Waiting for postgres..."
  sleep 1
done
echo "PostgreSQL started"

# Копирование статики в volume
python manage.py collectstatic --noinput

# Применение миграций
python manage.py migrate --noinput

# Запуск gunicorn
exec gunicorn --bind 0.0.0.0:8000 kittygram_backend.wsgi

