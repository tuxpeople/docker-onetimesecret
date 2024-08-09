# Dockerfile for One-Time Secret http://onetimesecret.com
FROM ruby:3.3.4-alpine

WORKDIR /var/lib/onetime

ENV BUILDPKG="build-essential libyaml-dev libevent-dev unzip ruby-dev libssl-dev zlib1g-dev"

COPY config/config /etc/onetime/config
COPY config/fortunes /etc/onetime/fortunes

# hadolint ignore=DL3018,DL3003
RUN adduser ots -h /var/lib/onetime -D && \
 	mkdir -p /var/log/onetime /var/run/onetime /etc/onetime && \
	apk --no-cache --virtual .build-deps add build-base git && \
	git clone https://github.com/onetimesecret/onetimesecret.git && \
	cd onetimesecret && \
	bundle config set deployment true && \
	bundle config set frozen true && \
	bundle config set without 'dev' && \
	bundle lock --update && \
	bundle install && \
  	bin/ots init && \
	apk del .build-deps && \
	chown ots /var/log/onetime /var/run/onetime /var/lib/onetime /etc/onetime && \
 	cp -R etc/* /etc/onetime/ && \
 	chown ots: /var/lib/onetime/* -R

EXPOSE 7143

ENTRYPOINT ["su", "ots", "-c", "bundle exec thin -e dev -R config.ru start"]

EXPOSE 3000
ENV RACK_ENV prod
ENV ONETIMESECRET_SSL=false \
    ONETIMESECRET_HOST=localhost:3000 \
    ONETIMESECRET_SECRET=CHANGEME \
    ONETIMESECRET_REDIS_URL= \
    ONETIMESECRET_COLONEL=
