# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Runit scripts from the Void Linux project"
HOMEPAGE="https://github.com/void-linux/${PN}"
if [[ "${PV}" = 99999999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
fi

LICENSE="CC0-1.0"
SLOT="0"

RDEPEND="
	sys-apps/util-linux[tty-helpers]
	sys-process/runit
	!sys-apps/sysvinit"

PATCHES=( "${FILESDIR}/${PN}-gentoo.patch" )

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	# put sbin in the root
	mv "${D}/usr/sbin" "${D}"
	# remove dracut configuration
	rm -rf "${D}/usr/lib"

	keepdir /etc/zzz.d/{suspend,resume}
	dodoc README.md

	# compatibility symlink
	dosym /run/runit/runsvdir/current /var/service
	# provide init
	dosym runit-init /sbin/init
}
