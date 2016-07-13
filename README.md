# composer
It's dangerous to go alone! Here's a reliable `docker-compose` for your local env setup to help you on your Backend adventure.

![zelda-nyan](http://i1.kym-cdn.com/photos/images/original/000/402/521/a01.png "something something")


## Setup

Composer is leverages Docker with sugar, spice and everything that's nice.

Download and install [Docker for Mac][docker-mac].

**Optional**: install the following taps for shell completion:

```bash
brew update &&\
brew tap homebrew/completions &&\
brew install homebrew/completions/docker-completion
```


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


[compose-file]: https://docs.docker.com/compose/compose-file/
[docker-mac]: https://www.docker.com/products/docker#/mac
