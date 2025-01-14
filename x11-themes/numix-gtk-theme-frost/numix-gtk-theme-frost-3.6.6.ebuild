# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="numix-frost-themes"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A modern flat theme that supports Gnome, Unity, XFCE and Openbox."
HOMEPAGE="https://numixproject.github.io/"
SRC_URI="https://web.archive.org/web/20190522051621if_/http://mirrors.antergos.com/antergos/x86_64/${MY_P}-1-any.pkg.tar.xz"
S="${WORKDIR}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="x11-themes/gtk-engines-murrine"

src_install() {
	insinto /
	doins -r usr
}
