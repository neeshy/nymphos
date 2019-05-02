# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_7 )

inherit distutils-r1 git-r3

DESCRIPTION="A python interface for imageboards"
HOMEPAGE="https://gitgud.io/ring/imbpy"
EGIT_REPO_URI="https://gitgud.io/ring/imbpy.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${PN}-setup.py.patch" )
