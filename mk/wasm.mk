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
LDFLAGS := --allow-undefined-file=${METAL_PREFIX}/lib/wasm.syms --export-dynamic ${LDFLAGS}
LD_CFLAGS += -fuse-ld=${LD} ${LDFLAGS:%=--Wl,%}

LD:=${LLVM_ROOT}/bin/wasm-ld
RTLIB=clang_rt.builtins-wasm32
# LDLIBS+=-l${RTLIB}
LINK.c += -resource-dir=${METAL_PREFIX}
PROG_LDLIBS+=-lc

AR=llvm-ar
RANLIB=llvm-ranlib
prefix=
exec_prefix=${prefix}
CROSS-COMPILE=llvm-

.SUFFIXES: .wasm .js
.wasm.js:
	${BINARYEN_PATH}/wasm2js ${wasm2js-flags-y} $< > $@
