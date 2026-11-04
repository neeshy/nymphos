# Copyright 2026 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Daemonless replacement for libudev"
HOMEPAGE="https://github.com/illiliti/libudev-zero"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="ISC"
SLOT="0"
IUSE="static-libs"

RDEPEND="
	!sys-apps/systemd
	!sys-apps/systemd-utils[udev]
	sys-apps/hwdata"
DEPEND="sys-kernel/linux-headers"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	local myemakeargs=( PREFIX="${EPREFIX}/usr" )
	emake "${myemakeargs[@]}" libudev.so.1
	use static-libs && emake "${myemakeargs[@]}" libudev.a
}

multilib_src_install() {
	local myemakeargs=( DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" )
	emake "${myemakeargs[@]}" install-shared
	use static-libs && emake "${myemakeargs[@]}" install-static
}
