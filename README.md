# Description
This is, in essence, Linux (or part of it) compiled to JS, it is also a toolchain you can use to compile your own C code to Javascript, using mostly POSIX tools, LLVM+clang and binaryen.


Other things used to build metal.tar.gz are Linux, compilerrt and musl.


No one can destroy the Metal. I saw the talk, and I heard the band.


I am very noob in many ways, and I have much to learn. Although, I am a subscriber of Linus Torvalds' philosophy, for I believe he knows his shit:


Actions speak louder than words.


I've come to a point in my life where I don't feel like putting up with the bullshit anymore.
I want to do something with my life, as a gift to someone I love, and there isn't an npc I  wouldn't crash to gain xp.
I will exorcise demons! And expose shadows with my Kamehameha!

# Start working
This example assumes your build of LLVM+clang has WebAssembly support and that it and binaryen are installed and accessible through the PATH environment variable.

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
#include <metal.h>

export
unsigned max_len = 64;

char buf[max_len];

export
void hello() {
	snprintf(buf, "hello %s\n", buf);
}

char *buf_get() {
	return buf;
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
import { strin, memory_resolve } from './metal/metal-env.js';
import { hello, buf_get, max_len, memory } from './metal/example/example.js';

memory_resolve(memory);
const name = prompt("Please enter your name", "Judas");
instr(memory, buf_get(), name, max_len);
hello();
!
```

This _should_ get you to the point you have a working example.


I really need help testing it on Linux.

# Building / developing the Metal
Currently I have no access to the modified LLVM source code.
I'm not sure I will have access to the disk in the future for deeply personal reasons.
Neither am I willing to insist about it. I'll do it from scratch if have to.
I think meanwhile they have dropped ELF support among other things.
I will keep using this though, because I find it useful.


The rest is in the hands of fate.

# Plans
Compile time option to choose between WebAssembly and asm.js.
