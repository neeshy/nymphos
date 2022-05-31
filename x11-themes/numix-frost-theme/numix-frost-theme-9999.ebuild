# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A modern flat theme that supports Gnome, Unity, XFCE and Openbox."
HOMEPAGE="https://numixproject.org"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Antergos/Numix-Frost.git"
else
	SRC_URI="https://github.com/Antergos/Numix-Frost/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/Numix-Frost-${PV}"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="x11-themes/gtk-engines-murrine"
DEPEND="${RDEPEND}
	dev-libs/glib:2
	dev-ruby/sass
	x11-libs/gdk-pixbuf:2
"
