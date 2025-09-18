## MySQL/MariaDb source headers

- Registry: [DockerHub](https://hub.docker.com/r/florinbuzec/mysql-src-h/tags/)

> This Docker image contains files that are intended to be used as included headers in CGO UDF development.

> They are stored in ``/usr/include/mysql/`` folder

> Please select the appropiate branch in order to change the software and version of the *Dockerfile*.

```go
package main

/*
#cgo CFLAGS: -I/usr/include/mysql -DMYSQL_DYNAMIC_PLUGIN -DMYSQL_ABI_CHECK
#include <stdio.h>
#include <mysql.h>
// ...
*/
import "C"

// ...
```

> Actual usage as Docker base:
```docker
// ...
COPY --from=florinbuzec/mysql-src-h:mysql-5.7 --chown=mysql:mysql /usr/include/mysql /usr/include/mysql

WORKDIR /app

// ...

RUN go build -buildmode=c-shared -ldflags "-s -w" -o ./dist/library.so

```