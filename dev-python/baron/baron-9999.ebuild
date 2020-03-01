# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Full Syntax Tree for python to make writing refactoring code a realist task"
HOMEPAGE="http://${PN}.pycqa.org/"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PyCQA/${PN}.git"
else
	SRC_URI="https://github.com/PyCQA/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi


LICENSE="LGPL-3+"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/rply[${PYTHON_USEDEP}]"
