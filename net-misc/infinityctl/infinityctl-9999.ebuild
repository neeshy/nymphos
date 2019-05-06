# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{1,2,3,4,5,6,7} )

inherit distutils-r1 git-r3

DESCRIPTION="A command line interface for 8chan"
HOMEPAGE="https://gitgud.io/ring/${PN}"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="GPL-3+"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/urllib3[${PYTHON_USEDEP}]
	app-text/tesseract
	media-gfx/imagemagick
"

PATCHES=(
	"${FILESDIR}/${PN}-scrape-unix_original.patch"
	"${FILESDIR}/${PN}-filename-length-fix.patch"
	"${FILESDIR}/${PN}-setup.py.patch"
)
