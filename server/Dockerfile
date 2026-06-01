FROM alpine:latest

LABEL MAINTAINER="SliverHorn@sliver_horn@qq.com"

ENV TZ=Asia/Shanghai
RUN apk update && apk add --no-cache tzdata openntpd \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /go/src/github.com/flipped-aurora/gin-vue-admin/server

COPY server ./
COPY resource ./resource/
COPY config.docker.yaml ./

EXPOSE 8888
ENTRYPOINT ./server -c config.docker.yaml
