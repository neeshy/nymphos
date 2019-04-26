# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="Run commands as super user or another user, alternative to sudo from OpenBSD"

MY_PVR="${PVR//-r/p}"
MY_P="${PN}-${MY_PVR}"
HOMEPAGE="https://github.com/slicer69/doas"
SRC_URI="https://github.com/slicer69/doas/archive/${MY_PVR}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="pam"

RDEPEND="pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	virtual/yacc
	dev-libs/libbsd
	sys-libs/glibc"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	use pam || epatch "${FILESDIR}/shadow.patch"
	default
}

src_configure() {
	tc-export CC AR
}

src_compile() {
	# to set DOAS_CONF to /etc/doas.conf
	emake PREFIX=
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr
}
