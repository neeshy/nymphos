# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

S_DIR="68253"

DESCRIPTION="A Japanese Mincho font based on GlyphWiki"
HOMEPAGE="https://osdn.net/projects/${PN}-font"
SRC_URI="${HOMEPAGE}/downloads/${S_DIR}/${P}.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1 ${PN}"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"

DOCS=( {README,THANKS}.txt )
