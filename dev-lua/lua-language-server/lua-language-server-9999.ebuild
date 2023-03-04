# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1,3,4},jit} )

inherit lua

DESCRIPTION="Lua Language Server written in Lua"
HOMEPAGE="https://github.com/LuaLS/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/releases/download/${PV}/${P}-submodules.zip"
	KEYWORDS="amd64"
fi

LICENSE="MIT"
SLOT="0"

BDEPEND="app-arch/unzip
	dev-util/ninja"

PATCHES=( "${FILESDIR}/${PN}-copy_binary.patch" )

S="${WORKDIR}"

src_compile() {
	ninja -C 3rd/luamake -f compile/ninja/linux.ninja
	3rd/luamake/luamake rebuild
}

src_install() {
	newbin "${FILESDIR}/${PN}.sh" "${PN}"
	into "/usr/libexec/${PN}"
	dobin "bin/${PN}" bin/main.lua
	insinto "/usr/libexec/${PN}"
	doins -r main.lua debugger.lua locale script meta
}
