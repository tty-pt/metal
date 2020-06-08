GCC_JS := gcc -E -P -nostdinc -undef -x c
.SUFFIXES: .js .hjs

.hjs.js:
	${GCC_JS} -o $@ $<
