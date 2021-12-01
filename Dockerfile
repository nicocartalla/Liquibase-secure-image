FROM alpine:3.14

RUN adduser liquibase -h /liquibase -s /sbin/nologin --disabled-password
RUN  apk update \
  && apk upgrade \
  && apk add ca-certificates \
  && update-ca-certificates \
  && apk add --update coreutils && rm -rf /var/cache/apk/*   \
  && apk add --update openjdk11-jre \
  && apk add --no-cache nss \
  && rm -rf /var/cache/apk/*

WORKDIR /liquibase
# Install Latest Liquibase Release Version
ADD https://github.com/liquibase/liquibase/releases/download/v4.6.1/liquibase-4.6.1.tar.gz liquibase-4.6.1.tar.gz
RUN tar -xzf liquibase-4.6.1.tar.gz \
    && rm liquibase-4.6.1.tar.gz

COPY --chmod=500 --chown=liquibase:liquibase liquibase /liquibase/
RUN ln -s /liquibase/liquibase /usr/local/bin/liquibase

USER liquibase
