# Dockerfy

Build the Docker Image

```
  docker-compose build
  sudo chown -R $USER:$USER tmp/db
  docker-compose up -d
```

And restart the container (detached)

```
  docker-compose up -d
```

To stop the container

```
  docker-compose down
```

If the container does not start up because it Docker thinks that the server is already running,
delete the server PID file

```
  rm tmp/pids/server.pid
```

Visit http://localhost:3000

To populate the database:

```
  docker-compose run --rm web rake db:populate
```

To seed the database:

```
  docker-compose run --rm web rake db:seed
```

To run specs:

```
  docker-compose run --rm web rspec spec
```

To access the container's shell

```
  docker-compose exec web bash
```
