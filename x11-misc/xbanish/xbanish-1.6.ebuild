# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Banish the mouse cursor when typing, show it again when the mouse moves"
HOMEPAGE="https://github.com/jcs/xbanish"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXi
"
DEPEND="${RDEPEND}
	x11-libs/libXt
"

src_install() {
	dobin xbanish
	doman xbanish.1
	dodoc README.md
}
