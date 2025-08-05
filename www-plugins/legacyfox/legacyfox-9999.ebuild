# Copyright 2025 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="LegacyFox"
MY_COMMIT="836dade"
MY_PV="${PV}-${MY_COMMIT}"
MY_P="${MY_PN}-v${MY_PV}"

DESCRIPTION="Legacy bootstrapped extensions for Firefox 65 and beyond"
HOMEPAGE="https://git.gir.st/LegacyFox.git"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/snapshot/v${PV}.tar.gz -> ${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64"
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
