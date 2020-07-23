
# Auto Generated Dockerfile
FROM wso2/wso2micro-gw:latest

LABEL maintainer="dev@ballerina.io"

WORKDIR /home/ballerina

COPY pizzashack.jar /home/ballerina
COPY micro-gw.conf /home/ballerina/conf/micro-gw.conf


CMD gateway pizzashack.jar
