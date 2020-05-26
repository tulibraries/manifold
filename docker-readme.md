---
title: Manifold on Docker
author: Steven Ng
date: 2020-05-26
tags:
  - Manifold
  - PostgreSQL
  - Docker
---

# Manifold on Docker

Build the Docker Image

    docker-compose build
    sudo chown -R $USER:$USER tmp/db
    docker-compose up -d


Run the Docker image

And restart the container (detached)

    docker-compose up -d


To stop the container

    docker-compose down


If the container does not start up because it Docker thinks that the server is already running,
delete the server PID file


    rm tmp/pids/server.pid


Visit http://localhost:3000

## Populate the database

To populate the database with a dumpfile

Start an interactive session on the Docker container


    docker-compose exec web bash

or

    docker exec -it manifold_web_1 bash

Within the docker container, recreate the database:

    DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:reset

Restore the database from a dumpfile

    pg_restore -c --host=db --username=manifold --dbname=manifold_development /manifold/manifold-2020-04-09T18+0000.sqlc

Run the latest migration

    RAILS_ENV=development rails db:migrate

And exit the container session

    exit

## Test Specs

To run specs:

    docker-compose run --rm web rspec spec

## Interactive Container SHell

To access the container's shell

    docker-compose exec web bash
