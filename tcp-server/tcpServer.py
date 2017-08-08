#!/usr/bin/env  python

import socketserver
import sys
import logging

logFormatter = logging.Formatter('[%(asctime)s] [%(levelname)s] %(message)s', '%d/%m/%Y %H:%M:%S')
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

# TODO Implement file logging handler

consoleHandler = logging.StreamHandler(sys.stdout)
consoleHandler.setFormatter(logFormatter)
logger.addHandler(consoleHandler)


class TCPServerHandler(socketserver.BaseRequestHandler):
    """
    The request handler class for our server.

    It is instantiated once per connection to the server, and must
    override the handle() method to implement communication to the
    client.
    """

    def handle(self):
        # self.request is the TCP socket connected to the client
        self.data = self.request.recv(1024).decode('utf-8').strip()
        logger.info("{} wrote:".format(self.client_address[0]))
        logger.info(self.data)
        self.request.send("ack".encode('utf-8'))


if __name__ == "__main__":
    HOST, PORT = (sys.argv[1], int(sys.argv[2]))

    logger.info("Starting TCP Server")

    # Create the server
    server = socketserver.TCPServer((HOST, PORT), TCPServerHandler)

    # Activate the server
    server.serve_forever()
