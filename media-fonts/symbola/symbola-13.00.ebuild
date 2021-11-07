# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_PN="${PN^}"

DESCRIPTION="Unicode font for Latin, IPA Extensions, Greek, Cyrillic and many Symbol Blocks"
HOMEPAGE="https://dn-works.com/ufas/"
SRC_URI="
	https://dn-works.com/wp-content/uploads/2020/UFAS-Fonts/${MY_PN}.zip -> ${P}.zip
	doc? ( https://dn-works.com/wp-content/uploads/2020/UFAS-Docs/${MY_PN}.pdf -> ${P}.pdf )
"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RESTRICT="bindist"

DEPEND="app-arch/unzip"

S="${WORKDIR}"

FONT_SUFFIX="otf"

src_prepare() {
	default
	use doc && DOCS="${DISTDIR}/${P}.pdf"
}
