# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tiny but flexible init system and process supervisor"
HOMEPAGE="https://git.vuxu.org/${PN}"
SRC_URI="${HOMEPAGE}/snapshot/${P}.tar.gz"

LICENSE="0BSD"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	into /
	dosbin nitro
	dobin nitroctl

	doman nitro.8 nitroctl.1 halt.8
	dodoc README.md
}
