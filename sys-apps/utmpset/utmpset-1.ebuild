# Copyright 2026 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Logout a line from the utmp or wtmp file"
HOMEPAGE="https://smarden.org/runit/"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!sys-process/runit"

src_compile() {
	"$(tc-getCC)" "${FILESDIR}/${PN}.c" -o "${PN}" || die "build failed"
}

src_install() {
	dobin "${PN}"
}
