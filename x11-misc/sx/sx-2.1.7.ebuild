# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Start an xorg server"
HOMEPAGE="https://github.com/Earnestly/${PN}"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	x11-base/xorg-server
	x11-apps/xauth
"

src_compile() {
	:
}

src_install() {
	dobin sx
	doman sx.1
	dodoc README
}
