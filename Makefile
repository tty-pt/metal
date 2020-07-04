DESTDIR ?= /

METAL_PATH := ${PWD}

include mk/wasm.mk

EXTRACT_SUFX ?= .tar.gz
METAL_SUFX := v$(METAL_V).src$(EXTRACT_SUFX)
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
MKFLAGS := METAL_PATH=${METAL_PATH} METAL_MODE=${m}
CC := /usr/local/bin/clang
rt-clean-y := CMakeCache.txt CMakeFiles/ Makefile cmake_install.cmake
all: ${submodules-y}

install: ${submodules-install} htdocs-install
	mkdir -p ${INSTALL_MKDIR}
	${INSTALL} -m 644 ./mk/hjs.mk ${INSTALL_MKDIR}
	${INSTALL} -m 644 ./mk/wasm.mk ${INSTALL_MKDIR}
	mkdir -p ${INSTALL_INCDIR}/metal
	${INSTALL} -m 644 ./include/metal.h ${INSTALL_INCDIR}
	mkdir -p ${INSTALL_LIBDIR}
	${INSTALL} -m 644 ./lib/wasm.syms ${INSTALL_LIBDIR}

htdocs-install:
	${INSTALL} -m 644 ./linux/metal.js ${INSTALL_BINDIR}

rt/Makefile:
	cd rt ; ${CMAKE} -DCMAKE_CXX_COMPILER=${CC} -DCMAKE_C_COMPILER=${CC} -DCAN_TARGET_wasm32=ON \
		-DCMAKE_INSTALL_PREFIX=${metal-path} \
		-DCMAKE_AR=/usr/local/bin/llvm-ar \
		-DCMAKE_RANLIB=/usr/local/bin/llvm-ranlib \
		-DLLVM_CONFIG_PATH=/usr/local/bin/llvm-config \
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

rt-install: rt
$(gmake-install):
	${GMAKE} ${MKFLAGS} -C ${@:%-install=%} install
$(submodules-install):
	${MAKE} ${MKFLAGS} -C ${@:%-install=%} install

clean: ${submodules-clean}

rt-clean:
	rm -rf ${rt-clean-y:%=rt/%} 2>&1 >/dev/null

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
