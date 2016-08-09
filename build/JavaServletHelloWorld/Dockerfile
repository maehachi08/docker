From docker.io/centos:latest
MAINTAINER Kazunori Maehata
ENV container docker

RUN yum update  -y && yum clean all

# Apache + Tomcatインストールスクリプトの実行
ADD scripts/install-httpd-tomcat.sh /tmp/install-httpd-tomcat.sh
RUN sh /tmp/install-httpd-tomcat.sh

# tomcatサーバへプロキシするための設定ファイルを配布
ADD etc/httpd/conf.d/tomcat.conf /etc/httpd/conf.d/tomcat.conf

# JavaServletのHelloWorldアプリを配布
ADD hello /var/lib/tomcat/webapps/hello/

# supervisord でプロセス起動する
ADD etc/supervisord.conf /etc/supervisord.conf
ADD etc/supervisord.d/apache_tomcat.ini /etc/supervisord.d/apache_tomcat.ini

# コンテナ起動時に実行する
# 
# httpdプロセス単体を起動するのはこれだけでもよい
# CMD ["/usr/sbin/httpd", "$OPTIONS", "-DFOREGROUND"]
#
# httpd + tomcatなど複数サービスを起動する場合はsupervisordなどを併用する
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# コンテナ外部に開放するポートを指定する
EXPOSE 80
