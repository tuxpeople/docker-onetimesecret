# onetimesecret
![Github Workflow Badge](https://github.com/tuxpeople/docker-onetimesecret/actions/workflows/release.yml/badge.svg)
![Github Last Commit Badge](https://img.shields.io/github/last-commit/tuxpeople/docker-onetimesecret)
![Docker Pull Badge](https://img.shields.io/docker/pulls/tdeutsch/onetimesecret)
![Docker Stars Badge](https://img.shields.io/docker/stars/tdeutsch/onetimesecret)
![Docker Size Badge](https://img.shields.io/docker/image-size/tdeutsch/onetimesecret)

## Quick reference
'Keep sensitive info out of your email and chat logs'

Launch [One-Time Secret](http://onetimesecret.com) as a Docker container

Originally from Ant Kenworthy, I made it multiarch for me and did some changes. Based on https://github.com/mcrmonkey/docker-onetimesecret

Some of the configuration and inspiration for this came from https://github.com/carlasouza/docker-onetimesecret

* **Original repository:**
  https://github.com/mcrmonkey/docker-onetimesecret
* **Code repository:**
  https://github.com/tuxpeople/docker-onetimesecret
* **Where to file issues:**
  https://github.com/tuxpeople/docker-onetimesecret/issues
* **Supported architectures:**
  ```amd64```, ```armv7```, ```armv6``` and ```arm64```

## Image tags
- ```latest``` gets automatically built on every push to master and also via a weekly cron job
- Every build creates a tag containing date and time of the build. ```latest``` always points to the newest build. See [tags](https://hub.docker.com/r/tdeutsch/onetimesecret/tags).
## Usage

Either use `docker-compose up`

or run manually:


```bash

docker run --name=onetimesecret -p 7143:7143 --link redis:redis tdeutsch/onetimesecret

```

The container expects to be able to connect to `redis` as the redis hostname
for the storage of secrets.
You can override this in the configuration file.


Or build it yourself:

```bash

docker build . -t='my_onetimesecret'

docker run -d --name redis redis

docker run --name=onetimesecret -p 7143:7143 --link redis:redis -t my_onetimesecret

```

Access it through your browser at `http://localhost:7143`

## Limitations and things to be aware of

* The application generates a link that uses a preconfigured domain and port.
  Right now it is only generating using `localhost:4173`

* The default secret is set to `CHANGEME` in the configuration file. Its
  probably a good idea to change this to something more complex

* The container has a default configuration file. You can either re-build the
  container or map your own configuration file in to the container using the
  docker volume option.