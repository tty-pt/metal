js-flags-y := -E -P -nostdinc -undef -x c
.SUFFIXES: .js .hjs

.hjs.js:
	gcc ${js-flags-y} -o $@ $<
