## MySQL/MariaDb source headers

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