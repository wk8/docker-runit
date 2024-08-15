# runit-docker

Toy example showing how to use [runit](http://smarden.org/runit/) in a Docker container!

## Why??

The process started by your container's `CMD` or `ENTRYPOINT` runs with PID 1 inside the container's PID space, and when it dies, so does the container.

Normally, that's what you want: when your container's main process dies, you want that event to kill the container with it, so that your orchestrator can restart another replica.

But sometimes you'd want to be able to stop, or restart, your container's main process; notably in dev. For example, say you want to attach a debugger to your application, or you want to be able to just re-start your service inside the
container with your latest changes, and re-building the image every time is
too cumbersome; but at the same time, you _do_ want your image to _just work_ when you start it.

## Usage

The very simple [Dockerfile](https://github.com/wk8/docker-runit/blob/master/Dockerfile) in this repo shows how to build your image to let `runit` manage your service inside the container.

If you want to play around with it yourself, clone this repo, then build the image:
```bash
docker build . -t docker-runit
```

Then start your new image:
```
docker run --rm --name=docker-runit docker-runit
```

It should start outputting (and generally behave exactly the same) as if our Dockerfile had simply been:
```dockerfile
FROM ubuntu

WORKDIR /my_service

COPY my_service .

CMD ["./my_service"]
```

Now let's `exec` inside that container:
```bash
docker exec -it docker-runit sh
```

You can stop or restart your service as many times as you want:
```bash
service my_service status
service my_service stop
service my_service start
service my_service restart
```

Notice how your service's PID changes every time you restart it.


## Warning!

This is _not_ meant to be used in anything remotely resembling production. Orchestrators are built with the assumption that a container is still fulfilling its function if it's running.
