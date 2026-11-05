# Copyright 2026 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Minimal X-application which hides the cursor on key-press and unhides it on mouse-movement efficiently"
HOMEPAGE="https://github.com/astier/xhidecursor"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXi"
DEPEND="${RDEPEND}"

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	dodoc README.md
}
