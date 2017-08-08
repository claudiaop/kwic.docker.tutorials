# TCP Client

## Description
This project consists of a TCP Client written in Python that connects to TCP Server and sends messages every five seconds.
The client has logic to reconnect and resend messages if the connection should fail or get interrupted.

# Minimum requirements

Python 3 or above

## Usage
The python script takes two arguments, the hostname/IP and port of the server.

To run the script directly use `python3 /build/tcpClient.py HOST PORT`

To use the docker image:
 - build the image using `docker build -t image_name .`
 - start a container using `docker run image_name python3 /build/tcpClient.py HOST PORT`

To use in docker-compose please add the following in your docker-compose.yml file:
```
server:
  build: path_to_Dockerfile
  command: python3 /build/tcpClient.py HOST PORT
```
  - to run multiple clients please add `--scale service_name=number_of_containers` to the docker-compose command
