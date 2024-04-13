# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Daemonless replacement for libudev"
HOMEPAGE="https://github.com/illiliti/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
fi

LICENSE="ISC"
SLOT="0"

RDEPEND="
	!sys-apps/systemd
	!sys-apps/systemd-utils[udev]
	!virtual/udev"
DEPEND="sys-kernel/linux-headers"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
}
