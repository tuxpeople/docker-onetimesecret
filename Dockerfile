# Dockerfile for One-Time Secret http://onetimesecret.com
FROM debian:buster-slim

LABEL MAINTAINER Thomas Deutsch <thomas@tuxpeople.org>

ENV BUILDPKG="build-essential libyaml-dev libevent-dev unzip ruby-dev libssl-dev zlib1g-dev bundler"

ADD https://github.com/onetimesecret/onetimesecret/archive/master.zip /tmp/onetime.zip
ADD http://curl.haxx.se/ca/cacert.pem /tmp/cacert.pem

# hadolint ignore=DL3008
RUN apt-get -qq update \
	&& apt-get install -qq --no-install-recommends zlib1g openssl libxml2 ruby ${BUILDPKG} \
	&& useradd ots -d /var/lib/onetime \
	&& mkdir /var/lib/onetime \
	&& chown ots: /var/lib/onetime \
	&& /usr/bin/unzip /tmp/onetime.zip -d /var/lib/onetime/ \
	&& /bin/mv /var/lib/onetime/onetimesecret-master/* /var/lib/onetime/
	
WORKDIR /var/lib/onetime

RUN export SSL_CERT_FILE=/tmp/cacert.pem \
	&& bundle install --frozen --deployment --without=dev \
	&& bin/ots init \
	&& mkdir -p /var/log/onetime /var/run/onetime /var/lib/onetime /etc/onetime \
	&& chown ots /var/log/onetime /var/run/onetime /var/lib/onetime /etc/onetime \
	&& cp -R etc/* /etc/onetime/ \
	&& chown ots: /var/lib/onetime/* -R  \
	&& apt-get remove -y --purge ${BUILDPKG} \
	&& apt-get clean \
	&& apt-get autoremove -y --purge \
	&& rm -rf /tmp/onetime.zip /var/lib/apt/lists/* /tmp/cacert.pem

COPY config/config /etc/onetime/config
COPY config/fortunes /etc/onetime/fortunes

EXPOSE 7143

ENTRYPOINT ["su", "-c", "bundle exec thin -e dev -R config.ru -p 7143 start", "ots"]