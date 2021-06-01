# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit python-any-r1 scons-utils git-r3

DESCRIPTION="An open source implementation of the RealLive virtual machine for Linux and OSX"
HOMEPAGE="http://www.rlvm.net/"
EGIT_REPO_URI="https://github.com/eglaysher/rlvm.git"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	media-libs/libsdl[opengl]
	>=dev-libs/boost-1.42:0=
	media-libs/glew:0=
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-ttf
	media-libs/sdl-mixer[vorbis]
	media-libs/libmad
	>=dev-games/guichan-0.8[opengl,sdl]
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-freetype.patch"
	"${FILESDIR}/${PN}-custom-flags.patch"
)

src_compile() {
	escons --release CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die "build failed"
}

src_install() {
	dobin "build/${PN}" || die "dobin failed"
	doman "debian/${PN}.6"
	dodoc README.md {AUTHORS,NEWS,STATUS}.TXT
}
