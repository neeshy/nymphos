# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit git-r3 distutils-r1

DESCRIPTION="The uncompromising Python code formatter"
HOMEPAGE="https://black.readthedocs.io/en/stable/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/ambv/black.git"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="${PYTHON_DEPS}
>=dev-python/toml-0.9.6
>=dev-python/click-6.7
>=dev-python/attrs-17.4.0
>=dev-python/appdirs-1.4.3"
RDEPEND="${DEPEND}"

