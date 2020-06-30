#!/usr/bin/env bash
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:reset
pg_restore -c --host=db --username=manifold --dbname=manifold_development $1
RAILS_ENV=development rails db:migrate
