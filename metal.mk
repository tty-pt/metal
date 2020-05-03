ARCH=wasm32
# TARGET=${ARCH}-unknown-unknown
TARGET=${ARCH}-unknown-unknown-wasm
sysroot:=.
LLVM_ROOT:=/usr/local
CC:=${LLVM_ROOT}/bin/clang
# CFLAGS += --sysroot ${sysroot} --target=${TARGET} -c -S -emit-llvm -I${sysroot}/include
CFLAGS += --sysroot ${sysroot} --target=${TARGET} -I${sysroot}/include
LDFLAGS += -L${sysroot}/lib
WLDFLAGS := --allow-undefined-file=${sysroot}/lib/wasm.syms --export-dynamic
LDFLAGS += ${WLDFLAGS}
RTLIB=clang_rt.builtins-wasm32
ldlibs-y := ${sysroot}/lib/crt1.o -lc -l${RTLIB}
LD := ${LLVM_ROOT}/bin/wasm-ld
LINK.c := ${LD} ${LDFLAGS}
be := ${sysroot}/binaryen
metal-flags-y := --enable-reference-types
wasm2js-flags-y := -O3 ${metal-flags-y} --enable-mutable-globals
wat2js-flags-y := -O3 ${metal-flags-y} --enable-mutable-globals

.SUFFIXES: .wasm .wat .js

.wat.js:
	${be}/wasm2js ${wasm2js-flags-y} $< > $@

.wasm.js:
	${be}/wasm2js ${wasm2js-flags-y} $< > $@

.wasm.wat:
	${wasm2wat} ${metal-flags-y} --fold-expr $< > $@

.wat.wasm:
	${wat2wasm} ${metal-flags-y} $< > $@

