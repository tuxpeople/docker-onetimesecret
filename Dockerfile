# Dockerfile for One-Time Secret http://onetimesecret.com
FROM debian:buster-slim

LABEL MAINTAINER Thomas Deutsch <thomas@tuxpeople.org>

ENV BUILDPKG="build-essential libyaml-dev libevent-dev unzip ruby-dev libssl-dev zlib1g-dev"

ADD https://github.com/onetimesecret/onetimesecret/archive/master.zip /tmp/onetime.zip

RUN apt-get -qq update \
	&& apt-get install -qq zlib1g openssl libxml2 ruby bundler ${BUILDPKG}\
	&& useradd ots -d /var/lib/onetime \
	&& mkdir /var/lib/onetime \
	&& chown ots: /var/lib/onetime \
	&& /usr/bin/unzip /tmp/onetime.zip -d /var/lib/onetime/ \
	&& /bin/mv /var/lib/onetime/onetimesecret-master/* /var/lib/onetime/ \
	&& rm -f /tmp/onetime.zip \
	&& cd /var/lib/onetime \
	&& bundle install --frozen --deployment --without=dev \
	&& bin/ots init \
	&& mkdir -p /var/log/onetime /var/run/onetime /var/lib/onetime /etc/onetime \
	&& chown ots /var/log/onetime /var/run/onetime /var/lib/onetime /etc/onetime \
	&& cp -R etc/* /etc/onetime/ \
	&& chown ots: /var/lib/onetime/* -R  \
	&& apt-get remove -y --purge ${BUILDPKG} \
	&& apt-get clean \
	&& apt-get autoremove -y --purge

ADD config/config /etc/onetime/config
ADD config/fortunes /etc/onetime/fortunes

WORKDIR /var/lib/onetime

EXPOSE 7143

ENTRYPOINT su -c 'bundle exec thin -e dev -R config.ru -p 7143 start' ots