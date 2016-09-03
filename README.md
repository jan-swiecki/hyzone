# Hyzone

Docker orchestration for local/CI environment for Bash users. Similar to Docker Compose, but simpler.

You don't need to know bash to use it if you know basics of *nix based shell.

If you don't understand below example then it is adviced that you familiarize yourself with Linux shell and bash scripting a little bit.

## Learn by example

    $ cat hyzone.cfg
    PROJECT_NAME="myproj"

    # Dockerfile path and context for `docker build` command.
    # `docker build -f "$backend_dockerfile" -t backend "$backend_context"` will be executed
    # automatically on each usage of backend.
    backend_dockerfile="$(pwd)/backend/Dockerfile"
    backend_context="$(pwd)/backend"

    backend () {
      docker run -d -v "$(pwd)/backend:/w" -w /w $HYZONE_OPTS node index.js
    }

    # If we use predefined docker image then just add it after "$HYZONE_OPTS"
    frontend () {
      docker run -d -v "$(pwd)/frontend:/w" -w /w $HYZONE_OPTS nginx
    }

    # $HYZONE_OPTS is a variable that hyzone prefills with connection options, image name, labels etc.
    # that are needed for your convenience and for hyzone to operate.


    $ hyzone run backend
    $ hyzone run frontend
    $ hyzone curl -s "http://backend:8080/api/user/1"
    {
      "name": "Jan",
      "status": "Awesome"
    }
    $ hyzone curl -s "http://frontend/index.html"
    <html>
    <body>
      This is awesome!
    </body>
    </html>

`hyzone run <name>` will run container in specially created network (named after PROJECT_NAME). All `run` commands create containers in this network. All containers are available by their function names, e.g. by `backend` and `frontend` hostnames within above network.

`hyzone curl` runs `curl` in special container within same docker network so you can access containers by aliases.

You can add normal bash functions to hyzone.cfg. `hyzone run $1` will run them as normal functions. You can pass arguments to them normally. For example

    $ cat hyzone.cfg
    
    backend () { ...; }
    frontend () { ...; }

    get_version () {
      hyzone curl backend:8080/api/version
    }

    $ hyzone run get_version
    {
      "version": "1.1.0"
    }

When you run `hyzone run backend` again then old container will be killed immediately and removed and new one will be rebuilt/recreated. **That is why this technology is for development/CI environment only because of how easy it is to loose data**.

## Additional features

### `hyzone logs`

To display logs of container

    hyzone logs backend

To tail logs (similar to `docker logs`)

    hyzone logs backend -f --tail=100

### `hyzone exec`

Same as `docker exec` but you provide name defined in hyzone.cfg.

By comparison:

    docker exec [opts] <container_id|container_name> <command>
    hyzone exec [opts] <hyzone_name> <command>

It will autofind container_id and run `docker exec`.

Example

    hyzone exec -ti postgres psql --user postgres

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

    hyzone ps -q

### `hyzone logs [hyzone_name]`

`hyzone logs` will display logs of all containers from current context (last 100* lines)

`hyzone logs <hyzone_name> [opts]` will display logs of given container. Options can be `-f`, `--tail` etc. (same as for `docker logs`). 

* - you can change this value to other number by setting LOG_LINES env variable.

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

    hyzone kill
    hyzone clean

### Network commands

`hyzone network inspect` - `docker inspect` network created by hyzone for given containers
`hyzone network geteway` - show IP of gateway of current network
`hyzone network name` - show network name

## Random prefix

For CI convenience you can run `hyzone generate_random_prefix` that will create random prefix and put it in `.hyzone_prefix` file.

If `.hyzone_prefix` file is present then created network name and names of all containers are prefixed with this prefix. All logic will work the same and you can use original names from `hyzone.cfg` - hyzone, even if docker container names are different, can find your containers by labels.

Random prefix is useful if you run mutilple CI pipelines parallely (e.g. for different branches).

`hyzone kill` and `hyzone clean` command will work too.

## Experimental features

### `hyzone with [global_dependencies] <command>`

Dynamically run ubuntu based image with CLI defined dependencies, without Dockerfile.

    hyzone with npm:bower npm:gulp pip:awscli node gulp build

Above command will automagially create container with `gulp`, `bower` and `aws` commands available and run the container in the workspace shared with current folder with `gulp build` command.

## Tips and tricks

`hyzone run <name> && hyzone logs <name> -f` to run and tail logs immediately. To restart app just `CTRL-C` and up arrow and re-execute the command. Remember that `hyzone run` will kill and rebuild and run the container again.

    ## License MIT