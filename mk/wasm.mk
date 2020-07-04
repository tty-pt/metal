ARCH=wasm32
TARGET=${ARCH}-unknown-unknown

METAL_V ?= 0.0.4-alpha
m := ${METAL_MODE}

INSTALL ?= install
srcdir?=.

DESTDIR ?= /
PREFIX ?= ${DESTDIR}usr/local

# install dirs and metal-prefix
METAL_PATH ?= /usr/local/metal

metal-path- := ${PREFIX}/metal
metal-path-dev := ${METAL_PATH}
metal-path := ${metal-path-${m}}

INSTALL_MKDIR ?= ${metal-path}/mk
INSTALL_LIBDIR ?= ${metal-path}/lib
INSTALL_INCDIR ?= ${metal-path}/include

METAL_HTDOCS ?= /var/www/htdocs/neverdark-dev
install-bindir-dev := ${METAL_HTDOCS}
install-bindir- := ${metal-path}/bin
INSTALL_BINDIR ?= ${install-bindir-${m}}

LLVM_ROOT:=/usr/local
CC:=${LLVM_ROOT}/bin/clang
CFLAGS += --sysroot ${METAL_PATH} --target=${TARGET}
LD_CFLAGS += -fuse-ld=${LD} -Wl,--allow-undefined-file=${METAL_PATH}/lib/wasm.syms,--export-dynamic

LD:=${LLVM_ROOT}/bin/wasm-ld
LINK.c := ${CC} ${CFLAGS} ${LD_CFLAGS} -resource-dir=${METAL_PATH}

AR=llvm-ar
RANLIB=llvm-ranlib
prefix=
exec_prefix=${prefix}
CROSS-COMPILE=llvm-

.SUFFIXES: .wasm .js
.wasm.js:
	wasm2js -Oz --enable-reference-types --enable-mutable-globals $< > $@
