DESTDIR ?= /
PREFIX ?= ${DESTDIR}/usr/local
METAL_PREFIX ?= ${PREFIX}/metal
INSTALL ?= install
INSTALL_MKDIR ?= ${PREFIX}/mk
INSTALL_INCDIR ?= ${METAL_PREFIX}/include

all:
	# OK

install:
	mkdir -p ${INSTALL_MKDIR}
	${INSTALL} ./mk/metal.mk ${INSTALL_MKDIR}
	${INSTALL} ./mk/hjs.mk ${INSTALL_MKDIR}
	mkdir -p ${INSTALL_INCDIR}/metal
	${INSTALL} ./include/metal.h ${INSTALL_INCDIR}
	${INSTALL} ./include/metal/full.hjs ${INSTALL_INCDIR}/metal
	${INSTALL} ./include/metal/env.js ${INSTALL_INCDIR}/metal

.PHONY: install
