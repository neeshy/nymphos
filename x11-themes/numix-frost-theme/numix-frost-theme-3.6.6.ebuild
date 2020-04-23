# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A modern flat theme that supports Gnome, Unity, XFCE and Openbox."
HOMEPAGE="https://numixproject.org"
SRC_URI="http://mirrors.antergos.com/antergos/x86_64/${PN}s-${PV}-1-any.pkg.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-themes/gtk-engines-murrine"

S="${WORKDIR}"

src_install() {
	insinto /
	doins -r usr
}
