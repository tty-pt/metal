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
submodules-y := linux musl
gmake-y := musl
submodules-install := ${submodules-y:%=%-install}
gmake-install := ${gmake-y:%=%-install}
submodules-clean := ${submodules-y:%=%-clean}
submodules-release := ${submodules-y:%=metal-%-${METAL_SUFX}}
metal-release := ${metal-release-main} ${submodules-release}
GMAKE := gmake
MKFLAGS += MKDIR=${PWD}/mk

all: ${submodules-y}

install: ${submodules-install}
	mkdir -p ${INSTALL_MKDIR}
	${INSTALL} ./mk/hjs.mk ${INSTALL_MKDIR}
	${INSTALL} ./mk/wasm.mk ${INSTALL_MKDIR}
	mkdir -p ${INSTALL_INCDIR}/metal
	${INSTALL} ./include/metal.h ${INSTALL_INCDIR}
	${INSTALL} ./include/metal/full.hjs ${INSTALL_INCDIR}/metal
	${INSTALL} ./include/metal/env.js ${INSTALL_INCDIR}/metal
	mkdir -p ${INSTALL_LIBDIR}
	${INSTALL} ./lib/wasm.syms ${INSTALL_LIBDIR}

$(gmake-y):
	${GMAKE} ${MKFLAGS} -C $@
$(submodules-y):
	${MAKE} ${MKFLAGS} -C $@

$(gmake-install):
	${GMAKE} ${MKFLAGS} -C ${@:%-install=%} install
$(submodules-install):
	${MAKE} ${MKFLAGS} -C ${@:%-install=%} install

clean: ${submodules-clean}

musl-clean:
	${GMAKE} ${MKFLAGS} -C musl clean

$(submodules-clean):
	${MAKE} ${MKFLAGS} -C ${@:%-clean=%} clean

$(metal-release-main):
	tar czf $@ mk lib include Makefile

$(submodules-release):
	tar czf $@ ${@:metal-%-${METAL_SUFX}=%}/*

release: ${metal-release}

.PHONY: install ${submodules-install} \
	clean ${submodules-clean} \
	${submodules-y} release
