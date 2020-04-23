# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Simple dhcp client"
HOMEPAGE="git://git.2f30.org/${PN}/"
EGIT_REPO_URI="${HOMEPAGE%/}.git"
if [[ "${PV}" != 9999 ]]; then
	EGIT_COMMIT="${PV}"
	KEYWORDS="amd64 x86"
fi

LICENSE="MIT"
SLOT="0"

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
}
