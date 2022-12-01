# phx-hive-record-docker
Docker File for the phx-hive-record project

The docker image contains the complete Elixir Phoenix app ... ready to run.

A sample how to start the containers via composer is descripbed in the 'run_prod.sh' script.

# scripts

```
$ sh run_build_push.sh
```

Builds the docker image and pushes it to my public repo.

```
$ sh run_prod.sh
```

- sets some env vars
- starts the containers locally via composer
- creates a new postgresql user and database
- migrates the phoenix database
- checks database access
- YOU are allowed to test the app on 'http://localhost:4000'
- ask to stop the containers
