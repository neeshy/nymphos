# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

DESCRIPTION="Comprehensive list of udev rules to connect to android devices"
HOMEPAGE="https://github.com/M0Rf30/${PN}"
if [[ "${PV}" = 99999999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	acct-group/adbusers
	virtual/udev"
DEPEND="${RDEPEND}"

src_install() {
	udev_dorules 51-android.rules
}
