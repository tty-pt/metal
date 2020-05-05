# Description
This is Linux (or part of it) compiled to JS.
The standard libraries and everything needed to start compiling C to JS.


No one can destroy the Metal. I saw the talk.

# Motivation
A C WebAssembly kernel seemed interesting and I couldn't get Emscripten to work on OpenBSD.

# Start working
You will need at binaryen, and a build of llvm+clang with WebAssembly support.
You can configure these, but the example assumes you have both installed.

```sh
# change the following to the root of your web project.
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

MEXPORT
unsigned max_len = 64;

char buf[max_len];

void hello() {
	snprintf(buf, "hello %s\n", buf);
}

char *buf_get() {
	return buf;
}
!
make
```

I don't suppose you should copy and paste this part exactly. Beware.
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
import { strin, memory_resolve } from './metal/metal-env.js';
import { hello, buf_get, max_len, memory } from './metal/example/example.js';

memory_resolve(memory);
const name = prompt("Please enter your name", "Judas");
instr(memory, buf_get(), name, max_len);
!
```

Again, this _should_ get you to the point you have a working example.

I really need help testing this out on Linux.

# Building / developing the Metal
Currently I have no access to the modified LLVM source code.
I'm not sure I will have access to the disk in the future for deeply personal reasons.
Neither am I willing to insist about it. I'll do it from scratch if have to.
I think meanwhile they have dropped ELF support among other things.
I will keep using this though, because I find it useful.


The rest is in the hands of fate.
And METAL FATE ROCKS.
