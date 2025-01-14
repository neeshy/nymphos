# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

MY_PN="${PN^}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Unicode font for Latin, IPA Extensions, Greek, Cyrillic and many Symbol Blocks"
HOMEPAGE="https://dn-works.com/ufas/"
SRC_URI="https://web.archive.org/web/20240107144224/https://dn-works.com/wp-content/uploads/2021/UFAS121921/Symbola.pdf -> ${MY_P}.pdf"
S="${WORKDIR}"

LICENSE="UFAS"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="bindist mirror"

BDEPEND="media-gfx/fontforge"

FONT_SUFFIX="otf"

DOCS=( "${MY_PN}".{pdf,odt} )

src_unpack() {
	cp "${DISTDIR}/${MY_P}.pdf" "${MY_PN}.pdf" || die "cp failed"
	pdfdetach -saveall "${MY_PN}.pdf" || die "pdfdetach failed"
}
