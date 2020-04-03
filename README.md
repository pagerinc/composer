# composer
It's dangerous to go alone! Here's a reliable `docker-compose` to help you on your Backend adventures.

![zelda-nyan](http://i1.kym-cdn.com/photos/images/original/000/402/521/a01.png "something something")

## Setup

Composer leverages Docker with sugar, spice and everything that's nice.

Clone and install **[Pager's dotfiles][dotfiles]** (recommended) or [Docker for Mac][docker-mac].

> **NOTE**: if you're not using the `dotfiles` repo, you might want to install
> the following for shell completion.

```bash
brew install docker-completion
```

## Running docker-compose

Once docker is up and running on your machine, you can start your dev environment by telling the composer to run the [`docker-compose.yml` file][compose-file]. Grab a cup of coffee and run the following:

```
docker-compose up
```

This will build new images for the RabbitMQ, MongoDB and Redis services and then each process in new containers. Keep in mind, the first time this is run could take a while however, subsequent builds run much quicker since Docker caches the results.

And that's it. Congratulations on getting your local env ready for some developing.

Please note that when you run a service locally, RABBIT_URL should be "amqp://localhost:5672/db".

### Running daemonized

If you don't want to block your io and you're not a big fan of Tmux, you can easily run a daemonized version of docker-compose via the `-d` flag:

```
docker-compose up -d

./run_tests
docker-compose stop
docker-compose rm -f
```

### Sharing the network

The `docker-compose.yml` file creates a network called `cloudbuild` to mimic how cloudbuild works locally.
All other services should have the following at the bottom of their `docker-compose.yml` files to hook
into this shared docker network:
```yaml
networks:
  default:
    external:
      name: cloudbuild
```

### Destructive actions

`docker-compose stop` by default is not a destructive action. It leaves the containers and their volumes
intact, but stop the container. This means that the only resource being used is disk space. If you execute
`docker-compose down` all coantiners and volumes will be destroyed and need to be rebuilt, which means
your databases will revert to empty as well. `docker-compose rm` after a `stop` is the same as running `down`.

## Kong

Kong starts when you run `docker-compose up -d` with the rest of the services, and will bind to
port `80` and `443` on localhost for the proxy listener, and the admin listener will bind to port `8001`.

There is also a Kong admin UI (Konga) included that binds to `localhost:8002`. You will need to add a connection
the first time you start it, and use the address of kong admin _internal_ to the docker network, meaning
you will need to use `http://kong:8001` as the kong admin address in Konga.

In order to generate a configuration for Kong, you will need to have the `pagerinc/charts` repo set up
locally. Once you have `charts` set up locally, you can go to that repo and run
`bash scripts/kong_template.sh -l true -o kong.yaml` which will generate a `decK` config file with all of the
ports and urls set to their localhost values. You should then be able to run `deck sync` (if you have installed `decK`)
to sync the generated config to your local Kong instance.

## Dnsmasq Setup

We are using `dnsmasq` to run a local DNS server in order to answer the `pager.localhost` DNS requests. To
install dnsmasq, run `bash setup-dnsmasq.sh` which will install and configure dnsmasq and the routing you need.

After running the setup, you should be able to run `scutil --dns` and see a resolver for `localhost` listed. If
you do not see a resolver for localhost listed, run `sudo vim /etc/resolver/localhost` and then just exit the
file without making any changes. MacOS is a little weird in how it detects file changes in `/etc/resolver/` and
opening and closing the file with `vim` triggers a swap file create/delete which tricks MacOS into seeing the changes.

## HTTPS/TLS Support

This repo has full support for running your services on HTTPS/TLS locally using the same subdomains that we use
for our services in staging and production environments. In order to enable TLS support, run `docker-compose up -d`
and then after that `cd` into the `tls` directory and run `bash generate-certs.sh`. This will generate a
Certificate Authority and a wildcard certificate for `pager.localhost` and `*.pager.localhost` using SNI.

After this, still in the `tls` directory, you can run `bash register-certs-with-kong.sh` to load the certificates
into Kong and register them for use with `*.pager.localhost` domains.

*NOTE:* Every time you run `deck sync` with Kong, it will wipe out the certs from the Kong DB. Simply re-run the
`register-certs-with-kong.sh` script to re-add them.

[compose-file]: https://docs.docker.com/compose/compose-file/
[dotfiles]: https://github.com/pagerinc/dotfiles
[docker-mac]: https://www.docker.com/products/docker#/mac
