# Copyright 2026 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson gnome.org

DESCRIPTION="Thumbnailer for EPub and MOBI books"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-epub-thumbnailer"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	app-arch/libarchive:=
	dev-libs/glib:2
	dev-libs/libxml2:2=
	x11-libs/gdk-pixbuf:2[jpeg]"
DEPEND="${RDEPEND}"
