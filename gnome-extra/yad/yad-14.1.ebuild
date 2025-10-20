# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="Display GTK+ dialog boxes from command line or shell scripts"
HOMEPAGE="https://github.com/v1cont/yad"
SRC_URI="${HOMEPAGE}/archive/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nls sourceview spell webkit"

RDEPEND="
	>=x11-libs/gtk+-3.22.0:3
	sourceview? ( >=x11-libs/gtksourceview-3.18.0:3.0= )
	spell? ( app-text/gspell:= )
	webkit? ( net-libs/webkit-gtk:4.1= )"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/autoconf-2.59
	>=dev-build/automake-1.11
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	econf \
		"$(use_enable nls)" \
		"$(use_enable sourceview)" \
		"$(use_enable spell)" \
		"$(use_enable webkit html)" \
		--disable-standalone \
		--enable-icon-browser \
		--enable-tools \
		--enable-tray
}
