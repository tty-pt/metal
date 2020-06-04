DESTDIR ?= /
PREFIX ?= ${DESTDIR}/usr/local
METAL_PREFIX ?= ${PREFIX}/metal
INSTALL ?= install
INSTALL_MKDIR ?= ${PREFIX}/mk
INSTALL_LIBDIR ?= ${METAL_PREFIX}/lib
INSTALL_INCDIR ?= ${METAL_PREFIX}/include
EXTRACT_SUFX ?= .tar.gz
METAL_V ?= 0.0.3-alpha
METAL_SUFX := $(METAL_V).src$(EXTRACT_SUFX)
metal-release-main := metal-$(METAL_SUFX)
metal-modules := metal-linux metal-musl
metal-release-modules := ${metal-modules:%=%-${METAL_SUFX}}
metal-release := ${metal-release-main} ${metal-release-modules}

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

$(metal-release-main):
	tar czf $@ mk lib include Makefile

$(metal-release-modules):
	tar czf $@ ${@:metal-%-${METAL_SUFX}=%}/*

release: ${metal-release}

.PHONY: install release
