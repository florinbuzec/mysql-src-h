FROM ubuntu:18.04 as mysql-src

ARG DEBIAN_FRONTEND=noninteractive

RUN echo "deb [trusted=yes] http://archive.debian.org/debian buster main\n\
deb [trusted=yes] http://archive.debian.org/debian-security buster/updates main" > /etc/apt/sources.list

RUN apt-get -y update && \
    apt-get install -y \
        wget gnupg lsb-release ca-certificates && \
    wget https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb && \
    echo 'mysql-apt-config mysql-apt-config/select-server select mysql-8.0\nmysql-apt-config mysql-apt-config/select-product select Ok\nmysql-apt-config mysql-apt-config/select-tools select Enabled' | dpkg -i mysql-apt-config_0.8.29-1_all.deb && \
    apt-get update && apt-get install -y \
        libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/*

#

FROM scratch

COPY --from=mysql-src --chown=1000:1000 /usr/include/mysql /usr/include/mysql

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.license="proprietary" \
      org.label-schema.name="mysql8.0_src_h" \
      org.label-schema.description="MySQL v8.0 source headers" \
      maintainer="Florin Buzec <florin.buzec@gmail.com>" \
      org.label-schema.url="https://github.com/florinbuzec/mysql-src-h" \
      org.label-schema.vcs-url="https://github.com/florinbuzec/mysql-src-h" \
      org.label-schema.cmd="make build" \
      org.opencontainers.image.version="mysql-8.0" \
      org.opencontainers.image.vendor="florinbuzec" \
      org.opencontainers.image.title="Header files for MySQL/MariaDb" \
      org.opencontainers.image.description="Header files for including in UDF CGo libraries for MySQL/MariaDb" \
      org.opencontainers.image.source="https://github.com/florinbuzec/mysql-src-h" \
      org.opencontainers.image.created="2025-09-17"
