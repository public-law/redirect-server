# Redirect Server

## To build the Docker image

```
docker build -t redirector-test .
```

## To run the Docker container

```
docker run --rm -it -e PORT=4000 -p 4000:4000 redirector-test
```

## To run the tests

```
mix test
```


## Docs

* Official website: http://www.phoenixframework.org/
* Guides: http://phoenixframework.org/docs/overview
* Docs: https://hexdocs.pm/phoenix
