# Copyright 2023 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="su from ubase"
HOMEPAGE="https://core.suckless.org/ubase/"
EGIT_REPO_URI="git://git.suckless.org/ubase"

LICENSE="MIT"
SLOT="0"

PATCHES=( "${FILESDIR}" )

src_compile() {
	emake "${PN}"
}

src_install() {
	dobin "${PN}"
	fperms u+s "/usr/bin/${PN}"
	doman "${PN}.1"
}
