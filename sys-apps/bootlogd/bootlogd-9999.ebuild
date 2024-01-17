# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="bootlogd extracted from sysvinit"
HOMEPAGE="https://github.com/slicer69/sysvinit"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/releases/download/${PV}/sysvinit-${PV}.tar.xz"
	KEYWORDS="amd64"
fi

LICENSE="GPL-2+"
SLOT="0"

S="${WORKDIR}/sysvinit-${PV}"

src_compile() {
	emake -C src VERSION="${PV}" "${PN}" readbootlog
	emake -C man VERSION="${PV}" MANPAGES="${PN}.8 readbootlog.1"
}

src_install() {
	dobin src/readbootlog
	into /
	dosbin "src/${PN}"
	doman "man/${PN}.8" man/readbootlog.1
	newdoc "doc/${PN}.README" README
}
