# phx-hive-record-docker
Docker file for the phx-hive-record (Elixir Phoenix) project.

The Docker image contains the complete Elixir Phoenix app ... ready to run in a container.

A sample how to start the containers via composer is described in the `run_prod.sh` script.

# scripts

```
$ sh run_build_push.sh
```

Builds the Docker Phoenix app image and pushes it to my public repo.

```
$ sh run_prod.sh
```

The script ...
- sets some env vars
- starts the containers locally via composer (postgres and phoenix app)
- creates a new postgresql user and database
- migrates the phoenix database
- checks database access
- lets YOU test the app on http://localhost:4000
- asks to stop the containers
