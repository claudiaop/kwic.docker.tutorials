# TCP Server

## Description
This project consists of a TCP Server written in Python that accepts connections form any number of TCP Clients.
The server has logic to acknowledge every message by sending an `ack`.

# Minimum requirements

Python 3 or above

## Usage
The python script takes two arguments, hostname/IP and port.

To run the script directly use `python3 /build/tcpServer.py HOST PORT`

To use the docker image:
 - build the image using `docker build -t image_name .`
 - start a container using `docker run image_name python3 /build/tcpServer.py HOST PORT`
   - NOTE: please make sure to add the required ports(using `-p`) and hostname(using `-h`) to the docker run command if needed

To use in docker-compose please add the following in your docker-compose.yml file:
```
server:
  build: path_to_Dockerfile
  command: python3 /build/tcpServer.py HOST PORT
```
