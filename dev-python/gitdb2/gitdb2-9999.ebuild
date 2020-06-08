# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1

DESCRIPTION="GitDB is a pure-Python git object database"
HOMEPAGE="https://github.com/gitpython-developers/gitdb"
if [[ "${PV}" = 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="${HOMEPAGE}.git"
else
    SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="amd64 x86"
	S="${WORKDIR}/gitdb-${PV}"
fi

LICENSE="BSD"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!dev-python/gitdb[${PYTHON_USEDEP}]
	>=dev-python/smmap2-3.0.1[${PYTHON_USEDEP}]
"
