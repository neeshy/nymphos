# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit git-r3

DESCRIPTION="Jump back to a specific directory, without doing \`cd ../../..\`"
HOMEPAGE="https://github.com/Tarrasch/${PN}"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="all-rights-reserved"
SLOT="0"

RDEPEND="app-shells/zsh"

src_compile() {
	:
}

src_install() {
	insinto "/usr/share/zsh/site-contrib/${PN}"
	doins bd.zsh
}
