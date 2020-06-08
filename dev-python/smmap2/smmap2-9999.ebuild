# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1

DESCRIPTION="A sliding memory map manager"
HOMEPAGE="https://github.com/gitpython-developers/smmap"
if [[ "${PV}" = 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="${HOMEPAGE}.git"
else
    SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="amd64 x86"
	S="${WORKDIR}/smmap-${PV}"
fi

LICENSE="BSD"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="!dev-python/smmap[${PYTHON_USEDEP}]"
