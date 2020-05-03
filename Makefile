.include "GNUmakefile"

MKDIRS=src

init: ${MKDIRS}
.if defined(name)
	mkdir src/${name}
	cd src/${name}
	npm init
	npm install --save metal
.else
	# Please define name parameter (i.e make init name=...)
.endif

${MKDIRS}:
	${MKDIR} -p ${MKDIRS}
