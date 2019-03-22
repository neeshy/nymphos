# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Artix Linux system initialization and shutdown for runit"
HOMEPAGE="https://artixlinux.org/"
SRC_URI="
	https://gitea.artixlinux.org/artix/runit-rc/archive/master.tar.gz -> runit-rc-master.tar.gz
	https://gitea.artixlinux.org/artix/runit-artix/archive/master.tar.gz -> runit-artix-master.tar.gz
	https://github.com/void-linux/void-runit/archive/master.tar.gz -> void-runit-master.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""

RDEPEND="sys-process/runit"

S="${WORKDIR}"

src_prepare() {
	eapply_user

	cd "${S}/runit-rc"
	eapply "${FILESDIR}/${PN}-bugfixes.patch"
	eapply "${FILESDIR}/${PN}-network.patch"

	cd "${S}/runit-artix"
	eapply "${FILESDIR}/${PN}-rc.shutdown.patch"
	eapply "${FILESDIR}/${PN}-ctrlaltdel.patch"
}

src_compile() {
	cd "${S}/runit-rc"
	emake BINDIR=/bin RCLIBDIR=/etc/rc

	cd "${S}/runit-artix"
	emake BINDIR=/bin RCLIBDIR=/etc/rc SVDIR=/etc/sv SERVICEDIR=/run/runit/service

	cd "${S}/void-runit-master"
	emake
}

src_install() {
	cd "${S}/runit-rc"
	emake DESTDIR="${D}" BINDIR=/bin RCLIBDIR=/etc/rc install

	cd "${S}/runit-artix"
	emake DESTDIR="${D}" BINDIR=/bin RCLIBDIR=/etc/rc SVDIR=/etc/sv SERVICEDIR=/run/runit/service install

	cd "${S}/void-runit-master"
	dosbin halt shutdown
	dosym halt /sbin/poweroff
	dosym halt /sbin/reboot
	doman shutdown.8 halt.8
	dosym halt.8 /usr/share/man/man8/poweroff
	dosym halt.8 /usr/share/man/man8/reboot
}
