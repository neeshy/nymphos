# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Runit init scripts"
HOMEPAGE="https://github.com/neeshy/runit-rc"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="CC0-1.0"
SLOT="0"

RDEPEND="
	sys-apps/seedrng
	sys-apps/util-linux[tty-helpers]
	sys-process/runit
	!sys-apps/sysvinit
	!sys-apps/void-runit"

src_compile() {
	:
}

src_install() {
	default

	# compatibility symlink
	dosym /run/runit/runsvdir/current /var/service
	# provide init
	dosym runit-init /sbin/init
}