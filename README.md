# composer
It's dangerous to go alone! Here's a reliable `docker-compose` for your local env setup to help you on your Backend adventure.

![zelda-nyan](http://i1.kym-cdn.com/photos/images/original/000/402/521/a01.png "something something")


## Setup

Composer uses docker with sugar, spice and everything that's nice.

### Prerequisites

On OS X, Docker's `docker-machine` component requires VirtualBox up and running locally. You can **[download and install VBox][vbox-setup]** from Oracle's site. While you're at it, please make sure you also **install the VBox extensions package**.

### Installing `docker-compose`

You can [set up docker-machine][setup] along with docker and docker-compose easily via homebrew:

```bash
brew update && brew install docker docker-machine docker-compose
```

This will leave you with versions `0.5.1`, `1.9.1` and `1.5.2` of `docker-machine`, `docker` and `docker-compose` respectively. You can check this via the `--version` flag on each command. eg:

```bash
docker-machine --version 
# should print docker-machine version 0.5.1 (HEAD)
```

Now it's time to create a dev machine. You can achieve this by running

```bash
docker-machine create --driver virtualbox dev
```

This command, `create`, sets up a new "Machine" (called `dev`) for local Docker development. Now we just need to point Docker at this specific Machine:

```bash
eval "$(docker-machine env dev)"
```

You can list your available Machines at any time by running:

```bash
docker-machine ls

NAME      ACTIVE   DRIVER       STATE     URL                         SWARM
default   -        virtualbox   Running   tcp://192.168.99.100:2376
dev       *        virtualbox   Running   tcp://192.168.99.102:2376
```

Please make sure `dev` is the *active Machine* before proceding.


## Running docker-compose

Once docker is up and running on your machine, you can start your dev environment by telling the composer to run the [`docker-compose.yml` file][compose-file]. Grab a cup of coffee and run the following:

```
docker-compose up
```

This will build new images for the RabbitMQ, MongoDB and Redis services and then each process in new containers. Keep in mind, the first time this is run could take a while however, subsequent builds run much quicker since Docker caches the results.

And that's it. Congratulations on getting your local env ready for some developing.


### Running daemonized

If you don't want to block your io and you're not a big fan of Tmux, you can easily run a daemonized version of docker-compose via the `-d` flag:

```
docker-compose up -d
$ ./run_tests
$ docker-compose stop
$ docker-compose rm -f
```


[setup]: https://docs.docker.com/machine/get-started/
[compose-file]: https://docs.docker.com/compose/compose-file/
[vbox-setup]: https://www.virtualbox.org/wiki/Downloads
