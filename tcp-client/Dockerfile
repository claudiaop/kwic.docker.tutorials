FROM python:3.6.2-alpine3.6
    
ENV PATH=$PATH:/build/

COPY tcpClient.py /build/
COPY wait-for-host-and-port.sh /build/
COPY runTcpClient.sh /build/
RUN chmod -R +x /build


