FROM ubuntu:xenial

ENV SIAB_VERSION=2.19 \
  SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00+Black-on-White.css,Reverse:-/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css" \
  SIAB_PORT=4200 \
  SIAB_ADDUSER=true \
  SIAB_USER=guest \
  SIAB_USERID=1000 \
  SIAB_GROUP=guest \
  SIAB_GROUPID=1000 \
  SIAB_PASSWORD=putsafepasswordhere \
  SIAB_SHELL=/bin/bash \
  SIAB_HOME=/home/guest \
  SIAB_SUDO=false \
  SIAB_SSL=true \
  SIAB_SERVICE=/:LOGIN \
  SIAB_PKGS=none \
  SIAB_SCRIPT=none \
  SERVICE_NAME=shell \
  SERVICE_4200_TAGS=http \
  SERVICE_4200_CHECK_HTTP=/ \
  SERVICE_4200_CHECK_INTERVAL=60s \
  SERVICE_4200_CHECK_TIMEOUT=10s 

ADD shellinabox_${SIAB_VERSION}_amd64.deb /tmp
RUN apt-get update && \
  apt-get install -y openssl dnsutils jq git iputils-ping net-tools redis-tools netcat mysql-client curl openssh-client sudo strace vim &&\
  dpkg -i /tmp/shellinabox_${SIAB_VERSION}_amd64.deb && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  ln -sf '/etc/shellinabox/options-enabled/00+Black on White.css' \
    /etc/shellinabox/options-enabled/00+Black-on-White.css && \
  ln -sf '/etc/shellinabox/options-enabled/00_White On Black.css' \
    /etc/shellinabox/options-enabled/00_White-On-Black.css && \
  ln -sf '/etc/shellinabox/options-enabled/01+Color Terminal.css' \
    /etc/shellinabox/options-enabled/01+Color-Terminal.css

EXPOSE 4200

VOLUME /etc/shellinabox /var/log/supervisor /home

ADD files/entrypoint.sh /usr/local/sbin/


ENTRYPOINT ["entrypoint.sh"]
CMD ["shellinabox"]
