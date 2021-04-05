# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit wrapper xdg-utils

MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Downloads albums in bulk"
HOMEPAGE="https://github.com/RipMeApp/${MY_PN}"
SRC_URI="${HOMEPAGE}/releases/download/${PV}/ripme.jar -> ${MY_P}.jar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="virtual/jre"

S="${WORKDIR}"

src_install() {
	insinto "/opt/${MY_PN}"
	newins "${DISTDIR}/${MY_P}.jar" "${MY_PN}.jar"

	insinto /usr/share/pixmaps
	newins icon.png "${MY_PN}.png"

	make_wrapper "${MY_PN}" "java -jar /opt/${MY_PN}/${MY_PN}.jar"
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
