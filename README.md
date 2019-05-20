# mongodb
MongoDB on Docker

## Configuration

Authentication Support:

- To enable auth, set `MONGODB_AUTH_ENABLED=true` and your username and password with `MONGODB_USER` and `MONGODB_PASSWORD`.

Supported Environment Variables:

```
MONGODB_AUTH_ENABLED (auth defaults to false)
MONGODB_USER
MONGODB_PASSWORD
```

## Usage

Build:

```
$ git clone https://github.com/bekkerstacks/mongodb
$ docker build -t local-mongodb .
```

Run:

```
$ docker run -itd --name mongodb \
  -e MONGODB_AUTH_ENABLED=true 
  -e MONGODB_USER=ruan 
  -e MONGODB_PASSWORD=password \
  local-mongodb
```

Connect:

```
$ mongo --host 127.0.0.1 --port 27017 -u ruan -p password --authenticationDatabase admin
```
