# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="Support for extra binary formats"
HOMEPAGE="http://binfmt-support.nongnu.org/"
SRC_URI="https://git.savannah.gnu.org/cgit/binfmt-support.git/snapshot/binfmt-support-${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="systemd"

DEPENDS="
	dev-libs/libpipeline
	dev-vcs/git
	sys-devel/libtool
	virtual/pkgconfig
"
RDEPENDS="systemd? ( sys-apps/systemd )"

src_prepare() {
	default
	./bootstrap
}

src_configure() {
	econf \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--enable-openrc \
		--disable-upstart \
		"$(use_enable systemd)"
}
