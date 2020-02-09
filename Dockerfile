# v2ray基于Ubuntu下执行脚本
FROM ubuntu:latest as builder
RUN apt-get \
    update \
    && apt-get install curl -y \
    && curl -L -o /tmp/go.sh https://install.direct/go.sh \
    && chmod +x /tmp/go.sh \
    && /tmp/go.sh

#基于apline
FROM alpine:latest

LABEL maintainer="icolin <am-colin@qq.com>"

#指定时区
ENV TZ Asia/Shanghai

#复制ubuntu下的二进制到alpine镜像下
COPY --from=builder /usr/bin/v2ray/v2ray /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/v2ctl /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geoip.dat /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geosite.dat /usr/bin/v2ray/
COPY config.json /etc/v2ray/config.json
COPY start.sh /root/
COPY config /root/

#下载文件,创建目录,增加权限
RUN set -ex && \
    apk \
    --no-cache \
    add ca-certificates privoxy tzdata && \
    mkdir /var/log/v2ray/ &&\
    chmod +x /usr/bin/v2ray/v2ctl && \
    chmod +x /usr/bin/v2ray/v2ray && \

    chmod a+x /root/start.sh && \
    
    mkdir -p /etc/privoxy/log && \

    mkdir -p /etc/v2ray/log && \
    touch /etc/v2ray/log/access.log && \
    touch /etc/v2ray/log/error.log && \
    
    rm -f /etc/privoxy/config && \
    mv /root/config /etc/privoxy/config && \


    rm -rf /var/cache/apk/*
    
ENV PATH /usr/bin/v2ray:$PATH

#执行启动脚本
CMD ["/root/start.sh"]
