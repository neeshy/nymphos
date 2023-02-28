# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

S_DIR="68253"

DESCRIPTION="Hanazono font is a Japanese mincho font based on GlyphWiki"
HOMEPAGE="https://osdn.net/projects/${PN}"
SRC_URI="${HOMEPAGE}/downloads/${S_DIR}/hanazono-${PV}.zip"

LICENSE="OFL-1.1 ${PN}"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

FONT_SUFFIX="ttf"

DOCS=( {README,THANKS}.txt )
