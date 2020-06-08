# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit git-r3 distutils-r1

DESCRIPTION="A CLI tool to manage mods for OpenMW"
HOMEPAGE="https://gitlab.com/${PN}/${PN}/wikis/home"
EGIT_REPO_URI="https://gitlab.com/${PN}/${PN}.git"
if [[ "${PV}" != 9999 ]]; then
	EGIT_COMMIT="v${PV}"
	KEYWORDS="amd64 x86"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-python/pytest-runner[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"
RDEPEND="
	app-arch/patool[${PYTHON_USEDEP}]
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/black[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/GitPython[${PYTHON_USEDEP}]
	dev-python/progressbar2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/redbaron[${PYTHON_USEDEP}]
	dev-python/RestrictedPython[${PYTHON_USEDEP}]
"
