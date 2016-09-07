# API Documentation

### `hyzone logs`

To display logs of container

    $ hyzone logs backend

To tail logs (similar to `docker logs`)

    $ hyzone logs backend -f --tail=100

### `hyzone exec`

Same as `docker exec` but you provide name defined in hyzone.cfg.

By comparison:

    $ docker exec [opts] <container_id|container_name> <command>
    $ hyzone exec [opts] <hyzone_name> <command>

It will autofind container_id and run `docker exec`.

Example

    $ hyzone exec -ti postgres psql --user postgres

### `hyzone wait-for-line <hyzone_name> <searchtext>`

Blocks until `docker logs -f` from container has `searchtext` in some line.

Example

    $ hyzone cat hyzone.cfg
    postgres () {
      docker run -d $HYZONE_OPTS postgres:9.5
    }

    $ hyzone run postgres
    $ hyzone wait-for-line postgres "database system is ready to accept connections"
    
Last command will block until `docker logs` from `postgres` container contain `database system is ready to accept connections` in some line.

### `hyzone curl [curl_options] <url>`

Same as `curl` but is run within Docker network of given containers, so you can use hyzone names as hostnames.

### `hyzone ip <hyzone_name>`

Return IP of container.

### `hyzone ps`

Same as `docker ps` but shows only containers related tu current context. Unlike `docker-compose` hyzone will display information in the same format as `docker ps`. You can pass same parameters to `hyzone ps` as to `docker ps`.

Example

    $ hyzone ps -q

### `hyzone logs [hyzone_name]`

`hyzone logs` will display logs of all containers from current context (last 100* lines)

`hyzone logs <hyzone_name> [opts]` will display logs of given container. Options can be `-f`, `--tail` etc. (same as for `docker logs`). 

\* - you can change this value to other number by setting LOG_LINES env variable.

Example

    hyzone logs backend -f --tail=100

Above will stream in real-time logs to stdout, but in the beginning it will display only last 100 lines.

### `hyzone kill [hyzone_name]`

`hyzone kill` will kill all containers in current context.

`hyzone kill <name>` will kill given container.

### `hyzone clean`

This command will remove created network and docker images built via Dockerfiles. It will remove any temporary files and log files of hyzone.

### `hyzone nuke`

Alias for

    $ hyzone kill
    $ hyzone clean

### Network commands

`hyzone network inspect` - `docker inspect` network created by hyzone for given containers

`hyzone network geteway` - show IP of gateway of current network

`hyzone network name` - show network name

