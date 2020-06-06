DESTDIR ?= /
PREFIX ?= ${DESTDIR}usr/local
METAL_PREFIX ?= ${PREFIX}/metal
INSTALL ?= install
INSTALL_MKDIR ?= ${PREFIX}/mk
INSTALL_LIBDIR ?= ${METAL_PREFIX}/lib
INSTALL_INCDIR ?= ${METAL_PREFIX}/include
EXTRACT_SUFX ?= .tar.gz
METAL_V ?= 0.0.3-alpha
METAL_SUFX := $(METAL_V).src$(EXTRACT_SUFX)
metal-release-main := metal-$(METAL_SUFX)
submodules-y := linux musl rt
gmake-y := musl
cmake-y := rt
submodules-install := ${submodules-y:%=%-install}
gmake-install := ${gmake-y:%=%-install}
cmake-install := ${cmake-y:%=%-install}
submodules-clean := ${submodules-y:%=%-clean}
submodules-release := ${submodules-y:%=metal-%-${METAL_SUFX}} metal-rt-${METAL_SUFX}
metal-release := ${metal-release-main} ${submodules-release}
CMAKE ?= cmake
GMAKE := gmake
MKFLAGS += MKDIR=${PWD}/mk
CC := ${PREFIX}/bin/clang

all: ${submodules-y}

install: ${submodules-install}
	mkdir -p ${INSTALL_MKDIR}
	${INSTALL} -m 622 ./mk/hjs.mk ${INSTALL_MKDIR}
	${INSTALL} -m 622 ./mk/wasm.mk ${INSTALL_MKDIR}
	mkdir -p ${INSTALL_INCDIR}/metal
	${INSTALL} -m 622 ./include/metal.h ${INSTALL_INCDIR}
	${INSTALL} -m 622 ./include/metal/full.hjs ${INSTALL_INCDIR}/metal
	${INSTALL} -m 622 ./include/metal/env.js ${INSTALL_INCDIR}/metal
	mkdir -p ${INSTALL_LIBDIR}
	${INSTALL} -m 622 ./lib/wasm.syms ${INSTALL_LIBDIR}

rt/Makefile:
	cd rt ; ${CMAKE} -DCMAKE_CXX_COMPILER=${CC} -DCMAKE_C_COMPILER=${CC} -DCAN_TARGET_wasm32=ON \
		-DCMAKE_INSTALL_PREFIX=${PREFIX}/metal \
		-DCMAKE_AR=${PREFIX}/bin/llvm-ar \
		-DCMAKE_RANLIB=${PREFIX}/bin/llvm-ranlib \
		-DLLVM_CONFIG_PATH=${PREFIX}/bin/llvm-config \
		-DCMAKE_VERBOSE_MAKEFILE=ON \
		-DCOMPILER_RT_DEFAULT_TARGET_TRIPLE=wasm32-unknown-unknown-wasm \
		-DCOMPILER_RT_EXCLUDE_ATOMIC_BUILTIN=ON \
		-DCMAKE_C_COMPILER_WORKS=ON \
		--target lib/builtins/

rt: rt/Makefile

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
