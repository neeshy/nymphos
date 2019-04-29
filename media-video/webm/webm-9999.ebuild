# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python2_7 python3_{2,3,4,5,6,7} )

inherit distutils-r1 git-r3

DESCRIPTION="Cross-platform command-line WebM converter"
HOMEPAGE="https://github.com/Kagami/webm.py"
EGIT_REPO_URI="https://github.com/Kagami/webm.py.git"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=media-video/ffmpeg-2.0.0"

S="${WORKDIR}/${PN}.py"
