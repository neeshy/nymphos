# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion

DESCRIPTION="Tiny but flexible init system and process supervisor"
HOMEPAGE="https://git.vuxu.org/nitro"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/snapshot/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="0BSD"
SLOT="0"

src_install() {
	into /
	dosbin nitro
	dobin nitroctl

	doman nitro.8 nitroctl.1 halt.8
	dodoc README.md

	dozshcomp contrib/_nitroctl
}
