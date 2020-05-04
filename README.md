# Description
Compile C into asm.js. No one can destroy the Metal.

# Dependencies
You will need at least binaryen, and a build of llvm+clang with WebAssembly support. Assuming you have both installed, you would just have to:

```sh
# change the following to the root of your web project.
cd /var/www/htdocs
mkdir metal ; cd metal
curl -O https://github.com/quirinpa/metal/raw/master/metal.tar.gz
tar xzf metal.tar.gz
rm metal.tar.gz
mkdir example ; cd example
cat > Makefile <<!
include "metal.mk"

obj-y := example.o
exe := example.wasm

$(exe): ${obj-y}
	${LINK.c} -o $@ ${obj-y} ${LDLIBS}

all: example.js
!
cat > example.c <<!
#include <stdio.h>

char *ptr;

void hello() {
	snprintf(ptr, "hello world\n");
}

char *ptr_get() {
	return ptr;
}
!
make
```

This generates example.js which you can load using script tags with the type attribute set to "module".

A full example will follow shortly.
