# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="Legacy bootstrapped extensions for Firefox 65 and beyond"
HOMEPAGE="https://github.com/girst/LegacyFox"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/LegacyFox-${PV}"
fi

LICENSE="MPL-2.0"
SLOT="0"

src_compile() {
	:
}

src_install() {
	insinto "/usr/$(get_libdir)/firefox"
	doins config.js legacy.manifest
	doins -r defaults legacy
}
