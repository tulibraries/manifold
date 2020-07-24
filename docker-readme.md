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

Dockerfiles are configured for development.

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

    docker-compose exec web bin/restoredb.sh [path/top/database_dump_file]

## Visit Site

http://localhost:3000

## Test Specs

To run specs:

    docker-compose run --rm web rspec spec

## Interactive Container SHell

To access the container's shell

    docker-compose exec web bash
