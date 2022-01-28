# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="Daemonless replacement for libudev"
HOMEPAGE="https://github.com/illiliti/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="ISC"
SLOT="0"

DEPEND="sys-kernel/linux-headers"
RDEPEND="
	!sys-apps/systemd
	!sys-fs/eudev
	!sys-fs/udev
"

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr LIBDIR="/usr/$(get_libdir)" install
}
