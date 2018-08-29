# Dockerfy

Build the Docker Image

```
  docker-compose build
  docker-compose run web rake db:migrate
```

To run the container, detached

```
  docker-compose up
```

Visit http://localhost:3000

To populate the database:

```
  docker-compose run web rake db:populate
```

To seed the database:

```
  docker-compose run web rake db:seed
```

To run specs:

```
  docker-compose run web rspec spec
```

To access the container's shell

```
  ddocker-compose exec web bash
```

