# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Simple screen locker"
HOMEPAGE="https://i3wm.org/${PN}/"
SRC_URI="
	${HOMEPAGE}${P}.tar.bz2
	!pam? ( https://slackbuilds.org/slackbuilds/14.2/desktop/i3lock/i3lock-2.10-no-pam.patch )
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="pam"

RDEPEND="
	>=x11-libs/libxkbcommon-0.5.0[X]
	dev-libs/libev
	pam? ( virtual/pam )
	x11-libs/cairo[xcb]
	x11-libs/libxcb[xkb]
	x11-libs/xcb-util
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
DOCS=( CHANGELOG README.md )

src_prepare() {
	use pam || eapply -p0 "${DISTDIR}/${P}-no-pam.patch"

	default

	if use pam; then
		sed -i -e 's:login:system-auth:' "${PN}.pam" || die
	fi

	tc-export CC
}

src_install() {
	default
	fperms u+s "/usr/bin/${PN}"
	doman "${PN}.1"
}
