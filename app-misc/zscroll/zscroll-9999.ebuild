# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A text scroller for panels or terminals"
HOMEPAGE="https://github.com/noctuid/${PN}"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="BSD-2"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	sed -i '\|share/licenses/zscroll|d' setup.py
	default
}
