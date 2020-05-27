.PHONY: all run clean init dist

wasm2js-env := .\\/metal-env.js
include metal.mk

RTLIB=libclang_rt.builtins-wasm32
llvm-config != which llvm-config && echo "y"
subdirs-$(llvm-config) := tmp/
subdirs-y += musl/ metal-linux/
build-dirs-y := bin/ include/ lib/
GMAKE ?= gmake

include hjs.mk

all: tmp/ lib/${RTLIB}.a lib/libc.a full-metal.js

metal-build := ${build-dirs-y} \
	full-metal.js hjs.mk metal.mk

rtlib-$(llvm-config) := tmp/
full-metal.js: metal-env.js metal.js
metal.js: bin/metal.wasm
bin/metal.wasm: metal-linux/
lib/$(RTLIB).a: ${rtlib-y}
	tar xzf metal.tar.gz $@
lib/libc.a: musl/ include/
$(build-dirs-y):
	mkdir -p ${build-dirs-y}

musl/:
	${GMAKE} -C $@ install
$(subdirs-y):
	${MAKE} -C $@ install

musl/-clean:
	${GMAKE} -C musl/ clean
subdirs-clean := ${subdirs-y:%=%-clean}
$(subdirs-clean):
	${MAKE} -C ${@:%-clean=%} clean

clean: ${subdirs-clean}
	rm -rf full-metal.js ${build-dirs-y} lib/*.a lib/*.o lib/*.specs *.tar.gz

tar: all
	tar zcf metal.tar.gz ${metal-build}

.PHONY: ${subdirs-y} ${subdirs-clean}
