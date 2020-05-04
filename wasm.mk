ARCH=wasm32
TARGET=${ARCH}-unknown-unknown
DESTDIR-git != git rev-parse --show-superproject-working-tree
DESTDIR != [[ -z "${DESTDIR-git}" ]] && echo ".." || echo "${DESTDIR-git}"
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
# prefix != cd ${DESTDIR} ; pwd
exec_prefix=${prefix}
CROSS-COMPILE=llvm-

.SUFFIXES: .wasm .js
.wasm.js:
	${BINARYEN_PATH}/wasm2js ${wasm2js-flags-y} $< > $@
