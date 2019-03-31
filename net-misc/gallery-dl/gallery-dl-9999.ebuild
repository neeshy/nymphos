# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{4,5,6,7} )

inherit distutils-r1 git-r3

DESCRIPTION="Command-line tool to download image galleries from several image hosting sites"
HOMEPAGE="https://github.com/mikf/gallery-dl"
SRC_URI="https://github.com/mikf/gallery-dl.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}"
