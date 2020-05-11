# Description
This is, in essence, Linux (or part of it) compiled to JS, it is also a toolchain you can use to compile your own C code to Javascript, using mostly POSIX tools, LLVM+clang, binaryen, compilerrt and musl.

No one can destroy the Metal. I saw the talk, and I heard the band.

# Start working

First of all, your build of LLVM+clang must have WebAssembly support built in. Currently, it is also necessary to install the fork of binaryen presented as a submodule. No one knows Metal, and my changes are not ready for a pull request to those guys yet.

```sh
git clone git@github.com:quirinpa/metal.git
cd metal
git submodule update --init binaryen
cd binaryen
make
doas make install
```

From here, if you want to build metal yourself (I'm missing some repos, fixing this soon).  You would:

```sh
cd ..
make tar
```

But this shouldn't be necessary, as we build the tar file included in the repo often.

Then you can go to the root of your web project and do the following (replace where apropriate):

```sh
cd /var/www/htdocs
mkdir metal ; cd metal
curl -O https://github.com/quirinpa/metal/raw/master/metal.tar.gz
tar xzf metal.tar.gz
rm metal.tar.gz
mkdir example ; cd example
cat > Makefile <<!
include "../metal.mk"

obj-y := example.o
exe := example.wasm

$(exe): ${obj-y}
	${LINK.c} -o $@ ${obj-y} ${LDLIBS}

all: example.js

clean:
	-rm ${obj-y} ${exe}

.PHONY: all clean
!
cat > example.c <<!
#include <stdio.h>
#include <metal.h>

export int out_l = 32;
export int name_l = 16;

char out[out_l];
char name[name_l];

export
void hello() {
	snprintf(out, "hello %s\n", name);
}

char *name_get() {
	return name;
}

char *out_get() {
	return out;
}
!
make
```

I don't suppose you should copy and paste this part exactly...
```sh
cd ../..
cat > index.html <<!
<!DOCTYPE html>
<html>
	<head>
		<script type="module" src="index.js"></script>
	</head>
</html>
!
cat > index.js <<!
import { strin } from './metal/metal-env.js';
import { hello, name_get, out_get, name_l, out_l, memory } from './metal/example/example.js';

const name = prompt("Please enter your name", "Judas");
strin(memory, name_get(), name, name_l);
hello();
console.log(strout(memory, out_get(), out_l));
!
```

This _should_ get you to the point you have a working example.
