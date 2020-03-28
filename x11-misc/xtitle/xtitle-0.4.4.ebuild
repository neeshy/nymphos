# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Outputs X window titles"
HOMEPAGE="https://github.com/baskerville/${PN}"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	x11-libs/libxcb
	x11-libs/xcb-util
	x11-libs/xcb-util-wm
"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	einstalldocs
}
