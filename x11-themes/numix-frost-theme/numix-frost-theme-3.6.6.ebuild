# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A modern flat theme that supports Gnome, Unity, XFCE and Openbox."
HOMEPAGE="https://numixproject.org"
SRC_URI="http://mirrors.antergos.com/antergos/x86_64/${PN}s-${PV}-1-any.pkg.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	x11-themes/gtk-engines-murrine
	dev-libs/glib:2
	x11-libs/gdk-pixbuf
"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack(){
	unpack "${A}"
}

src_install() {
	insinto /
	doins -r usr
}
