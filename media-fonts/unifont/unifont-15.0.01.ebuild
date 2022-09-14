# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="GNU Unifont - a Pan-Unicode X11 bitmap iso10646 font"
HOMEPAGE="https://unifoundry.com/"
SRC_URI="mirror://gnu/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bold"

DEPEND="
	bold? (
		app-text/mkbold-mkitalic
		x11-apps/bdftopcf
	)"

src_compile() {
	gzip -d <"font/precompiled/${P}.pcf.gz" >"${P}.pcf"
	use bold && gzip -d <"font/precompiled/${P}.bdf.gz" | mkbold | bdftopcf >"${PN}-bold.pcf"
}

src_install() {
	insinto "${FONTDIR}"
	newins "${P}.pcf" "${PN}.pcf"
	use bold && doins "${PN}-bold.pcf"

	font_xfont_config
	font_fontconfig
}
