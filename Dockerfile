# Dockerfile for One-Time Secret http://onetimesecret.com
FROM ruby:3.0.2-alpine

LABEL MAINTAINER Thomas Deutsch <thomas@tuxpeople.org>

WORKDIR /var/lib/onetime

ENV BUILDPKG="build-essential libyaml-dev libevent-dev unzip ruby-dev libssl-dev zlib1g-dev"

# hadolint ignore=DL3018
RUN adduser ots -h /var/lib/onetime -D && \
 	mkdir -p /var/log/onetime /var/run/onetime /etc/onetime && \
	apk --no-cache --virtual .build-deps add build-base && \
	gem install bundler:1.12.5 && \
	git clone git@github.com:onetimesecret/onetimesecret.git && \
	cd onetimesecret && \
	bundle install --frozen && \
  	bin/ots init && \
	apk del .build-deps

COPY config/config /etc/onetime/config
COPY config/fortunes /etc/onetime/fortunes

RUN chown ots /var/log/onetime /var/run/onetime /var/lib/onetime /etc/onetime && \
 	cp -R etc/* /etc/onetime/ && \
 	chown ots: /var/lib/onetime/* -R

EXPOSE 7143

ENTRYPOINT ["su", "ots", "-c", "bundle exec thin -e dev -R config.ru -p 7143 start"]