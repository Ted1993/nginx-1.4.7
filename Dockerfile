FROM  registry.wpython.com/centos:6.6

MAINTAINER xuqiangqiang "739827282@qq.com"

ENV TZ "Asia/Shanghai"

RUN yum -y install pcre-devel tar gcc-c++ openssl openssl-devel supervisor

RUN mkdir -p /var/log/supervisor

ADD ./nginx-1.4.7.tar.gz  /mnt/nginx-1.4.7.tar.gz
ADD ./install_nginx-1.4.7.sh   /mnt/install_nginx-1.4.7.sh
ADD ./config-nginx          /mnt/config-nginx
ADD ./supervisord.conf      /etc/supervisord.conf

RUN sh /mnt/install_nginx-1.4.7.sh

EXPOSE 80 22

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
