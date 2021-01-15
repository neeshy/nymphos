# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="http://smarden.org/runit/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static"

S="${WORKDIR}/admin/${P}/src"

src_prepare() {
	eapply -p2 "${FILESDIR}/clearmem.patch"
	eapply -p1 "${FILESDIR}/headers.patch"
	eapply -p2 "${FILESDIR}/servicedir.patch"
	eapply -p2 "${FILESDIR}/svlogd.patch"
	eapply -p2 "${FILESDIR}/utmpset-time_t.patch"

	default

	# we either build everything or nothing static
	sed -i -e 's:-static: :' Makefile
}

src_configure() {
	use static && append-ldflags -static

	echo "$(tc-getCC) ${CFLAGS}"  >conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" >conf-ld
}

src_install() {
	into /
	dobin chpst runsv runsvchdir runsvdir sv svlogd
	dosbin runit-init runit utmpset

	doman ../man/*.[18]
	dodoc ../package/{CHANGES,README,THANKS,TODO}
	docinto html
	dodoc ../doc/*.html
}
