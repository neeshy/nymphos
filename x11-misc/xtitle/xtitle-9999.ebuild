# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Outputs X window titles"
HOMEPAGE="https://github.com/baskerville/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="Unlicense"
SLOT="0"

RDEPEND="
	x11-libs/libxcb
	x11-libs/xcb-util
	x11-libs/xcb-util-wm"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc README.md
}
