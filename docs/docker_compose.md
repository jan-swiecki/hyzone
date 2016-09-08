# Hyzone vs Docker Compose

Pros of Hyzone

1. Docker Compose introduces another DSL to run containers via `yml` files. I believe it brings confusion between `docker` command line options and `docker-compose.yml` configuration options especially when in some cases they behave differently or `yml` file lacks some native features. Hyzone re-uses `docker` command so you can use all native docker features immediately.
2. Docker Compose doesn't rebuild images from Dockerfile on `docker-compose up`. `hyzone run` does that.
3. Docker Compose disallows you to re-run single container, Hyzone doesn't.
4. In `docker-compose.yml` you cannot evaluate shell commands with `$(...)`, in `hyzone.cfg` you can.
5. In `docker-compose.yml` you cannot have default values for environmental variables, in `hyzone.cfg` you can.
6. Docker Compose doesn't have a wait-for-another-application-in-some-container-to-start feature. E.g. sometimes we want to start container with Selenium tests after application and database is up. Hyzone supports that use case via `hyzone wait-for-line` (see [here](../docs/API.md#hyzone-wait-for-line-hyzone_name-searchtext)).
7. Multi-`docker-compose.yml` setup using multiple `-f` arguments is not giving you a lot of flexibility. In Hyzone you are not forced to run all containers in one go. You can do your initialization however you want (e.g. run one container only or run three containers) and you can automate it via another bash function. You can reuse single `hyzone.cfg` file in development for multiple use cases and in CI for multiple use cases too via defining mutiple startup functions for various cases. E.g. run containers in dev mode, run in mock mode (i.e. with different mock containers simulating some external world), run partially, run all containers then wait for your app to start and then run e2e tests, etc.
8. `docker-compose ps` prints output in different format than `docker ps`. `hyzone ps` prints in the same foramt as `docker ps`.

Cons of Hyzone

1. Hyzone is much more advanced tool. You need to know Bash to construct complex logic.
2. Hyzone kills containers all the time (e.g. if you rerun some container) - that might not be something everybody wants.
3. Some Hyzone commands are slow if you have lots of images (`docker images`) and non-running containers (`docker ps -a`) in docker. This is to be optimized (but currently it is a con).
4. Hyzone is maintained by single developer.
5. It's in unstable phase.
6. Hyzone doesn't support scaling. To be decided if this feature is needed (it might be nice to have it for some scaling testing).