# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

MY_PV="335dbece103e2cbf6c7cf819ab6672c2956b17b3"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Additional style plugins for Qt5"
HOMEPAGE="https://code.qt.io/cgit/qt/${PN}.git"
SRC_URI="https://github.com/qt/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="5"
KEYWORDS="~amd64"

RDEPEND="
	dev-qt/qtcore:5=
	dev-qt/qtgui:5=
	dev-qt/qtwidgets:5=
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/pango"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/fix-build-qt5.15.patch" )

src_configure() {
	cd "${S}/src/plugins/platformthemes/gtk2" || die "cd failed"
	eqmake5
	cd "${S}/src/plugins/styles/gtk2" || die "cd failed"
	eqmake5
}

src_compile() {
	cd "${S}/src/plugins/platformthemes/gtk2" || die "cd failed"
	emake
	cd "${S}/src/plugins/styles/gtk2" || die "cd failed"
	emake
}

src_install() {
	cd "${S}/src/plugins/platformthemes/gtk2" || die "cd failed"
	emake INSTALL_ROOT="${D}" install
	cd "${S}/src/plugins/styles/gtk2" || die "cd failed"
	emake INSTALL_ROOT="${D}" install
}
