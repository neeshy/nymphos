# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson-multilib systemd virtualx xdg

DESCRIPTION="D-Bus accessibility specifications and registration daemon"
HOMEPAGE="https://wiki.gnome.org/Accessibility https://gitlab.gnome.org/GNOME/at-spi2-core"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="amd64"
IUSE="X dbus gtk-doc +introspection systemd"

RESTRICT="!dbus? ( test )"

RDEPEND="
	>=dev-libs/glib-2.67.4:2[${MULTILIB_USEDEP}]
	dbus? (
		>=sys-apps/dbus-1.5[${MULTILIB_USEDEP}]
		>=dev-libs/libxml2-2.9.1:2[${MULTILIB_USEDEP}]
	)
	introspection? ( >=dev-libs/gobject-introspection-1.54.0:= )
	systemd? ( sys-apps/systemd[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXtst[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
	)

	!<dev-libs/atk-2.46.0
	!<app-accessibility/at-spi2-atk-2.46.0"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	gtk-doc? (
		dev-python/sphinx
		dev-util/gdbus-codegen
		>=dev-util/gi-docgen-2021.1
	)
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-more-build-fixes.patch"
	"${FILESDIR}/${P}-build-no-dbus-broker.patch"
	"${FILESDIR}/${PN}-atk-only-deps.patch"
)

multilib_src_configure() {
	local emesonargs=(
		-Dsystemd_user_dir="$(systemd_get_userunitdir)"
		$(meson_native_use_bool gtk-doc docs)
		$(meson_native_use_feature introspection)
		$(meson_use systemd use_systemd)
		$(meson_feature X x11)
		$(meson_native_use_bool !dbus atk_only)
		-Ddisable_p2p=false
	)
	meson_src_configure
}

multilib_src_test() {
	virtx dbus-run-session meson test -C "${BUILD_DIR}" || die
}

multilib_src_install_all() {
	einstalldocs

	if use gtk-doc; then
		if use dbus; then
			mkdir -p "${ED}/usr/share/gtk-doc/libatspi" || die
			mv "${ED}/usr/share/doc/libatspi" "${ED}/usr/share/gtk-doc/libatspi/html" || die
		fi
		mkdir -p "${ED}/usr/share/gtk-doc/atk" || die
		mv "${ED}/usr/share/doc/atk" "${ED}/usr/share/gtk-doc/atk/html" || die
	fi
}
