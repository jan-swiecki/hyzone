# Experimental features

Experimental features that are in development.

## `hyzone with [global_dependencies] <command>`

Status: In progress

Dynamically run ubuntu based image with CLI defined dependencies, without Dockerfile.

    $ hyzone with npm:bower npm:gulp pip:awscli node gulp build

Above command will automagially create container with `gulp`, `bower` and `aws` commands available and run the container in the workspace shared with current folder with `gulp build` command.

## Run different languages in bash functions

Status: None

For example `hyzone.cfg`:

    hax () (
        #!/usr/bin/env node:4

        var x = 1;
        console.log(x);
    )

    future_of_java () (
        #!/usr/bin/env java:8

        Integer x = 10;
        System.out.println(10);
    )

Then

    $ hyzone run hax
    1
    $ hyzone run future_of_java
    10
