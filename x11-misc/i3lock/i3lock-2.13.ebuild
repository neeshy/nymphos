# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Simple screen locker"
HOMEPAGE="https://i3wm.org/${PN}/"
SRC_URI="${HOMEPAGE}${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="pam"

RDEPEND="
	>=x11-libs/libxkbcommon-0.5.0[X]
	dev-libs/libev
	pam? ( virtual/pam )
	x11-libs/cairo[X,xcb(+)]
	x11-libs/libxcb[xkb]
	x11-libs/xcb-util
	x11-libs/xcb-util-xrm
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
DOCS=( CHANGELOG README.md )

src_prepare() {
	use pam || eapply -p0 "${FILESDIR}/${P}-no-pam.patch"

	default

	if use pam; then
		sed -i -e 's:login:system-auth:g' "pam/${PN}" || die
	fi
}

src_configure() {
	tc-export CC
	default
}

src_install() {
	default
	use pam || fperms u+s "/usr/bin/${PN}"
	doman "${PN}.1"
}
