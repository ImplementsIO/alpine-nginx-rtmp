FROM alpine:3.4

MAINTAINER Thonatos.Yang <thonatos.yang@gmail.com>
LABEL vendor=implements.io
LABEL io.implements.version=0.1.0

ENV S6_OVERLAY_VERSION=v1.17.2.0 \
    HOME=/root

# update repositories
# RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

# install package
RUN apk add --update curl gcc g++ libgcc make \
    zlib-dev openssl-dev pcre-dev ffmpeg              

# combile nginx
RUN mkdir -p /root/pkg \
    && cd /root/pkg \
    && curl -sSL -o nginx-1.11.5.tar.gz http://nginx.org/download/nginx-1.11.5.tar.gz \
    && tar -xvf nginx-1.11.5.tar.gz \
    && curl -sSL -o v1.1.10.tar.gz https://github.com/arut/nginx-rtmp-module/archive/v1.1.10.tar.gz \    
    && tar -xvf v1.1.10.tar.gz \
    && cd /root/pkg/nginx-1.11.5 \
    && . /root/pkg/nginx-1.11.5/configure --add-module=/root/pkg/nginx-rtmp-module-1.1.10 \
    && make \
    && make install        

# add s6
RUN curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar xfz - -C /

# clean cache & package
RUN apk del curl gcc g++ libgcc make \
    && rm -rf /usr/include /usr/share/man /tmp/* /var/cache/apk/* /root/pkg     

# nginx
RUN ln -sf /dev/stdout /usr/local/nginx/logs/access.log \ 
    && ln -sf /dev/stderr /usr/local/nginx/logs/error.log

# /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/conf.d/ /usr/local/nginx/html

ADD root /

EXPOSE 1935 80 8080 443

ENTRYPOINT ["/init"]