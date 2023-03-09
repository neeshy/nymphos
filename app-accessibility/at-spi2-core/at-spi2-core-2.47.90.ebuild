# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="D-Bus accessibility specifications and registration daemon"
HOMEPAGE="https://wiki.gnome.org/Accessibility https://gitlab.gnome.org/GNOME/at-spi2-core"

SLOT="2"
KEYWORDS="amd64"
IUSE="+introspection"

RDEPEND=">=dev-libs/atk-${PV}[introspection?,${MULTILIB_USEDEP}]"
