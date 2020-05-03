.PHONY: all clean

DESTDIR=..
include ../wasm.mk

sha=c45208356ec6e6381c667047a16068d2597ac1fb
pkg=${sha}.tar.gz

os != uname | tr '[:upper:]' '[:lower:]'
libname=libclang_rt.builtins-wasm32.a

# install_target=${clang_base}/lib/${os}/${libname}
# install_target=../lib/${os}/${libname}
install_target=${DESTDIR}/lib/${libname}
target=compiler-rt-$(sha)/lib/${os}/${libname}

all: ${target}
install: ${install_target}

$(pkg):
	# ${CC} ${LDFLAGS}
	curl -LO https://github.com/llvm-mirror/compiler-rt/archive/${pkg}

compiler-rt-$(sha)/: ${pkg}
	tar xzf ${pkg}
	sed -i.bak s/wasm32-unknown-unknown/wasm32-unknown-unknown-wasm/ \
		compiler-rt-${sha}/cmake/base-config-ix.cmake

$(target): compiler-rt-${sha}/
	cd compiler-rt-${sha}; CC=${CC} \
		cmake -DCAN_TARGET_wasm32=ON \
		-DCMAKE_INSTALL_PREFIX=${DESTDIR} \
		-DCMAKE_AR=${LLVM_ROOT}/bin/llvm-ar \
		-DCMAKE_RANLIB=${LLVM_ROOT}/bin/llvm-ranlib \
		-DCMAKE_VERBOSE_MAKEFILE=ON \
		-DLLVM_CONFIG_PATH=${LLVM_ROOT}/bin/llvm-config \
		-DCOMPILER_RT_DEFAULT_TARGET_TRIPLE=wasm32-unknown-unknown-wasm \
		-DCOMPILER_RT_EXCLUDE_ATOMIC_BUILTIN=ON \
		-DCMAKE_C_COMPILER_WORKS=ON \
		--target lib/builtins/
	patch compiler-rt-${sha}/lib/builtins/CMakeLists.txt < \
		patches/patch_lib_builtins_CMakeLists_txt
	${MAKE} -C compiler-rt-${sha}

$(install_target): ${target}
	mkdir -p `dirname ${install_target}`
	${INSTALL} ${target} ${install_target}

clean:
	rm -rf compiler-rt* ${pkg}
