# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN%-bin}s"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A modern flat theme that supports Gnome, Unity, XFCE and Openbox."
HOMEPAGE="https://numixproject.org"
SRC_URI="https://web.archive.org/web/20190522051621if_/http://mirrors.antergos.com/antergos/x86_64/${MY_P}-1-any.pkg.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-themes/gtk-engines-murrine"

S="${WORKDIR}"

src_install() {
	insinto /
	doins -r usr
}
