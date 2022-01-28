# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Modular initramfs image creation utility"
HOMEPAGE="https://codemadness.org/${PN}.html"
EGIT_REPO_URI="git://git.codemadness.org/${PN}"
if [[ "${PV}" != 9999 ]]; then
	EGIT_COMMIT="${PV}"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="dev-libs/libgit2:0="
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr \
		MANPREFIX=/usr/share/man DOCPREFIX="/usr/share/doc/${P}" install
}
