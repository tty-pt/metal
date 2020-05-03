ARCH=wasm32
TARGET=${ARCH}-unknown-unknown
srcdir?=.
sysroot:=${srcdir}/..

LLVM_ROOT:=/usr/local
CC:=${LLVM_ROOT}/bin/clang
CFLAGS += --sysroot ${sysroot} --target=${TARGET}
LDFLAGS += --allow-undefined-file=${sysroot}/lib/wasm.syms --export-dynamic
LD_CFLAGS += -fuse-ld=${LD} ${LDFLAGS:%=--Wl,%}

LD:=${LLVM_ROOT}/bin/wasm-ld
RTLIB=clang_rt.builtins-wasm32
LDLIBS+=-l${RTLIB}
LINK.c += -resource-dir=${sysroot}
PROG_LDLIBS+=-lc

AR=llvm-ar
RANLIB=llvm-ranlib
SHARED_LIBS=

# not using DESTDIR anymore, because I want musl-gcc
# to work. Requires further study.
prefix != cd ${sysroot} ; pwd
exec_prefix=${prefix}
CROSS-COMPILE=llvm-
