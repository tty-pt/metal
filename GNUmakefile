.PHONY: all run clean init dist

include metal.mk

RTLIB=lclang_rt.builtins-wasm32
subdirs-y := tmp/ musl/ metal-linux/

all: lib/${RTLIB}.a lib/libc.a metal.js

version != git rev-parse HEAD
pkg-name := metal-${version}

metal-build := lib/* bin/* metal.js metal.mk

metal.js: bin/metal.wasm

lib/$(RTLIB).a: tmp/
lib/libc.a: musl/
bin/metal.wasm: metal-linux/

musl/:
	gmake -C $@ install
${subdirs-y}:
	${MAKE} -C $@ install

musl/-clean:
	gmake -C musl/ clean
subdirs-clean-y := ${subdirs-y:%=%-clean}
$(subdirs-clean-y):
	${MAKE} -C ${@:%-clean=%} clean

clean:
	rm -rf bin/* lib/*.a lib/*.o lib/*.specs include *.tar.gz

tar: all
	tar zcf ${pkg-name}.tar.gz ${metal-build}

.PHONY: ${subdirs-y} ${subdirs-clean-y}
