# Top-level Makefile for libcidr
# This basically calls out to various sub-level Makefiles for the build,
# and handles the bits&pieces of installing manually.

# Define some destination directories
DESTDIR?=/usr/local
LIBDIR?=${DESTDIR}/lib
BINDIR?=${DESTDIR}/bin
INCDIR?=${DESTDIR}/include
MANDIR?=${DESTDIR}/man
DOCDIR?=${DESTDIR}/share/libcidr/docs
EXDIR?=${DESTDIR}/share/libcidr/examples

# A few programs
ECHO?=echo
MKDIR?=mkdir -pm 755
INSTALL?=install -c
LN?=ln
GZIP?=gzip
RM?=rm -f
SED?=sed

# Standard defines
.include "Makefile.inc"


# The building doesn't touch the docs, intentionally.  We presume they're
# pre-built if we care about them, because building them requires a lot
# of extra programs that many people won't have.
all build clean:
	(cd src && ${MAKE} ${@})
	(cd src/examples/cidrcalc && ${MAKE} ${@})


# Provide a quick&dirty 'uninstall' target
uninstall:
	@${ECHO} "-> Trying to delete everything libcidr-related..."
	${RM} ${LIBDIR}/${SHLIB_NAME} ${LIBDIR}/${SHLIB_LINK}
	${RM} ${BINDIR}/cidrcalc
	${RM} ${INCDIR}/libcidr.h
	${RM} ${MANDIR}/man3/libcidr.3.gz
	${RM} -r ${DOCDIR}
	${RM} -r ${EXDIR}
	@${ECHO} "-> Uninstallation complete"


# Now the bits of installing
install:
	@${ECHO} "-> Installing ${SHLIB_NAME}..."
	-@${MKDIR} ${LIBDIR}
	${INSTALL} -m 444 src/${SHLIB_NAME} ${LIBDIR}/
	(cd ${LIBDIR} && ${LN} -fs ${SHLIB_NAME} ${SHLIB_LINK})
	@${ECHO} "-> Installing cidrcalc..."
	-@${MKDIR} ${BINDIR}
	${INSTALL} -m 555 src/examples/cidrcalc/cidrcalc ${BINDIR}/
	@${ECHO} "-> Installing header file..."
	-@${MKDIR} ${INCDIR}
	${INSTALL} -m 444 include/libcidr.h ${INCDIR}/
	@${ECHO} "-> Installing manpage..."
	@${GZIP} -c docs/libcidr.3 > docs/libcidr.3.gz
	-@${MKDIR} ${MANDIR}/man3
	${INSTALL} -m 444 docs/libcidr.3.gz ${MANDIR}/man3
	@${RM} docs/libcidr.3.gz
.ifndef NO_DOCS
	@${ECHO} "-> Installing docs..."
	-@${MKDIR} ${DOCDIR}
	${INSTALL} -m 444 docs/reference/libcidr* \
			docs/reference/codelibrary-html.css ${DOCDIR}/
.endif
.ifndef NO_EXAMPLES
	@${ECHO} "-> Installing examples..."
	-@${MKDIR} ${EXDIR}
	@${SED} -e "s,\.\./include,${INCDIR}," \
			-e "s,\.\./Makefile\.inc,/dev/null," \
			< src/Makefile.inc \
			> ${EXDIR}/Makefile.inc
	${INSTALL} -m 444 src/examples/README ${EXDIR}/
	@${MAKE} EX=cidrcalc install-example
	@${MAKE} EX=acl EXFILE=acl.example install-example
.endif
	@${ECHO} ""
	@${ECHO} "libcidr install complete"


install-example:
	@${ECHO} "-> Installing examples/${EX}..."
	-@${MKDIR} ${EXDIR}/${EX}
	${INSTALL} -m 444 src/examples/${EX}/${EX}.c ${EXDIR}/${EX}/
.ifdef EXFILE
	${INSTALL} -m 444 src/examples/${EX}/${EXFILE} ${EXDIR}/${EX}/
.endif
	@${SED} -e "s,\.\./\.\./\.\./include,${INCDIR}," \
			-e "s,-L\.\./\.\.,-L${LIBDIR}," \
			-e "s,\.\./\.\./libcidr.so,${LIBDIR}/libcidr.so," \
			-e "s,cd\ \.\./\.\.\ &&\ make,cd," \
			-e "s,\.\./\.\./Makefile\.inc,\.\./Makefile.inc," \
			< src/examples/${EX}/Makefile \
			> ${EXDIR}/${EX}/Makefile
