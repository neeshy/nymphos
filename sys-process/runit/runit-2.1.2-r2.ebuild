# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="http://smarden.org/runit/"
SRC_URI="http://smarden.org/runit/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="static"

PATCHES=(
	"${FILESDIR}/clearmem.patch"
	"${FILESDIR}/headers.h"
	"${FILESDIR}/servicedir.patch"
	"${FILESDIR}/svlogd.patch"
	"${FILESDIR}/utmpset-time_t.patch"
)

S="${WORKDIR}/admin/${P}"

src_prepare() {
	default

	# we either build everything or nothing static
	sed -i -e 's:-static: :' src/Makefile

	# see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=726008
	[[ ${COMPILER} == "diet" ]] &&
		use ppc &&
		filter-flags "-mpowerpc-gpopt"
}

src_configure() {
	use static && append-ldflags -static

	echo "$(tc-getCC) ${CFLAGS}"  > src/conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > src/conf-ld
}

src_install() {
	into /
	dobin chpst runsv runsvchdir runsvdir sv svlogd
	dosbin runit-init runit utmpset

	DOCS=( package/{CHANGES,README,THANKS,TODO} )
	HTML_DOCS=( doc/*.html )
	einstalldocs
	doman man/*.[18]
}
