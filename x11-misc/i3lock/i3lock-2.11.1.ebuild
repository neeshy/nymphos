# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Simple screen locker"
HOMEPAGE="https://i3wm.org/${PN}/"
SRC_URI="${HOMEPAGE}${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
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
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
DOCS=( CHANGELOG README.md )
PATCHES=( "${FILESDIR}/${PN}-2.11-version.patch" )

src_prepare() {
	use pam || eapply -p0 "${FILESDIR}/${P}-no-pam.patch"

	default

	printf '%s\n' "${PV}" > I3LOCK_VERSION

	if use pam; then
		sed -i -e 's:login:system-auth:' "pam/${PN}" || die
	fi

	eautoreconf

	tc-export CC
}

src_install() {
	default
	if ! use pam; then
		fperms u+s "/usr/bin/${PN}"
	fi
	doman "${PN}.1"
}
