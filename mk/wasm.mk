ARCH=wasm32
TARGET=${ARCH}-unknown-unknown
METAL_DESTDIR := ${DESTDIR}/metal
DESTDIR := ${METAL_DESTDIR}
srcdir?=.

LLVM_ROOT:=/usr/local
CC:=${LLVM_ROOT}/bin/clang
CFLAGS += --sysroot ${DESTDIR} --target=${TARGET}
LDFLAGS += --allow-undefined-file=${DESTDIR}/lib/wasm.syms --export-dynamic
LD_CFLAGS += -fuse-ld=${LD} ${LDFLAGS:%=--Wl,%}

LD:=${LLVM_ROOT}/bin/wasm-ld
RTLIB=clang_rt.builtins-wasm32
LDLIBS+=-l${RTLIB}
LINK.c += -resource-dir=${DESTDIR}
PROG_LDLIBS+=-lc

AR=llvm-ar
RANLIB=llvm-ranlib
prefix=
exec_prefix=${prefix}
CROSS-COMPILE=llvm-

.SUFFIXES: .wasm .js
.wasm.js:
	${BINARYEN_PATH}/wasm2js ${wasm2js-flags-y} $< > $@
