# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Modular initramfs image creation utility"
HOMEPAGE="https://github.com/archlinux/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	app-arch/zstd
	sys-apps/busybox"

PATCHES=(
	"${FILESDIR}/${PN}-busybox.patch"
	"${FILESDIR}/${PN}-consolefont.patch"
	"${FILESDIR}/${PN}-keymaps.patch"
)
