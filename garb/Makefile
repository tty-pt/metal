.PHONY: all clean run tags deps

include ../../wasm.mk

NODE_FLAGS = --expose-wasm
# NODE_FLAGS += --experimental-worker

EXE=test
CFLAGS += ${PROG_LD_CFLAGS}

#CC := ../../bin/musl-gcc
#CFLAGS := -D__INT64_TYPE__=long
#CFLAGS := -I../../include
LDFLAGS := --allow-undefined-file=../../lib/wasm.syms -L../../lib
#LDLIBS := -lc
LDLIBS += ${PROG_LDLIBS}

CFLAGS += -v
all: ${EXE}

$(EXE): ${EXE}.o
	${LD} ${LDFLAGS} -o $@ ../../lib/crt1.o ${EXE}.o ${LDLIBS}

run: all node_modules/
	node ${NODE_FLAGS} test.js

clean:
	-rm ${EXE} ${EXE}.o

deps:
	mkdep ${CFLAGS} test.c

node_modules/:
	npm install
