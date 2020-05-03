.PHONY: all run clean init dist

RTLIB=lclang_rt.builtins-wasm32
METAL_EXE=metal.wasm

all: lib/${RTLIB}.a lib/libc.a bin/${METAL_EXE}

run: all
	${MAKE} -C src/example run

lib/$(RTLIB).a:
	${MAKE} -C tmp install

lib/libc.a:
	gmake -C src/musl install

bin/$(METAL_EXE):
	${MAKE} -C src/metal install

clean:
	${MAKE} -C tmp clean
	gmake -C src/musl clean
	${MAKE} -C src/example clean
	${MAKE} -C src/metal clean
	rm -rf bin/* lib/*.a lib/*.o lib/*.specs include *.tar.gz

dist: all
	tar zcf metal-toolchain-0-0-0.tar.gz bin/* lib/* include/* Makefile
