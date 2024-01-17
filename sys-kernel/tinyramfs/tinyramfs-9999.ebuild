# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Tiny initramfs written in POSIX shell"
HOMEPAGE="https://github.com/neeshy/${PN}"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="sys-apps/busybox"
DEPEND="app-text/scdoc"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
