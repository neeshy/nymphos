# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Hexdump utility from vim"
HOMEPAGE="https://www.vim.org/"
SRC_URI="
	https://raw.githubusercontent.com/vim/vim/v${PV}/src/xxd/xxd.c -> ${P}.c
	https://raw.githubusercontent.com/vim/vim/v${PV}/src/xxd/Makefile -> ${P}.mk
	https://raw.githubusercontent.com/vim/vim/v${PV}/runtime/doc/xxd.1 -> ${P}.1"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="!app-editors/vim-core"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${P}.c" "${PN}.c" || die "cp failed"
	cp "${DISTDIR}/${P}.mk" Makefile || die "cp failed"
	cp "${DISTDIR}/${P}.1" "${PN}.1" || die "cp failed"
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
}
