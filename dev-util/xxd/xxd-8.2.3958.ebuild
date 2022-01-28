# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Hexdump utility from vim"
HOMEPAGE="https://www.vim.org/"
SRC_URI="
	https://raw.githubusercontent.com/vim/vim/v${PV}/src/xxd/xxd.c -> ${P}.c
	https://raw.githubusercontent.com/vim/vim/v${PV}/runtime/doc/xxd.1 -> ${P}.1
	https://raw.githubusercontent.com/vim/vim/v${PV}/src/xxd/Makefile -> ${P}.mk
"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="!app-editors/vim-core"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${P}.c" xxd.c || die "cp failed"
	cp "${DISTDIR}/${P}.1" xxd.1 || die "cp failed"
	cp "${DISTDIR}/${P}.mk" Makefile || die "cp failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin xxd
	doman xxd.1
}
