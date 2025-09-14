# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="GTK+2.0 integration plugins for Qt6"
HOMEPAGE="https://www.opencode.net/trialuser/${PN}"
SRC_URI="${HOMEPAGE}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-qt/qtbase:6=[gui,widgets]
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/pango"
DEPEND="${RDEPEND}"

src_configure() {
	eqmake6
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
