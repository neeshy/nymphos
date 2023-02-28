# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Client/server to synchronize media playback"
HOMEPAGE="https://syncplay.pl/"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN^}/${PN}.git"
else
	SRC_URI="https://github.com/${PN^}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	>=dev-python/certifi-2018.11.29[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.4.0[ssl,${PYTHON_USEDEP}]"

src_prepare() {
	default
	sed -i -e '/installRequirements =/s/ +\\$//' \
		-e "/^ *read('requirements_gui.txt').splitlines()$/d" setup.py ||
		die "sed failed on setup.py"
	sed -i '/"noGui": /s/False/True/' syncplay/ui/ConfigurationGetter.py ||
		die "sed failed on ConfigurationGetter.py"
}
