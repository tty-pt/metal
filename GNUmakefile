.PHONY: all run clean init dist

wasm2js-env := .\\/metal-env.js
include metal.mk

RTLIB=lclang_rt.builtins-wasm32
subdirs := tmp/ musl/ metal-linux/
build-dirs-y := bin/ include/ lib/
GMAKE ?= gmake

all: tmp/ lib/${RTLIB}.a lib/libc.a metal.js

metal-build := ${build-dirs-y} \
	metal.js metal-env.js metal.mk

metal.js: bin/metal.wasm
bin/metal.wasm: metal-linux/
lib/$(RTLIB).a: tmp/
lib/libc.a: musl/ include/
$(build-dirs-y):
	mkdir -p ${build-dirs-y}

musl/:
	${GMAKE} -C $@ install
$(subdirs):
	${MAKE} -C $@ install

musl/-clean:
	${GMAKE} -C musl/ clean
subdirs-clean := ${subdirs:%=%-clean}
$(subdirs-clean):
	${MAKE} -C ${@:%-clean=%} clean

clean: ${subdirs-clean}
	rm -rf ${build-dirs-y} lib/*.a lib/*.o lib/*.specs *.tar.gz

tar: all
	tar zcf metal.tar.gz ${metal-build}

.PHONY: ${subdirs} ${subdirs-clean}
