# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="System startup/shutdown scripts for runit from the Artix Linux project"
HOMEPAGE="https://artixlinux.org/"
RC_COMMIT="a6df81b8fbda1e5611a71e80fd61259291154ec9"
ARTIX_COMMIT="8eec042261ed661616b451ab7335f22fdf33a5d3"
VOID_COMMIT="0566391df8c9c93f75ad99d94c8a19abe379908b"
SRC_URI="
	https://gitea.artixlinux.org/artix/runit-rc/archive/${RC_COMMIT}.tar.gz -> runit-rc-${RC_COMMIT}.tar.gz
	https://gitea.artixlinux.org/artix/runit-artix/archive/${ARTIX_COMMIT}.tar.gz -> runit-artix-${ARTIX_COMMIT}.tar.gz
	https://github.com/void-linux/void-runit/archive/${VOID_COMMIT}.tar.gz -> void-runit-${VOID_COMMIT}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-process/runit"

S="${WORKDIR}"

src_prepare() {
	cd "${S}/runit-rc"
	eapply "${FILESDIR}/runit-rc-bugfixes.patch"
	eapply "${FILESDIR}/runit-rc-network.patch"
	eapply "${FILESDIR}/runit-rc-ctrlaltdel.patch"

	cd "${S}/runit-artix"
	eapply "${FILESDIR}/runit-artix-rc.shutdown.patch"
	eapply "${FILESDIR}/runit-artix-ctrlaltdel.patch"
	eapply "${FILESDIR}/runit-artix-servicedir.patch"

	cd "${S}"
	eapply_user
}

src_compile() {
	cd "${S}/runit-rc"
	emake BINDIR=/bin RCLIBDIR=/etc/rc

	cd "${S}/runit-artix"
	emake BINDIR=/bin RCLIBDIR=/etc/rc SVDIR=/etc/sv SERVICEDIR=/var/service

	cd "${S}/void-runit-${VOID_COMMIT}"
	emake
}

src_install() {
	cd "${S}/runit-rc"
	emake DESTDIR="${D}" BINDIR=/bin RCLIBDIR=/etc/rc install

	cd "${S}/runit-artix"
	emake DESTDIR="${D}" BINDIR=/bin RCLIBDIR=/etc/rc SVDIR=/etc/sv SERVICEDIR=/var/service install

	cd "${S}/void-runit-${VOID_COMMIT}"
	into /
	dosbin halt shutdown
	dosym halt /sbin/poweroff
	dosym halt /sbin/reboot
	doman shutdown.8 halt.8
	dosym halt.8 /usr/share/man/man8/poweroff
	dosym halt.8 /usr/share/man/man8/reboot
}
