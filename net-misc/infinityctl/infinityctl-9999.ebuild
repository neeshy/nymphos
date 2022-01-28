# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 git-r3

DESCRIPTION="A command line interface for 8chan"
HOMEPAGE="https://gitgud.io/ring/${PN}"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="GPL-3+"
SLOT="0"
IUSE="ocr"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/urllib3[${PYTHON_USEDEP}]
	ocr? (
		app-text/tesseract
		virtual/imagemagick-tools
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-setup.py.patch"
	"${FILESDIR}/${PN}-unix_original-scrape-mode.patch"
	"${FILESDIR}/${PN}-file-name-length-limit.patch"
	"${FILESDIR}/${PN}-remove-defunct.patch"
	"${FILESDIR}/${PN}-8kun.top.patch"
	"${FILESDIR}/${PN}-smuglo.li.patch"
)
