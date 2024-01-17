# Copyright 2024 NymphOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Legacy bootstrapped extensions for Firefox 65 and beyond"
HOMEPAGE="https://git.gir.st/LegacyFox.git"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	MY_COMMIT="fc77a6a"
	MY_PV="${PV}-${MY_COMMIT}"
	MY_P="LegacyFox-v${MY_PV}"
	SRC_URI="${HOMEPAGE}/snapshot/v${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="amd64"
	S="${WORKDIR}/${MY_P}"
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
