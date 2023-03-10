# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Simple utility for seeding the Linux kernel RNG with seed files"
HOMEPAGE="https://git.zx2c4.com/${PN}/about/"
EGIT_REPO_URI="https://git.zx2c4.com/${PN}"

LICENSE="GPL-2 Apache-2.0 MIT BSD-1 CC0-1.0"
SLOT="0"

src_install() {
	dobin "${PN}"
	dodoc README.md
}
