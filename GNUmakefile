.PHONY: all run clean init dist

include metal.mk

RTLIB=lclang_rt.builtins-wasm32

all: lib/${RTLIB}.a lib/libc.a metal.js

metal.js: bin/metal.wasm

lib/$(RTLIB).a:
	${MAKE} -C tmp install

lib/libc.a:
	gmake -C musl install

bin/metal.wasm:
	${MAKE} -C metal-linux

clean:
	${MAKE} -C tmp clean
	gmake -C musl clean
	${MAKE} -C metal-linux clean
	rm -rf bin/* lib/*.a lib/*.o lib/*.specs include *.tar.gz

dist: all
	tar zcf metal-toolchain-0-0-0.tar.gz bin/* lib/* include/* Makefile
