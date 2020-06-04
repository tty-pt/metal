DESTDIR ?= /
PREFIX ?= ${DESTDIR}/usr/local
METAL_PREFIX ?= ${PREFIX}/metal
INSTALL ?= install
INSTALL_MKDIR ?= ${PREFIX}/mk
INSTALL_LIBDIR ?= ${METAL_PREFIX}/lib
INSTALL_INCDIR ?= ${METAL_PREFIX}/include
EXTRACT_SUFX ?= .tar.gz
METAL_V ?= 0.0.3-alpha
RELEASE := metal-${METAL_V}.src${EXTRACT_SUFX}

all:
	# OK

install:
	mkdir -p ${INSTALL_MKDIR}
	${INSTALL} ./mk/metal.mk ${INSTALL_MKDIR}
	${INSTALL} ./mk/hjs.mk ${INSTALL_MKDIR}
	${INSTALL} ./mk/wasm.mk ${INSTALL_MKDIR}
	mkdir -p ${INSTALL_INCDIR}/metal
	${INSTALL} ./include/metal.h ${INSTALL_INCDIR}
	${INSTALL} ./include/metal/full.hjs ${INSTALL_INCDIR}/metal
	${INSTALL} ./include/metal/env.js ${INSTALL_INCDIR}/metal
	mkdir -p ${INSTALL_LIBDIR}
	${INSTALL} ./lib/wasm.syms ${INSTALL_LIBDIR}

${RELEASE}:
	tar czf $@ mk lib include Makefile

release: ${RELEASE}

.PHONY: install release
