It's simple. To run environment just run:

    $ hyzone run all

See `hyzone.bash` for more details. You can easily interact with environment.

## Restart one container

    $ hyzone run mongo

will kill and run mongo. Alternatively

    $ hyzone kill mongo
    $ hyzone run mongo

Which is equivalent (`run` command kills container before running it again).

As you see you don't need to restart whole enviornment like in docker-compose.

## Connect to console in container

    $ hyzone shell mongo

## Curl container

    $ hyzone curl http://frontend:9966/

## Curl traditionally

    $ ip=$(hyzone ip frontend)
    $ curl -s "http://$ip:9966"

## Orchestrate some task

You can orchestrate any task for you CI or developments needs.

For example let's say you have a script `fill_with_data.js` that will prefill mongodb with some initial data.

This script is a NodeJS scripts and accepts one parameter: address of mongodb.

You can then add function to `hyzone.bash` that looks like this

    node () {
      docker run -v "$(pwd):/w)" -w /w -ti $HYZONE_OPTS node "$@"
    }

    # Test use case 7
    test_uc7 () {
      hyzone run mongo
      hyzone run node ./fill_with_data_uc7.js mongo
      hyzone run backend

      mocha ./test/uc7test.js

      hyzone kill
    }

And then you can run

    $ hyzone run test_uc7

to test use case 7 automatically with docker.

Alternatively if this is not related to any test case and you want mongo to be always be prefilled with data from the node script you can just refactor `mongo` function into

    mongo () {
      docker run -d $HYZONE_OPTS tutum/mongodb
      hyzone run node ./fill_with_data_uc7.js mongo
    }

