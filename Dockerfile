# ubuntu 18.04 only has until mysql 8.0.28 that has no included source files
FROM ubuntu:22.04 AS mysql-src

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
        wget ca-certificates && \
    wget -O /tmp/libmysqlclient21.deb               https://repo.mysql.com/apt/ubuntu/pool/mysql-8.0/m/mysql-community/libmysqlclient21_8.0.33-1ubuntu22.04_amd64.deb && \
    wget -O /tmp/libmysqlclient-dev.deb             https://repo.mysql.com/apt/ubuntu/pool/mysql-8.0/m/mysql-community/libmysqlclient-dev_8.0.33-1ubuntu22.04_amd64.deb && \
    wget -O /tmp/mysql-common.deb                   https://repo.mysql.com/apt/ubuntu/pool/mysql-8.0/m/mysql-community/mysql-common_8.0.33-1ubuntu22.04_amd64.deb && \
    wget -O /tmp/mysql-community-client-plugins.deb https://repo.mysql.com/apt/ubuntu/pool/mysql-8.0/m/mysql-community/mysql-community-client-plugins_8.0.33-1ubuntu22.04_amd64.deb && \
    apt-get install -y /tmp/*.deb && \
    rm -f /tmp/*.deb && \
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
      org.opencontainers.image.vendor="florinbuzec" \
      org.opencontainers.image.title="Header files for MySQL/MariaDb" \
      org.opencontainers.image.description="Header files for including in UDF CGo libraries for MySQL/MariaDb" \
      org.opencontainers.image.authors="Florin Buzec <florin.buzec@gmail.com>" \
      org.opencontainers.image.source="https://github.com/florinbuzec/mysql-src-h" \
      org.opencontainers.image.url="https://github.com/florinbuzec/mysql-src-h" \
      org.opencontainers.image.version="mysql-8.0" \
      org.opencontainers.image.created="2025-11-18"
