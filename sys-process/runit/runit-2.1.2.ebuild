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

PATCHES=( "${FILESDIR}" )

S="${WORKDIR}/admin/${P}"

src_prepare() {
	default

	# we either build everything or nothing static
	sed -i -e 's/-static/ /' src/Makefile
}

src_configure() {
	use static && append-ldflags -static

	printf '%s %s\n' "$(tc-getCC)" "${CFLAGS}" >src/conf-cc
	printf '%s %s\n' "$(tc-getCC)" "${LDFLAGS}" >src/conf-ld
}

src_compile() {
	cd src || die

	default
}

src_install() {
	into /
	dobin src/{chpst,runsv,runsvchdir,runsvdir,sv,svlogd}
	dosbin src/{runit-init,runit,utmpset}

	doman man/*.[18]
	dodoc package/{CHANGES,README,THANKS,TODO}
	docinto html
	dodoc doc/*.html
}
