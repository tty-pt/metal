ARCH = wasm32
TARGET = ${ARCH}-unknown-unknown-wasm
LLVM_ROOT ?= /usr/local
CC:=${LLVM_ROOT}/bin/clang
DESTDIR := ..
CFLAGS += --sysroot ${DESTDIR} --target=${TARGET}
LDFLAGS += --allow-undefined-file=${DESTDIR}/lib/wasm.syms --export-dynamic
LDFLAGS += -L${DESTDIR}/lib
RTLIB=clang_rt.builtins-wasm32
ldlibs-y := ${DESTDIR}/lib/crt1.o -lc -l${RTLIB}
LD := ${LLVM_ROOT}/bin/wasm-ld
LINK.c := ${LD} ${LDFLAGS}
metal-flags-y := --enable-reference-types
wasm2js-flags-y := -O3 ${metal-flags-y} --enable-mutable-globals
wat2js-flags-y := -O3 ${metal-flags-y} --enable-mutable-globals
wasm2js-filter ?= cat
wasm2js-env ?= ..\\/metal.js

.SUFFIXES: .wasm .js
.wasm.js:
	${BINARYEN_PATH}wasm2js ${wasm2js-flags-y} $< | sed "s/^import { \([^ ]*\) } from 'env';$$/import { \1 } from '${wasm2js-env}';/" | ${wasm2js-filter} > $@
