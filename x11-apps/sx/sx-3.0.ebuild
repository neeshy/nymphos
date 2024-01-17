# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Start an xorg server"
HOMEPAGE="https://github.com/Earnestly/${PN}"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	x11-base/xorg-server
	x11-apps/xauth"

src_compile() {
	:
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	dodoc README
}
