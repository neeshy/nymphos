# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools gnome2-utils xdg

DESCRIPTION="Display GTK+ dialog boxes from command line or shell scripts"
HOMEPAGE="https://github.com/v1cont/${PN}"
SRC_URI="${HOMEPAGE}/archive/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nls sourceview spell webkit"

RDEPEND="
	>=x11-libs/gtk+-3.22.0:3
	sourceview? ( >=x11-libs/gtksourceview-3.18.0:3.0= )
	spell? ( app-text/gspell:= )
	webkit? ( net-libs/webkit-gtk:4.1 )"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/autoconf-2.59
	>=dev-build/automake-1.11
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

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

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
