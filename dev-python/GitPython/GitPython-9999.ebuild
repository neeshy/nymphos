# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A python library used to interact with Git repositories"
HOMEPAGE="https://github.com/gitpython-developers/${PN}"
if [[ "${PV}" = 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="${HOMEPAGE}.git"
else
    SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="amd64 x86"
fi

LICENSE="BSD"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/gitdb2-4.0.1[${PYTHON_USEDEP}]"
