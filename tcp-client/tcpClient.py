#!/usr/bin/env  python

import socket
import time
import sys
import logging


def connect(connection):
    # Try to connect for 10 minutes
    for index in range(60):
        try:
            logger.info("Connecting to server...")
            connection.connect(address)
            # connection.setblocking(False)
            connection.settimeout(5)
            logger.info("Connection established")
            return
        except Exception as error:
            logger.warning("Connection failed, retrying...")
            logger.debug(str(error))
            time.sleep(10)

    logger.error("Failed to establish connection, exiting")
    sys.exit()


def send_message(connection, data):
    connection.sendall(data.encode('utf-8'))
    logger.info("Sent: " + data)

    try:
        wait_for_server_ack(connection)
        logger.info("Received: ha ha ha!")
    except Exception as error:
        raise error


def wait_for_server_ack(connection):
    for index in range(6):
        try:
            server_response = connection.recv(1024).decode('utf-8')
            if server_response == "ack":
                logger.info("Message acknowledged by server")
                return
            time.sleep(5)
            logger.info("Still waiting for ack...")
        except Exception as error:
            logger.warning("No response from server, trying again after five seconds")
            logger.debug(str(error))
            time.sleep(5)

    raise Exception("Message not acknowledged in one minute")


if __name__ == "__main__":
    logFormatter = logging.Formatter('[%(asctime)s] [%(levelname)s] %(message)s', '%d/%m/%Y %H:%M:%S')
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)

    # TODO Implement file logging handler

    consoleHandler = logging.StreamHandler(sys.stdout)
    consoleHandler.setFormatter(logFormatter)
    logger.addHandler(consoleHandler)

    address = (sys.argv[1], int(sys.argv[2]))
    message = "Something funny"

    logger.info("Starting TCP Client")

    # Wait one minute to allow the gateways to start
    time.sleep(60)

    while True:
        client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        connect(client)

        for i in range(10):
            try:
                send_message(client, message)
                message_sent = True
                break
            except Exception as e:
                logger.error("Send failed, connection is broken, attempting to resend")
                logger.debug(str(e))
                message_sent = False
                client.close()
                client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                connect(client)

        if message_sent:
            client.close()
            time.sleep(5)
        else:
            logger.error("Failed to send and/or acknowledge message in more than 10 minutes, exiting")
            sys.exit()
