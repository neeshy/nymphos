# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A Free & Open Source implementation of the NScripter novel game engine"
HOMEPAGE="https://kaisernet.org/onscripter/"
SRC_URI="${HOMEPAGE}/releases/${P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	app-arch/bzip2
	media-libs/freetype
	media-libs/libsdl
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	media-libs/smpeg"
DEPEND="${RDEPEND}"

src_configure() {
	econf --no-werror
	sed -i 's/\.dll//g' Makefile || die
}

src_install() {
	dobin "${PN}"
	einstalldocs
}
