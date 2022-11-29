# MapSCII Telnet Server

A ready to use Docker image to serve MapSCII over a telnet server exactly like mapscii.me

## Repository

[https://github.com/benjamin-feron/mapscii-telnet-server](https://github.com/benjamin-feron/mapscii-telnet-server)

## Usage

```sh
$ docker run -d -p 23:23 benjaminferon/mapscii-telnet-server
$ telnet localhost
```

### With docker-compose

docker-compose.yml :
```yml
version: "3.3"

services:
  mapscii-telnet-server:
    image: benjaminferon/mapscii-telnet-server:latest
    restart: unless-stopped
    network_mode: host
    ports:
      - 23:23
```

```sh
$ docker-compose up -d
$ telnet localhost
```

### Integration with traefik

As it says [here](https://github.com/traefik/traefik/issues/6838), in a case where the server is the first to send data on the TCP stream,
it works only if both of those conditions are met :
1. The TCP router rule is ```rule: HostSNI(`*`)```
2. The TCP router is the only of all (TCP or HTTP) routers listening to the corresponding entrypoint

With MAPScii, we are in this situation so we have to declare a MAPScii dedicated entrypoint.

```sh
$ docker network create -d bridge telnet
```

Traefik static configuration :
```yml
entrypoints:
  mapscii-dedicated:
    address: :23
```

MAPScii docker-compose.yml :
```yml
version: "3.3"

networks:
  telnet:
    external: true

services:
  mapscii-telnet-server:
    image: benjaminferon/mapscii-telnet-server:latest
    container_name: mapscii-telnet-server
    restart: unless-stopped
    networks:
      - telnet
    labels:
      traefik.enable: true
      traefik.tcp.routers.mapscii.rule: "HostSNI(`*`)"
      traefik.tcp.routers.mapscii.entrypoints: "mapscii-dedicated"
      traefik.tcp.services.mapscii.loadbalancer.server.port: 23
```