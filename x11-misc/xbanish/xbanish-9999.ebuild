# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Banish the mouse cursor when typing, show it again when the mouse moves"
HOMEPAGE="https://github.com/jcs/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXi"
DEPEND="${RDEPEND}
	x11-libs/libXt"

src_install() {
	dobin xbanish
	doman xbanish.1
	dodoc README.md
}
