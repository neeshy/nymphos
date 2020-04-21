# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Cross-platform command-line WebM converter"
HOMEPAGE="https://github.com/Kagami/${PN}.py"
if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${PN}.py-${PV}.tar.gz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/${PN}.py-${PV}"
fi

LICENSE="CC0-1.0"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=media-video/ffmpeg-2.0.0"
