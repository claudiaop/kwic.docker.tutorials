FROM python:3.6.2-alpine3.6

ENV  PATH=$PATH:/build/

ARG waitForBeforeClosing
ENV waitForContainer=${waitForBeforeClosing}

COPY tcpServer.py /build/
COPY runTcpServer.sh /build/
RUN chmod -R +x /build/


