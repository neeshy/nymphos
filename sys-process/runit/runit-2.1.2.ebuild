# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="http://smarden.org/${PN}/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE="static"

PATCHES=( "${FILESDIR}" )

S="${WORKDIR}/admin/${P}/src"

src_prepare() {
	cd .. || die

	default

	# we either build everything or nothing static
	sed -i -e 's/-static/ /' src/Makefile
}

src_configure() {
	use static && append-ldflags -static

	printf '%s %s' "$(tc-getCC)" "${CFLAGS}" >conf-cc
	printf '%s %s' "$(tc-getCC)" "${LDFLAGS}" >conf-ld
}

src_install() {
	into /
	dobin chpst runsv runsvchdir runsvdir sv svlogd
	dosbin runit-init runit utmpset

	cd .. || die
	doman man/*.8
	dodoc package/{CHANGES,README,THANKS,TODO}
	docinto html
	dodoc doc/*.html
}
