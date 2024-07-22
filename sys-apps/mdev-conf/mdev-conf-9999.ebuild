# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Configuration and helper scripts for busybox mdev and mdevd"
HOMEPAGE="https://gitlab.alpinelinux.org/alpine/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

src_install() {
	exeinto /lib/mdev
	doexe dvbdev persistent-storage ptpdev usbdev
	insinto /etc
	doins mdev.conf
}
