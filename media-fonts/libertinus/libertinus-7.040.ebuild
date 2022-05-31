# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

MY_PN="${PN^}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A fork of the Linux Libertine and Linux Biolinum fonts"
HOMEPAGE="https://github.com/alerque/${PN}"
SRC_URI="https://github.com/alerque/${PN}/releases/download/v${PV}/${MY_P}.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}/${MY_P}"

FONT_SUFFIX="otf"
FONT_S="${S}/static/OTF"
