# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME_ORG_MODULE="at-spi2-core"

inherit gnome.org meson-multilib xdg

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE="gtk-doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.67.4:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.54.0:= )
	!>=app-accessibility/at-spi2-core-2.46.0"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/at-spi2-core-split-atk.patch" )

multilib_src_configure() {
	local emesonargs=(
		"$(meson_native_use_bool gtk-doc docs)"
		"$(meson_native_use_feature introspection)"
	)
	meson_src_configure
}
