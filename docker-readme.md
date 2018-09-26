# Dockerfy

Build the Docker Image

```
  docker-compose build  --build-arg GOOGLE_OAUTH_CLIENT_ID=$GOOGLE_OAUTH_CLIENT_ID --build-arg GOOGLE_OAUTH_SECRET=$GOOGLE_OAUTH_SECRET
  docker-compose run --rm web rake db:migrate
```

To run the container

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
