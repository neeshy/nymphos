# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

MY_PV="${PV//./-}"
MY_PV_KLUDGE="2011-05-03"

DESCRIPTION="Message board and file sharing client for freenet network"
HOMEPAGE="http://jtcfrost.sourceforge.net/"
SRC_URI="https://sourceforge.net/projects/jtcfrost/files/frost/${MY_PV}/frost_source-${MY_PV_KLUDGE}.rar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	>=virtual/jdk-1.6
	dev-java/ant-core
"
RDEPEND="
	>=virtual/jre-1.6
	net-p2p/freenet
"

PATCHES=( "${FILESDIR}/${PN}-base64.patch" )

S="${WORKDIR}/frost_source"

EANT_BUILD_TARGET="distro"

src_prepare() {
	default
	java-utils-2_src_prepare
}

src_install() {
	newbin "${FILESDIR}/frost.sh" frost
	cd build/dist
	insinto /opt/frost
	doins -r config doc help lib
	doins frost.jar jtc.ico readme.{de,en,fr}.txt
}
