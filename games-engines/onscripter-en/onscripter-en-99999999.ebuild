# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ONScripter-EN"
MY_PV="${PV:0:4}-${PV:4:2}-${PV:6}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="An enhanced open-source implementation of the NScripter visual novel game engine"
HOMEPAGE="https://galladite.net/~galladite/ons-en/"
if [[ "${PV}" = 99999999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Galladite27/${MY_PN}.git"
else
	SRC_URI="https://github.com/Galladite27/${MY_PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="amd64"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	app-arch/bzip2
	media-libs/freetype
	media-libs/libsdl
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	media-libs/smpeg"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	default
	sed -i 's/-lbz2 /-lbz2 -lX11 /' Makefile || die "sed failed"
}

src_install() {
	dobin "${PN}"
	dodoc README.md CHANGES BUGS
}
