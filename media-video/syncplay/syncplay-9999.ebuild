# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Client/server to synchronize media playback"
HOMEPAGE="https://syncplay.pl/"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Syncplay/${PN}.git"
elif [[ "${PV}" = *_beta* ]]; then
	MY_PV="${PV/_b/-B}"
	MY_PV_KLUDGE="${MY_PV/6\.8/68}"
	MY_P_KLUDGE="${PN}-${MY_PV_KLUDGE}"
	SRC_URI="https://github.com/Syncplay/${PN}/archive/${MY_PV_KLUDGE}.tar.gz -> ${MY_P_KLUDGE}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P_KLUDGE}"
else
	SRC_URI="https://github.com/Syncplay/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/certifi-2018.11.29[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.4.0[crypt,${PYTHON_USEDEP}]
"

src_prepare() {
	default
	sed -i -e '/installRequirements =/s/ +\\$//' \
		-e "/^ *read('requirements_gui.txt').splitlines()$/d" setup.py ||
		die "sed failed on setup.py"
	sed -i '/"noGui": /s/False/True/' syncplay/ui/ConfigurationGetter.py ||
		die "sed failed on ConfigurationGetter.py"
}
