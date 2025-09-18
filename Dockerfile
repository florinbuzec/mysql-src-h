FROM ubuntu:18.04 as mysql-src

ARG DEBIAN_FRONTEND=noninteractive

RUN echo "deb [trusted=yes] http://archive.debian.org/debian buster main\n\
deb [trusted=yes] http://archive.debian.org/debian-security buster/updates main" > /etc/apt/sources.list

RUN apt-get -y update && \
    apt-get install -y \
        wget gnupg lsb-release ca-certificates multiarch-support && \
    rm -rf /var/lib/apt/lists/*

# updated with officials
RUN wget https://downloads.mysql.com/archives/get/p/23/file/libmysqlclient20_5.7.25-1debian8_amd64.deb && \
    wget https://downloads.mysql.com/archives/get/p/23/file/libmysqlclient20-dbgsym_5.7.25-1debian8_amd64.deb && \
    wget https://downloads.mysql.com/archives/get/p/23/file/mysql-common_5.7.25-1debian8_amd64.deb && \
    wget https://downloads.mysql.com/archives/get/p/23/file/libmysqlclient-dev_5.7.25-1debian8_amd64.deb && \
    dpkg -i mysql-common_5.7.25-1debian8_amd64.deb && \
    dpkg -i libmysqlclient20_5.7.25-1debian8_amd64.deb && \
    dpkg -i libmysqlclient20-dbgsym_5.7.25-1debian8_amd64.deb && \
    dpkg -i libmysqlclient-dev_5.7.25-1debian8_amd64.deb

#

FROM scratch

COPY --from=mysql-src --chown=1000:1000 /usr/include/mysql /usr/include/mysql

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.license="proprietary" \
      org.label-schema.name="mysql5.7_src_h" \
      org.label-schema.description="MySQL v5.7 source headers" \
      maintainer="Florin Buzec <florin.buzec@gmail.com>" \
      org.label-schema.url="https://github.com/florinbuzec/mysql-src-h" \
      org.label-schema.vcs-url="https://github.com/florinbuzec/mysql-src-h" \
      org.label-schema.cmd="make build" \
      org.opencontainers.image.version="mysql-5.7" \
      org.opencontainers.image.vendor="florinbuzec" \
      org.opencontainers.image.title="Header files for MySQL/MariaDb" \
      org.opencontainers.image.description="Header files for including in UDF CGo libraries for MySQL/MariaDb" \
      org.opencontainers.image.source="https://github.com/florinbuzec/mysql-src-h" \
      org.opencontainers.image.created="2025-09-18"
