# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Runit init scripts"
HOMEPAGE="https://github.com/neeshy/${PN}"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="CC0-1.0"
SLOT="0"

RDEPEND="
	sys-apps/seedrng
	sys-apps/util-linux[tty-helpers]
	sys-process/runit
	!sys-apps/sysvinit"

src_compile() {
	:
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dosym runit-init /sbin/init
}
