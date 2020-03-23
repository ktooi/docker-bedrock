FROM busybox:latest as unzip
ARG BEDROCK_SERVER_VER=1.12.1.1
COPY bedrock-server-$BEDROCK_SERVER_VER.zip .
RUN mkdir -pv /usr/local/src/bedrock && unzip bedrock-server-$BEDROCK_SERVER_VER.zip -d /usr/local/src/bedrock


FROM ubuntu:18.04
COPY --from=unzip /usr/local/src/bedrock /opt/bedrock
ENV LD_LIBRARY_PATH=/opt/bedrock
RUN apt-get update && apt-get install -y \
  libcurl4
WORKDIR /opt/bedrock
RUN echo $BEDROCK_SERVER_VER > bedrock_server_version
COPY ./entrypoint.sh ./
EXPOSE 19132/udp
VOLUME ["/volume"]
ENTRYPOINT ["/bin/bash", "./entrypoint.sh"]