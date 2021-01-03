# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A ZSH plugin to search history, a clean-room implementation of the Fish shell feature"
HOMEPAGE="https://github.com/zsh-users/${PN}"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="app-shells/zsh"

src_install() {
	insinto /usr/share/zsh/site-contrib/zsh-history-substring-search
	doins zsh-history-substring-search.zsh
	dodoc README.md
}
