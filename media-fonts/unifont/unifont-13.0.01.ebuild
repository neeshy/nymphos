# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="GNU Unifont - a Pan-Unicode X11 bitmap iso10646 font"
HOMEPAGE="http://unifoundry.com/"
SRC_URI="
	mirror://gnu/${PN}/${P}/${P}.pcf.gz
	bold? ( mirror://gnu/${PN}/${P}/${P}.bdf.gz )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bold"

DEPEND="
	bold? (
		app-text/mkbold-mkitalic
		x11-apps/bdftopcf
	)
"

S="${WORKDIR}"

src_compile() {
	use bold && mkbold < "${P}.bdf" | bdftopcf > "${PN}-bold.pcf"
}

src_install() {
	insinto "${FONTDIR}"
	newins "${P}.pcf" "${PN}.pcf"
	use bold && doins "${PN}-bold.pcf"

	font_xfont_config
	font_fontconfig
}
