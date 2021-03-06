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
ADD https://github.com/liquibase/liquibase/releases/download/v4.6.2/liquibase-4.6.2.tar.gz liquibase-4.6.2.tar.gz
RUN tar -xzf liquibase-4.6.2.tar.gz \
    && rm liquibase-4.6.2.tar.gz

# add package manager (lpm)
ADD https://github.com/liquibase/liquibase-package-manager/releases/download/v0.1.0/lpm-0.1.0-linux.zip lpm.zip
RUN mkdir bin \
    && unzip lpm.zip -d bin \
    && rm -f lpm.zip


COPY --chmod=500 --chown=liquibase:liquibase liquibase /liquibase/
RUN ln -s /liquibase/liquibase /usr/local/bin/liquibase

# fix h2 vuln
RUN /liquibase/bin/lpm update h2 \
    && /liquibase/bin/lpm add h2 \
    && rm -f lib/h2-1.4.200.jar
USER liquibase
