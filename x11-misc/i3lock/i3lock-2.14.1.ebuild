# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Simple screen locker"
HOMEPAGE="https://i3wm.org/${PN}/"
SRC_URI="${HOMEPAGE}${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="pam"

RDEPEND="
	dev-libs/libev
	pam? ( sys-libs/pam )
	x11-libs/cairo[X,xcb(+)]
	x11-libs/libxcb[xkb]
	x11-libs/libxkbcommon[X]
	x11-libs/xcb-util
	x11-libs/xcb-util-xrm"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	use pam || eapply "${FILESDIR}/${P}-no-pam.patch"

	default

	if use pam; then
		sed -i -e 's:login:system-auth:g' "pam/${PN}" || die
	fi
}

src_install() {
	meson_src_install
	use pam || fperms u+s "/usr/bin/${PN}"
}
