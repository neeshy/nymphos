# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

MY_PV="2.1.2-23-e5438e85"
MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Downloads albums in bulk"
HOMEPAGE="https://github.com/ripmeapp2/${MY_PN}"
SRC_URI="${HOMEPAGE}/releases/download/${PV}/${MY_P}.jar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="virtual/jre"

S="${WORKDIR}"

src_unpack() {
	:
}

src_install() {
	newbin "${FILESDIR}/${MY_PN}.sh" "${MY_PN}"

	insinto "/opt/${MY_PN}"
	newins "${DISTDIR}/${MY_P}.jar" "${MY_PN}.jar"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
