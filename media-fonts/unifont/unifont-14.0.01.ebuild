# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="GNU Unifont - a Pan-Unicode X11 bitmap iso10646 font"
HOMEPAGE="https://unifoundry.com/"
SRC_URI="
	mirror://gnu/${PN}/${P}/${P}.pcf.gz
	bold? ( mirror://gnu/${PN}/${P}/${P}.bdf.gz )
	truetype? ( mirror://gnu/${PN}/${P}/${P}.ttf )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bold truetype"

DEPEND="
	bold? (
		app-text/mkbold-mkitalic
		x11-apps/bdftopcf
	)
"

S="${WORKDIR}"

src_unpack() {
	use truetype && cp "${DISTDIR}/${P}.ttf" "${S}"
	default
}

src_compile() {
	use bold && mkbold <"${P}.bdf" | bdftopcf >"${PN}-bold.pcf"
}

src_install() {
	insinto "${FONTDIR}"
	newins "${P}.pcf" "${PN}.pcf"
	use bold && doins "${PN}-bold.pcf"
	use truetype && newins "${P}.ttf" "${PN}.ttf"

	font_xfont_config
	font_fontconfig
}
