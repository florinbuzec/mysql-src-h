FROM debian:buster AS mariadb-src

ARG DEBIAN_FRONTEND=noninteractive
ARG MARIADB_VERSION=10.6.19

RUN echo "deb [trusted=yes] http://archive.debian.org/debian buster main\n\
deb [trusted=yes] http://archive.debian.org/debian-security buster/updates main" > /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y \
        wget curl gnupg lsb-release cmake cpp make gcc g++ \
        libncurses5-dev libssl-dev bison pkg-config \
        libaio-dev libz-dev libbz2-dev liblz4-dev libsnappy-dev \
        libboost-dev libreadline-dev libpam0g-dev && \
    rm -rf /var/lib/apt/lists/*

RUN curl "https://archive.mariadb.org/mariadb-${MARIADB_VERSION}/source/mariadb-${MARIADB_VERSION}.tar.gz" -L -o "/tmp/mariadb-src.tar.gz" && \
    tar -xzf /tmp/mariadb-src.tar.gz -C /usr/local/src && \
    rm /tmp/mariadb-src.tar.gz

WORKDIR /usr/local/src/mariadb-${MARIADB_VERSION}

# >500 seconds
RUN mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo -DPLUGIN_ROCKSDB=NO -DWITH_ROCKSDB=OFF && \
    make -j$(nproc) && \
    make install DESTDIR=/tmp/mariadb-install

RUN mv /tmp/mariadb-install/usr/local/mysql/include/mysql /usr/include/mysql

#

FROM scratch

COPY --from=mariadb-src --chown=1000:1000 /usr/include/mysql /usr/include/mysql

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.license="proprietary" \
      org.label-schema.name="mariadb10.6.19_src_h" \
      org.label-schema.description="MariaDb v10.6.19 source headers" \
      maintainer="Florin Buzec <florin.buzec@gmail.com>" \
      org.label-schema.url="https://github.com/florinbuzec/mysql-src-h" \
      org.label-schema.vcs-url="https://github.com/florinbuzec/mysql-src-h" \
      org.label-schema.cmd="make build" \
      org.opencontainers.image.version="mariadb-10.6.19" \
      org.opencontainers.image.vendor="florinbuzec" \
      org.opencontainers.image.title="Header files for MySQL/MariaDb" \
      org.opencontainers.image.description="Header files for including in UDF CGo libraries for MySQL/MariaDb" \
      org.opencontainers.image.source="https://github.com/florinbuzec/mysql-src-h" \
      org.opencontainers.image.created="2025-09-17"
