ARCH=wasm32
TARGET=${ARCH}-unknown-unknown

INSTALL ?= install
srcdir?=.
DESTDIR ?= /
PREFIX ?= ${DESTDIR}usr/local
METAL_PREFIX ?= ${PREFIX}/metal
INSTALL_BINDIR ?= ${METAL_PREFIX}/bin
INSTALL_LIBDIR ?= ${METAL_PREFIX}/lib
INSTALL_INCDIR ?= ${METAL_PREFIX}/include

LLVM_ROOT:=/usr/local
CC:=${LLVM_ROOT}/bin/clang
CFLAGS += --sysroot ${METAL_PREFIX} --target=${TARGET}
LD_CFLAGS += -fuse-ld=${LD} -Wl,--allow-undefined-file=${METAL_PREFIX}/lib/wasm.syms,--export-dynamic

LD:=${LLVM_ROOT}/bin/wasm-ld
LINK.c := ${CC} ${CFLAGS} ${LD_CFLAGS} -resource-dir=${METAL_PREFIX}

AR=llvm-ar
RANLIB=llvm-ranlib
prefix=
exec_prefix=${prefix}
CROSS-COMPILE=llvm-
metal-flags-y := --enable-reference-types
wasm2js-flags-y := -Oz ${metal-flags-y} --enable-mutable-globals
WASM2JS = ${PREFIX}/bin/wasm2js ${wasm2js-flags-y}

.SUFFIXES: .wasm .js
.wasm.js:
	${WASM2JS} $< > $@
