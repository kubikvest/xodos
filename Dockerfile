FROM imega/base-builder:1.2.0

MAINTAINER Dmitry Gavriloff <info@imega.ru>

VOLUME ["/tmp"]

ADD build/rootfs.tar.gz /

CMD ["/usr/sbin/nginx", "-g", "daemon off;", "-p", "/app", "-c", "/nginx.conf"]
