# Copyright 2023 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="The simplest script for suspending to memory"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="acct-group/power"

S="${WORKDIR}"

src_compile() {
	"$(tc-getCC)" "${FILESDIR}/${PN}.c" -o "${PN}"
}

src_install() {
	dobin "${PN}"
	fowners root:power "/usr/bin/${PN}"
	fperms 4710 "/usr/bin/${PN}"
}
