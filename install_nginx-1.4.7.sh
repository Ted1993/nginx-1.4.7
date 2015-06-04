#!/bin/bash
rm -rf nginx-1.4.7

grep "^www:" /etc/passwd &> /dev/null  || groupadd www && useradd -g www  -s /sbin/nologin  www

if [ ! -f nginx-1.4.7.tar.gz ];then
  wget http://test-oracle.oss-cn-hangzhou.aliyuncs.com/nginx-1.4.7.tar.gz
fi

tar zxvf nginx-1.4.7.tar.gz
cd nginx-1.4.7
./configure --user=www \
--group=www \
--prefix=/data/server/nginx \
--with-http_stub_status_module \
--without-http-cache \
--with-http_ssl_module \
--with-http_gzip_static_module
CPU_NUM=$(cat /proc/cpuinfo | grep processor | wc -l)
if [ $CPU_NUM -gt 1 ];then
    make -j$CPU_NUM
else
    make
fi
make install

mkdir -p  /data/www/default
mkdir -p /data/log/nginx/access
chmod 775 /data/server/nginx/logs
chown -R www:www /data/server/nginx/logs
chmod -R 775 /data/www
chown -R www:www /data/www
cd ..
cp -fR /mnt/config-nginx/* /data/server/nginx/conf/
chmod 755 /data/server/nginx/sbin/nginx
#/data/server/nginx/sbin/nginx
mv /data/server/nginx/conf/nginx /etc/init.d/
chmod +x /etc/init.d/nginx
chkconfig --add nginx
echo "Hello World" >> /data/www/default/index.html && service nginx start
