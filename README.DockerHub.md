## MySQL/MariaDb source headers

- Source code: [GitHub](https://github.com/florinbuzec/mysql-src-h)

> This Docker image contains files that are intended to be used as included headers in CGO UDF development.

> They are stored in ``/usr/include/mysql/`` folder

> Please select the appropiate tag in order to change the software and version of the *Dockerfile*.

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
COPY --from=florinbuzec/mysql-src-h:mariadb-10.2.44 --chown=mysql:mysql /usr/include/mysql /usr/include/mysql

WORKDIR /app

// ...

RUN go build -buildmode=c-shared -ldflags "-s -w" -o ./dist/library.so

```