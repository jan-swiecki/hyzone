# Hyzone

Docker orchestration for local/CI environment for Linux users. It might be a better alternative to Docker Compose.

It's bash-based but you don't need to know bash to use it if you know basics of *nix based shell. Although bash knowledge gives you more power over hyzone. Additionally you should be quite familiar with Docker.

If you don't understand below example then it is adviced that you familiarize yourself with Linux shell and bash scripting a little bit and/or Docker.

Quick links:

* [API docs](docs/API.md)
* [Basic example](examples/basic-example/hyzone.cfg)
* [Examples](examples)

## Introduction

Hyzone uses similar concept to `docker-compose.yml`. Hyzone config file is named `hyzone.cfg` or `hyzone.bash`. This file is written in bash. It has numerous user-defined functions. Each function can represent either a container or some task to be run (e.g. run multiple containers or check state of the system). Example file:

    PROJECT_NAME="myproj"

    backend_dockerfile="$(pwd)/backend/Dockerfile"
    backend_context="$(pwd)/backend"
    
    backend () {
      docker run -d -v "$(pwd)/backend:/w" -w /w $HYZONE_OPTS node index.js
    }

    # If we use predefined docker image then just add it after "$HYZONE_OPTS"
    frontend () {
      docker run -d -v "$(pwd)/frontend:/w" -w /w $HYZONE_OPTS nginx
    }

`$HYZONE_OPTS` is a variable that hyzone prefills with connection options, image name, labels etc. that are needed for your convenience and for hyzone to operate.

This example for reading only. For interactive example see [Basic example](examples/basic-example/hyzone.cfg). I encourage to continue reading and then going to Basic example.

We would run above configuration file with:

    $ hyzone run backend
    <some docker/hyzone output>
    
    $ hyzone run frontend
    <some docker/hyzone output>

Hyzone managed containers are to be treated as ephemeral.

**The philosophy of hyzone is**:
* to quickly run part of the system or whole system
* easily run manual or automatic tests, verify state, do normal development or run tests in CI
* kill single containers or all of them on-demand with garbage collection if needed (i.e. you can remove all images and docker network if you want).

With this approach you'll be able, for example, to run all containers, then restart one container and then kill some other, then run some tests defined in `hyzone.cfg` and then kill all containers, remove docker images and docker network. You can basically run any `hyzone` task and any task you define in the config. Tasks (bash functions) in the config can have normal commands, hyzone commands and docker commands. <s>Sky</s> Bash is the limit.

`hyzone run <name>` will run container in specially created network (named after PROJECT_NAME). All `run` commands create containers in this network. All containers are available by their function names, e.g. by `backend` and `frontend` hostnames within the network.

You can add normal bash functions to `hyzone.cfg`. `hyzone run $1` will run them as normal functions. You can pass arguments to them normally. For example we can have this kind of `hyzone.cfg` file:

    backend () { ...; }
    frontend () { ...; }

    api_request () {
      hyzone curl backend:8080/api/$1
    }

And then

    $ hyzone run api_request /version
    {
      "version": "1.1.0"
    }

To restart backend run

    $ hyzone run backend

When you run `hyzone run $1` again then old container will be killed immediately and removed and new one will be rebuilt, recreated and re-run.

To kill backend

    $ hyzone kill backend

To kill all containers (in current hyzone scope)

    $ hyzone kill

See [Basic example](examples/basic-example/hyzone.cfg) and [API docs](docs/API.md) for more info.

## Hyzone curl

You can run

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

Above responses are example responses from `backend` and `frontend` apps.

`hyzone curl` runs `curl` in special container within same docker network so you can access containers by their hyzone names (i.e. function names). Docker containers in most cases will be named the same as hyzone names.

## Random prefix

For CI convenience you can run `hyzone generate_random_prefix` that will create random prefix and put it in `.hyzone_prefix` file.

If `.hyzone_prefix` file is present then created network name and names of all containers are prefixed with this prefix. All logic will work the same and you can use original names from `hyzone.cfg` - hyzone, even if docker container names are different, can find your containers by labels.

Random prefix is useful if you run mutilple CI pipelines parallely (e.g. for different branches).

`hyzone kill` and `hyzone clean` command will work too.

## Tips and tricks

`hyzone run <name> && hyzone logs <name> -f` to run and tail logs immediately. To restart app just `CTRL-C` and up arrow and re-execute the command. Remember that `hyzone run` will kill and rebuild and run the container again.

## TODO

* Update mean-stack example
* Create more examples
  * Multi-language project example
  * Jenkins pipelines examples with selenium and API tests
* Finish `hyzone with` [experimental](docs/Experimental.md) feature.
* Allow using other languages in bash functions which is an [experimental](docs/Experimental.md) feature.

## License MIT