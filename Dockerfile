FROM alpine:3.16 as build

RUN apk update && apk add \
    build-base \
    rsync \
    yaml \
    yaml-dev \
    lua5.3 \
    lua5.3-dev \
    luarocks5.3

RUN luarocks-5.3 install luafilesystem && \
    luarocks-5.3 install date && \
    luarocks-5.3 install lcmark && \
    luarocks-5.3 install lyaml

WORKDIR /app
COPY . /app

RUN make

FROM ipfs/kubo:v0.16.0

COPY --from=build /app/public /public

COPY entrypoint.sh /container-init.d/entrypoint.sh
RUN chmod a+x /container-init.d/entrypoint.sh

EXPOSE 4001/udp
EXPOSE 4001/tcp
EXPOSE 8080
