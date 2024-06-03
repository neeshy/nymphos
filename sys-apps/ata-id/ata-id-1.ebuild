# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Reads product/serial number from ATA drives"
HOMEPAGE="https://systemd.io/"
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"

DEPEND="sys-kernel/linux-headers"

src_compile() {
	"$(tc-getCC)" "${FILESDIR}/${PN}.c" -o "${PN}" || die "build failed"
}

src_install() {
	dobin "${PN}"
}
