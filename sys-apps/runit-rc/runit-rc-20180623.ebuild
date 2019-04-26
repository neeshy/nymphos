# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Runit scripts from the Void Linux project"
HOMEPAGE="https://github.com/void-linux/void-runit"
SRC_URI="https://github.com/void-linux/void-runit/archive/${PV}.tar.gz -> void-runit-${PV}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	sys-process/runit
	sys-process/procps
	virtual/awk
"

PATCHES=(
	"${FILESDIR}/void-runit-net.patch"
	"${FILESDIR}/void-runit-modules-load.patch"
	"${FILESDIR}/void-runit-ctrlaltdel.patch"
	"${FILESDIR}/void-runit-gentoo.patch"
)

S="${WORKDIR}/void-runit-${PV}"

src_install() {
	emake DESTDIR="${D}" PREFIX=/ install

	# put man pages in the correct location
	dodir /usr
	mv "${D}/share" "${D}/usr"
	# remove dracut configuration
	rm -rf "${D}/lib"

	keepdir /etc/zzz.d/{suspend,resume}
	dodoc README.md
	# provide init
	dosym runit-init /sbin/init
}
