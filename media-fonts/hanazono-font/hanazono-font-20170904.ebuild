# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

S_DIR="68253"

DESCRIPTION="Hanazono font is a Japanese mincho font based on GlyphWiki"
HOMEPAGE="https://fonts.jp/hanazono/"
SRC_URI="https://osdn.net/projects/${PN}/downloads/${S_DIR}/hanazono-${PV}.zip"

LICENSE="OFL-1.1 hanazono-font"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}"

FONT_SUFFIX="ttf"
FONT_S="${S}"

DOCS=( {README,THANKS}.txt )
